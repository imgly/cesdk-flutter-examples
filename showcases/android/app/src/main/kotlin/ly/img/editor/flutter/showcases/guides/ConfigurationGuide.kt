package ly.img.editor.flutter.showcases.guides

// #highlight-import
import androidx.compose.runtime.Composable
import ly.img.editor.flutter.plugin.IMGLYEditorPlugin
import ly.img.editor.flutter.plugin.builder.EditorBuilder
import ly.img.editor.flutter.plugin.builder.EditorBuilderResult
import ly.img.editor.flutter.plugin.model.EditorSettings
// #highlight-import

private fun useCustomEditor() {
    // #highlight-closure
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
    // #highlight-closure
}

@Composable
private fun CustomEditor(
    settings: EditorSettings,
    result: EditorBuilderResult,
    onClose: (Throwable?) -> Unit,
) {}
