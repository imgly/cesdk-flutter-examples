package ly.img.editor.flutter.showcases.guides

// highlight-import-kotlin
import androidx.compose.runtime.Composable
import ly.img.camera.core.CameraLayoutMode
import ly.img.camera.core.CameraMode
import ly.img.camera.core.CameraResult
import ly.img.camera.core.CaptureVideo
import ly.img.camera.flutter.plugin.IMGLYCameraPlugin
import ly.img.editor.flutter.plugin.IMGLYEditorPlugin
import ly.img.editor.flutter.plugin.builder.EditorBuilder
import ly.img.editor.flutter.plugin.builder.EditorBuilderResult
import ly.img.editor.flutter.plugin.model.EditorSettings

// highlight-import-kotlin

private fun useCustomEditor() {
    // highlight-closure-kotlin
    IMGLYEditorPlugin.builderClosure = { _, metadata ->
        if (metadata?.get("custom") == true) {
            EditorBuilder.custom { settings, _, _, result, onClose ->
                @Composable {
                    CustomEditor(settings, result, onClose)
                }
            }
        } else {
            EditorBuilder.design()
        }
    }
    // highlight-closure-kotlin
}

private fun customizeCamera() {
    // highlight-camera-configuration-kotlin
    // highlight-camera-configuration-closure-kotlin
    // Configure the [CaptureVideo.Input].
    IMGLYCameraPlugin.configurationClosure = {
        /*
         * This closure requires returning a [CaptureVideo.Input].
         *
         * You can access the following parameters:
         * - "cameraSettings": The CameraSettings passed from the Flutter side.
         * - "engineConfiguration": The EngineConfiguration that includes your license.
         * - "metadata": Metadata passed from the Flutter side.
         * - "videoUri": The video reaction URL passed from Flutter, or null.
         */

        if (metadata["is_reactions"] == true) {
            CaptureVideo.Input(
                engineConfiguration = engineConfiguration,
                cameraMode = CameraMode.Reaction(
                    videoUri ?: throw RuntimeException("Missing video URL."),
                    cameraLayoutMode = CameraLayoutMode.Horizontal,
                    positionsSwapped = false,
                ),
            )
        } else {
            // Simply return null to use the default camera configuration.
            null
        }
    }

    // highlight-camera-configuration-closure-kotlin
    // highlight-camera-result-closure-kotlin
    // Adding custom metadata to the CameraResult.
    IMGLYCameraPlugin.resultClosure = {
        /*
         * This closure allows you to add custom metadata of type [Map<String, Any?>] to the CameraResult.
         * You can access the following values:
         * - "cameraResult": The native CameraResult returned by the camera.
         * - "inputMetadata": Metadata passed from the Flutter side when the camera was opened.
         *
         * The return value must be a [Map<String, Any?>], which will be passed to the Dart-side
         * representation of the CameraResult.
         *
         * Notes:
         * - Use `mapOf<String, Any?>()` to return key-value pairs.
         * - Return `null` if no metadata should be added.
         */

        // Example: Read the result data...
        val recordings = when (val result = cameraResult) {
            is CameraResult.Record -> result.recordings
            is CameraResult.Reaction -> result.reaction
            else -> emptyList()
        }

        // Return a custom metadata map
        mapOf(
            "MY_CUSTOM_KEY" to "MY_CUSTOM_VALUE",
        )
    }
    // highlight-camera-result-closure-kotlin
    // highlight-camera-configuration-kotlin
}

@Composable
private fun CustomEditor(
    settings: EditorSettings,
    result: EditorBuilderResult,
    onClose: (Throwable?) -> Unit,
) {
}
