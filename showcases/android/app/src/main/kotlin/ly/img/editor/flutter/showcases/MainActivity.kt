package ly.img.editor.flutter.showcases

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.core.net.toUri
import io.flutter.embedding.android.FlutterActivity
import ly.img.editor.Editor
import ly.img.editor.configuration.apparel.ApparelConfigurationBuilder
import ly.img.editor.configuration.apparel.callback.onCreate
import ly.img.editor.configuration.apparel.callback.onExport
import ly.img.editor.configuration.apparel.callback.onLoadAssetSources
import ly.img.editor.configuration.design.DesignConfigurationBuilder
import ly.img.editor.configuration.design.callback.onCreate
import ly.img.editor.configuration.design.callback.onExport
import ly.img.editor.configuration.design.callback.onLoadAssetSources
import ly.img.editor.configuration.photo.PhotoConfigurationBuilder
import ly.img.editor.configuration.photo.callback.onCreate
import ly.img.editor.configuration.photo.callback.onExport
import ly.img.editor.configuration.photo.callback.onLoadAssetSources
import ly.img.editor.configuration.postcard.PostcardConfigurationBuilder
import ly.img.editor.configuration.postcard.callback.onCreate
import ly.img.editor.configuration.postcard.callback.onExport
import ly.img.editor.configuration.postcard.callback.onLoadAssetSources
import ly.img.editor.configuration.video.VideoConfigurationBuilder
import ly.img.editor.configuration.video.callback.onCreate
import ly.img.editor.configuration.video.callback.onExport
import ly.img.editor.configuration.video.callback.onLoadAssetSources
import ly.img.editor.core.configuration.EditorConfiguration
import ly.img.editor.core.configuration.remember
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
import ly.img.engine.MimeType

class MainActivity : FlutterActivity() {
    private val unsplashAssetSource = UnsplashAssetSource(Secrets.unsplashHost)
    private val unsplashSection = LibraryContent.Section(
        titleRes = R.string.unsplash,
        sourceTypes = listOf(AssetSourceType(sourceId = unsplashAssetSource.sourceId)),
        assetType = AssetType.Image,
    )

