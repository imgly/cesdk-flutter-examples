package ly.img.editor.flutter.showcases.guides

// highlight-import-kotlin
import androidx.compose.runtime.Composable
import androidx.core.net.toUri
import kotlinx.coroutines.CancellationException
import ly.img.editor.Editor
import ly.img.editor.configuration.video.VideoConfigurationBuilder
import ly.img.editor.configuration.video.callback.onCreate
import ly.img.editor.configuration.video.callback.onExport
import ly.img.editor.configuration.video.model.ExportStatus
import ly.img.editor.core.configuration.EditorConfiguration
import ly.img.editor.core.configuration.remember
import ly.img.editor.flutter.plugin.IMGLYEditorPlugin
import ly.img.editor.flutter.plugin.builder.EditorBuilder
import ly.img.editor.flutter.plugin.builder.EditorBuilderDefaults
import ly.img.editor.flutter.plugin.builder.EditorBuilderResult
import ly.img.editor.flutter.plugin.model.EditorPreset
import ly.img.editor.flutter.plugin.model.EditorSettings
import ly.img.engine.MimeType

// highlight-import-kotlin

private fun useWebmVideoEditor() {
    // highlight-closure-kotlin
    IMGLYEditorPlugin.builderClosure = { preset, _ ->
        if (preset == EditorPreset.VIDEO) {
            EditorBuilder.custom { settings, _, _, result, onClose ->
                @Composable {
                    WebmVideoEditor(settings, result, onClose)
                }
            }
        } else {
            EditorBuilder.design()
        }
    }
    // highlight-closure-kotlin
}

// highlight-editor-kotlin
@Composable
private fun WebmVideoEditor(
    settings: EditorSettings,
    result: EditorBuilderResult,
    onClose: (Throwable?) -> Unit,
) {
    Editor(
        license = settings.license,
        baseUri = settings.baseUri.toUri(),
        userId = settings.userId,
        configuration = {
            EditorConfiguration.remember(::VideoConfigurationBuilder) {
                onCreate = {
                    onCreate(
                        createScene = {
                            EditorBuilderDefaults.onCreateScene(
                                scope = this@Editor,
                                settings = settings,
                                defaultUri = "file:///android_asset/scene/video.scene".toUri(),
                            )
                        },
                    )
                }
                onExport = {
                    onExport(
                        exportByteBuffer = {
                            val engine = editorContext.engine
                            val page = requireNotNull(engine.scene.getCurrentPage())
                            engine.block.exportVideo(
                                block = page,
                                timeOffset = 0.0,
                                duration = engine.block.getDuration(page),
                                mimeType = MimeType.WEBM,
                                progressCallback = { progress ->
                                    exportStatus = ExportStatus.Loading(
                                        progress = progress.encodedFrames.toFloat() / progress.totalFrames,
                                    )
                                },
                            )
                        },
                        postExport = {
                            val editorResult = EditorBuilderDefaults.getExportResult(
                                scope = this@Editor,
                                byteBuffer = it,
                                mimeType = MimeType.WEBM,
                            )
                            exportStatus = null
                            result(Result.success(editorResult))
                        },
                        error = {
                            exportStatus = null
                            if (it !is CancellationException) {
                                result(Result.failure(it))
                            }
                        },
                    )
                }
            }
        },
    ) {
        onClose(it)
    }
}
// highlight-editor-kotlin
