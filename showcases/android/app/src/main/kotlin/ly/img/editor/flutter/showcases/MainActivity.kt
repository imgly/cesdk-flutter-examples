package ly.img.editor.flutter.showcases

import android.net.Uri
import androidx.compose.runtime.Composable
import io.flutter.embedding.android.FlutterActivity
import ly.img.editor.ApparelEditor
import ly.img.editor.DesignEditor
import ly.img.editor.EditorConfiguration
import ly.img.editor.EngineConfiguration
import ly.img.editor.PhotoEditor
import ly.img.editor.PostcardEditor
import ly.img.editor.core.library.AssetLibrary
import ly.img.editor.core.library.AssetType
import ly.img.editor.core.library.LibraryCategory
import ly.img.editor.core.library.LibraryContent
import ly.img.editor.core.library.addSection
import ly.img.editor.core.library.data.AssetSourceType
import ly.img.editor.flutter.plugin.IMGLYEditorPlugin
import ly.img.editor.flutter.plugin.builder.Builder
import ly.img.editor.flutter.plugin.builder.EditorBuilder
import ly.img.editor.flutter.plugin.builder.EditorBuilderDefaults
import ly.img.editor.flutter.plugin.builder.EditorBuilderResult
import ly.img.editor.flutter.plugin.model.EditorPreset
import ly.img.editor.flutter.plugin.model.EditorSettings
import ly.img.editor.flutter.plugin.model.EditorSourceType
import ly.img.editor.rememberForApparel
import ly.img.editor.rememberForDesign
import ly.img.editor.rememberForPhoto
import ly.img.editor.rememberForPostcard
import ly.img.engine.MimeType

class MainActivity : FlutterActivity() {
    private val unsplashAssetSource = UnsplashAssetSource(Secrets.unsplashHost)
    private val unsplashSection =
        LibraryContent.Section(
            titleRes = R.string.unsplash,
            sourceTypes = listOf(AssetSourceType(sourceId = unsplashAssetSource.sourceId)),
            assetType = AssetType.Image,
        )
    private val assetLibrary =
        AssetLibrary.getDefault(
            images = LibraryCategory.Images.addSection(unsplashSection),
        )