    override fun onStart() {
        super.onStart()

        IMGLYEditorPlugin.builderClosure = { preset, metadata ->
            when (preset) {
                EditorPreset.APPAREL -> {
                    val customBuilder = EditorBuilder.custom { settings, _, _, result, onClose ->
                        @Composable {
                            CustomApparelEditor(settings, result, onClose)
                        }
                    }
                    builderOrCustom(EditorBuilder.apparel(), customBuilder, metadata)
                }

                EditorPreset.POSTCARD -> {
                    val customBuilder = EditorBuilder.custom { settings, _, _, result, onClose ->
                        @Composable {
                            CustomPostcardEditor(settings, result, onClose)
                        }
                    }
                    builderOrCustom(EditorBuilder.postcard(), customBuilder, metadata)
                }

                EditorPreset.PHOTO -> {
                    val customBuilder = EditorBuilder.custom { settings, _, _, result, onClose ->
                        @Composable {
                            CustomPhotoEditor(settings, result, onClose)
                        }
                    }
                    builderOrCustom(EditorBuilder.photo(), customBuilder, metadata)
                }

                EditorPreset.DESIGN -> {
                    val customBuilder = EditorBuilder.custom { settings, _, _, result, onClose ->
                        @Composable {
                            CustomDesignEditor(settings, result, onClose)
                        }
                    }
                    builderOrCustom(EditorBuilder.design(), customBuilder, metadata)
                }

                EditorPreset.VIDEO -> {
                    val customBuilder = EditorBuilder.custom { settings, _, _, result, onClose ->
                        @Composable {
                            CustomVideoEditor(settings, result, onClose)
                        }
                    }
                    builderOrCustom(EditorBuilder.video(), customBuilder, metadata)
                }

                null -> {
                    val customBuilder = EditorBuilder.custom { settings, _, _, result, onClose ->
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
        Editor(
            license = settings.license,
            baseUri = settings.baseUri.toUri(),
            userId = settings.userId,
            configuration = {
                EditorConfiguration.remember(::ApparelConfigurationBuilder) {
                    onCreate = {
                        onCreate(
                            createScene = {
                                EditorBuilderDefaults.onCreateScene(
                                    scope = this@Editor,
                                    settings = settings,
                                    defaultUri = "file:///android_asset/scene/apparel.scene".toUri(),
                                )
                            },
                            loadAssetSources = {
                                onLoadAssetSources()
                                editorContext.engine.asset.addSource(unsplashAssetSource)
                            },
                        )
                    }
                    onExport = {
                        onExport(
                            postExport = {
                                val result = EditorBuilderDefaults.getExportResult(
                                    scope = this@Editor,
                                    byteBuffer = it,
                                    mimeType = MimeType.PDF,
                                )
                                result(Result.success(result))
                            },
                            error = {
                                result(Result.failure(it))
                            },
                        )
                    }
                    assetLibrary = {
                        remember {
                            AssetLibrary.getDefault(
                                images = LibraryCategory.Images.addSection(unsplashSection),
                            )
                        }
                    }
                }
            },
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
        Editor(
            license = settings.license,
            baseUri = settings.baseUri.toUri(),
            userId = settings.userId,
            configuration = {
                EditorConfiguration.remember(::DesignConfigurationBuilder) {
                    onCreate = {
                        onCreate(
                            createScene = {
                                EditorBuilderDefaults.onCreateScene(
                                    scope = this@Editor,
                                    settings = settings,
                                    defaultUri = "file:///android_asset/scene/design.scene".toUri(),
                                )
                            },
                            loadAssetSources = {
                                onLoadAssetSources()
                                editorContext.engine.asset.addSource(unsplashAssetSource)
                            },
                        )
                    }
                    onExport = {
                        onExport(
                            postExport = {
                                val result = EditorBuilderDefaults.getExportResult(
                                    scope = this@Editor,
                                    byteBuffer = it,
                                    mimeType = MimeType.PDF,
                                )
                                result(Result.success(result))
                            },
                            error = {
                                result(Result.failure(it))
                            },
                        )
                    }
                    assetLibrary = {
                        remember {
                            AssetLibrary.getDefault(
                                images = LibraryCategory.Images.addSection(unsplashSection),
                            )
                        }
                    }
                }
            },
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
        Editor(
            license = settings.license,
            baseUri = settings.baseUri.toUri(),
            userId = settings.userId,
            configuration = {
                EditorConfiguration.remember(::PhotoConfigurationBuilder) {
                    onCreate = {
                        onCreate(
                            createScene = {
                                EditorBuilderDefaults.onCreateScene(
                                    scope = this@Editor,
                                    settings = settings,
                                    defaultUri = EditorBuilderDefaults.defaultPhotoUri,
                                    sourceType = EditorSourceType.IMAGE,
                                )
                            },
                            loadAssetSources = {
                                onLoadAssetSources()
                                editorContext.engine.asset.addSource(unsplashAssetSource)
                            },
                        )
                    }
                    onExport = {
                        onExport(
                            postExport = {
                                val result = EditorBuilderDefaults.getExportResult(
                                    scope = this@Editor,
                                    byteBuffer = it,
                                    mimeType = MimeType.PNG,
                                )
                                result(Result.success(result))
                            },
                            error = {
                                result(Result.failure(it))
                            },
                        )
                    }
                    assetLibrary = {
                        remember {
                            AssetLibrary.getDefault(
                                images = LibraryCategory.Images.addSection(unsplashSection),
                            )
                        }
                    }
                }
            },
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
        Editor(
            license = settings.license,
            baseUri = settings.baseUri.toUri(),
            userId = settings.userId,
            configuration = {
                EditorConfiguration.remember(::PostcardConfigurationBuilder) {
                    onCreate = {
                        onCreate(
                            createScene = {
                                EditorBuilderDefaults.onCreateScene(
                                    scope = this@Editor,
                                    settings = settings,
                                    defaultUri = "file:///android_asset/scene/postcard.scene".toUri(),
                                )
                            },
                            loadAssetSources = {
                                onLoadAssetSources()
                                editorContext.engine.asset.addSource(unsplashAssetSource)
                            },
                        )
                    }
                    onExport = {
                        onExport(
                            postExport = {
                                val result = EditorBuilderDefaults.getExportResult(
                                    scope = this@Editor,
                                    byteBuffer = it,
                                    mimeType = MimeType.PDF,
                                )
                                result(Result.success(result))
                            },
                            error = {
                                result(Result.failure(it))
                            },
                        )
                    }
                    assetLibrary = {
                        remember {
                            AssetLibrary.getDefault(
                                images = LibraryCategory.Images.addSection(unsplashSection),
                            )
                        }
                    }
                }
            },
        ) {
            onClose(it)
        }
    }

    @Composable
    fun CustomVideoEditor(
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
                            loadAssetSources = {
                                onLoadAssetSources()
                                editorContext.engine.asset.addSource(unsplashAssetSource)
                            },
                        )
                    }
                    onExport = {
                        onExport(
                            postExport = {
                                val result = EditorBuilderDefaults.getExportResult(
                                    scope = this@Editor,
                                    byteBuffer = it,
                                    mimeType = MimeType.MP4,
                                )
                                result(Result.success(result))
                            },
                            error = {
                                result(Result.failure(it))
                            },
                        )
                    }
                    assetLibrary = {
                        remember {
                            AssetLibrary.getDefault(
                                includeAVResources = true,
                                images = LibraryCategory.Images.addSection(unsplashSection),
                            )
                        }
                    }
                }
            },
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
