package ly.img.editor.flutter.showcases

import android.app.Activity
import io.flutter.embedding.engine.FlutterEngine

/**
 * Release no-op. The snapshot-test bridge (UiAutomation capture + editor cleanup) exists only in
 * the `debug` variant so the production app never depends on `androidx.test`.
 */
object SnapshotChannel {
    fun register(
        engine: FlutterEngine,
        activity: Activity,
    ) = Unit
}