    override fun onStart() {
        super.onStart()

        IMGLYEditorPlugin.builderClosure = { preset, metadata ->
            when (preset) {
                EditorPreset.APPAREL -> {
                    val customBuilder =
                        EditorBuilder.custom { settings, _, _, result, onClose ->
                            @Composable {
                                CustomApparelEditor(settings, result, onClose)
                            }
                        }
                    builderOrCustom(EditorBuilder.apparel(), customBuilder, metadata)
                }

                EditorPreset.POSTCARD -> {
                    val customBuilder =
                        EditorBuilder.custom { settings, _, _, result, onClose ->
                            @Composable {
                                CustomPostcardEditor(settings, result, onClose)
                            }
                        }
                    builderOrCustom(EditorBuilder.postcard(), customBuilder, metadata)
                }

                EditorPreset.PHOTO -> {
                    val customBuilder =
                        EditorBuilder.custom { settings, _, _, result, onClose ->
                            @Composable {
                                CustomPhotoEditor(settings, result, onClose)
                            }
                        }
                    builderOrCustom(EditorBuilder.photo(), customBuilder, metadata)
                }

                EditorPreset.DESIGN -> {
                    val customBuilder =
                        EditorBuilder.custom { settings, _, _, result, onClose ->
                            @Composable {
                                CustomDesignEditor(settings, result, onClose)
                            }
                        }
                    builderOrCustom(EditorBuilder.design(), customBuilder, metadata)
                }

                null -> {
                    val customBuilder =
                        EditorBuilder.custom { settings, _, _, result, onClose ->
                            @Composable {
                                CustomDesignEditor(settings, result, onClose)
                            }
                        }
                    builderOrCustom(EditorBuilder.design(), customBuilder, metadata)
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()

        IMGLYEditorPlugin.builderClosure = null
    }

    @Composable
    fun CustomApparelEditor(
        settings: EditorSettings,
        result: EditorBuilderResult,
        onClose: (Throwable?) -> Unit,
    ) {
        val engineConfiguration =
            EngineConfiguration.remember(
                license = settings.license,
                baseUri = Uri.parse(settings.baseUri),
                userId = settings.userId,
                onCreate = {
                    EditorBuilderDefaults.onCreate(
                        engine = editorContext.engine,
                        eventHandler = editorContext.eventHandler,
                        settings = settings,
                        defaultScene = EngineConfiguration.defaultApparelSceneUri,
                    )
                    editorContext.engine.asset.addSource(unsplashAssetSource)
                },
                onExport = {
                    val export =
                        EditorBuilderDefaults.onExport(
                            engine = editorContext.engine,
                            eventHandler = editorContext.eventHandler,
                            mimeType = MimeType.PDF,
                        )
                    result(Result.success(export))
                },
            )
        val editorConfiguration =
            EditorConfiguration.rememberForApparel(
                assetLibrary = assetLibrary,
            )
        ApparelEditor(
            engineConfiguration = engineConfiguration,
            editorConfiguration = editorConfiguration,
        ) {
            onClose(it)
        }
    }

    @Composable
    fun CustomDesignEditor(
        settings: EditorSettings,
        result: EditorBuilderResult,
        onClose: (Throwable?) -> Unit,
    ) {
        val engineConfiguration =
            EngineConfiguration.remember(
                license = settings.license,
                baseUri = Uri.parse(settings.baseUri),
                userId = settings.userId,
                onCreate = {
                    EditorBuilderDefaults.onCreate(
                        engine = editorContext.engine,
                        eventHandler = editorContext.eventHandler,
                        settings = settings,
                        defaultScene = EngineConfiguration.defaultDesignSceneUri,
                    )
                    editorContext.engine.asset.addSource(unsplashAssetSource)
                },
                onExport = {
                    val export =
                        EditorBuilderDefaults.onExport(
                            engine = editorContext.engine,
                            eventHandler = editorContext.eventHandler,
                            mimeType = MimeType.PDF,
                        )
                    result(Result.success(export))
                },
            )
        val editorConfiguration =
            EditorConfiguration.rememberForDesign(
                assetLibrary = assetLibrary,
            )
        DesignEditor(
            engineConfiguration = engineConfiguration,
            editorConfiguration = editorConfiguration,
        ) {
            onClose(it)
        }
    }

    @Composable
    fun CustomPhotoEditor(
        settings: EditorSettings,
        result: EditorBuilderResult,
        onClose: (Throwable?) -> Unit,
    ) {
        val engineConfiguration =
            EngineConfiguration.remember(
                license = settings.license,
                baseUri = Uri.parse(settings.baseUri),
                userId = settings.userId,
                onCreate = {
                    EditorBuilderDefaults.onCreate(
                        engine = editorContext.engine,
                        eventHandler = editorContext.eventHandler,
                        settings = settings,
                        defaultScene = EditorBuilderDefaults.defaultPhotoUri,
                        sourceType = EditorSourceType.IMAGE,
                    )
                    editorContext.engine.asset.addSource(unsplashAssetSource)
                },
                onExport = {
                    val export =
                        EditorBuilderDefaults.onExport(
                            engine = editorContext.engine,
                            eventHandler = editorContext.eventHandler,
                            mimeType = MimeType.PNG,
                        )
                    result(Result.success(export))
                },
            )
        val editorConfiguration =
            EditorConfiguration.rememberForPhoto(
                assetLibrary = assetLibrary,
            )
        PhotoEditor(
            engineConfiguration = engineConfiguration,
            editorConfiguration = editorConfiguration,
        ) {
            onClose(it)
        }
    }

    @Composable
    fun CustomPostcardEditor(
        settings: EditorSettings,
        result: EditorBuilderResult,
        onClose: (Throwable?) -> Unit,
    ) {
        val engineConfiguration =
            EngineConfiguration.remember(
                license = settings.license,
                baseUri = Uri.parse(settings.baseUri),
                userId = settings.userId,
                onCreate = {
                    EditorBuilderDefaults.onCreate(
                        engine = editorContext.engine,
                        eventHandler = editorContext.eventHandler,
                        settings = settings,
                        defaultScene = EngineConfiguration.defaultPostcardSceneUri,
                    )
                    editorContext.engine.asset.addSource(unsplashAssetSource)
                },
                onExport = {
                    val export =
                        EditorBuilderDefaults.onExport(
                            engine = editorContext.engine,
                            eventHandler = editorContext.eventHandler,
                            mimeType = MimeType.PDF,
                        )
                    result(Result.success(export))
                },
            )
        val editorConfiguration =
            EditorConfiguration.rememberForPostcard(
                assetLibrary = assetLibrary,
            )
        PostcardEditor(
            engineConfiguration = engineConfiguration,
            editorConfiguration = editorConfiguration,
        ) {
            onClose(it)
        }
    }

    private fun builderOrCustom(
        defaultBuilder: Builder,
        customBuilder: Builder,
        metadata: Map<String, Any>?,
    ): Builder {
        if (metadata?.get("custom") == true) {
            return customBuilder
        }
        return defaultBuilder
    }
}
