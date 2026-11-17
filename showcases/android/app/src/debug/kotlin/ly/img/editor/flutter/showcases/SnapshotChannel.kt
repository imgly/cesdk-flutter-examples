package ly.img.editor.flutter.showcases

import android.app.Activity
import android.app.Application
import android.app.Instrumentation
import android.app.UiAutomation
import android.graphics.Bitmap
import android.os.Bundle
import android.os.Environment
import android.os.ParcelFileDescriptor
import androidx.test.platform.app.InstrumentationRegistry
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import ly.img.engine.Engine
import java.io.File
import java.io.FileOutputStream

/**
 * Debug-only screenshot + cleanup bridge used by `integration_test/app_test.dart` on Android.
 */
object SnapshotChannel {
    private const val CLEANUP_CHANNEL = "native_cleanup"
    private const val SNAPSHOT_CHANNEL = "imgly_snapshot"
    private const val SCREENSHOT_DIR = "imgly_flutter_screenshots"

    private var currentActivity: Activity? = null
    private var lifecycleRegistered = false
    private var statusBarNormalized = false

    fun register(
        engine: FlutterEngine,
        activity: Activity,
    ) {
        Engine.`$disableInternalDeployMode` = true

        registerLifecycleTracking(activity.application)

        val messenger = engine.dartExecutor.binaryMessenger

        MethodChannel(messenger, SNAPSHOT_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "warmUp" -> warmUp(result)
                "capture" -> {
                    val name = call.argument<String>("name")
                    if (name.isNullOrBlank()) {
                        result.error("invalid_arguments", "Missing screenshot name", null)
                    } else {
                        capture(name, result)
                    }
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(messenger, CLEANUP_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "cleanUp" -> {
                    cleanUp()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun registerLifecycleTracking(application: Application) {
        if (lifecycleRegistered) return
        lifecycleRegistered = true
        application.registerActivityLifecycleCallbacks(
            object : Application.ActivityLifecycleCallbacks {
                override fun onActivityResumed(activity: Activity) {
                    currentActivity = activity
                }

                override fun onActivityPaused(activity: Activity) {
                    if (currentActivity === activity) currentActivity = null
                }

                override fun onActivityCreated(
                    activity: Activity,
                    savedInstanceState: Bundle?,
                ) = Unit

                override fun onActivityStarted(activity: Activity) = Unit

                override fun onActivityStopped(activity: Activity) = Unit

                override fun onActivitySaveInstanceState(
                    activity: Activity,
                    outState: Bundle,
                ) = Unit

                override fun onActivityDestroyed(activity: Activity) = Unit
            },
        )
    }

    private fun warmUp(result: MethodChannel.Result) {
        val instrumentation = InstrumentationRegistry.getInstrumentation()
        val uiAutomation = instrumentation.uiAutomation
        Thread {
            try {
                normalizeStatusBar(uiAutomation)
                deliver(instrumentation) { result.success(null) }
            } catch (t: Throwable) {
                deliver(instrumentation) { result.error("warmup_failed", t.message, null) }
            }
        }.start()
    }

    private fun capture(
        name: String,
        result: MethodChannel.Result,
    ) {
        val instrumentation = InstrumentationRegistry.getInstrumentation()
        val uiAutomation = instrumentation.uiAutomation

        // takeScreenshot() blocks, so run it off the platform thread and hop back to deliver the
        // MethodChannel result (Flutter requires results on the platform/main thread).
        Thread {
            try {
                normalizeStatusBar(uiAutomation)
                val bitmap = uiAutomation.takeScreenshot()
                    ?: throw IllegalStateException("UiAutomation returned no screenshot")
                val file = writePng(name, bitmap)
                bitmap.recycle()
                deliver(instrumentation) { result.success(file.absolutePath) }
            } catch (t: Throwable) {
                deliver(instrumentation) { result.error("capture_failed", t.message, null) }
            }
        }.start()
    }

    private fun deliver(
        instrumentation: Instrumentation,
        block: () -> Unit,
    ) {
        instrumentation.runOnMainSync(block)
    }

    private fun writePng(
        name: String,
        bitmap: Bitmap,
    ): File {
        val downloads = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val dir = File(downloads, SCREENSHOT_DIR)
        if (!dir.exists() && !dir.mkdirs()) {
            throw IllegalStateException("Unable to create screenshot directory: $dir")
        }
        val file = File(dir, "$name.png")
        FileOutputStream(file).use { out ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
        }
        return file
    }

    /**
     * Freezes the status bar (fixed clock, full battery, no notifications) via SystemUI demo mode
     * so captured frames are deterministic — the Android analog of iOS
     * `simctl status_bar override --time 9:41`. Runs once per process.
     */
    private fun normalizeStatusBar(uiAutomation: UiAutomation) {
        if (statusBarNormalized) return
        statusBarNormalized = true
        exec(uiAutomation, "settings put global sysui_demo_allowed 1")
        exec(uiAutomation, "am broadcast -a com.android.systemui.demo -e command enter")
        exec(uiAutomation, "am broadcast -a com.android.systemui.demo -e command clock -e hhmm 0941")
        exec(uiAutomation, "am broadcast -a com.android.systemui.demo -e command battery -e level 100 -e plugged false")
        exec(uiAutomation, "am broadcast -a com.android.systemui.demo -e command notifications -e visible false")
        exec(uiAutomation, "am broadcast -a com.android.systemui.demo -e command network -e wifi show -e level 4")
    }

    private fun exec(
        uiAutomation: UiAutomation,
        command: String,
    ) {
        // Drain stdout so the shell command runs to completion before returning.
        ParcelFileDescriptor.AutoCloseInputStream(uiAutomation.executeShellCommand(command)).use { stream ->
            val buffer = ByteArray(1024)
            @Suppress("ControlFlowWithEmptyBody")
            while (stream.read(buffer) != -1) {
            }
        }
    }

    private fun cleanUp() {
        val activity = currentActivity ?: return
        activity.runOnUiThread { activity.finish() }
    }
}
