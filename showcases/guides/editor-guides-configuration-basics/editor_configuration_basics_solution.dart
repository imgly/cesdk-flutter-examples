// highlight-import
import "package:imgly_editor/imgly_editor.dart";
// highlight-import

class EditorConfigurationBasicsSolution {
  /// Opens the editor.
  void openEditor() async {
    // highlight-configuration
    final settings = EditorSettings(
        // highlight-license
        license: "YOUR_LICENSE",
        // highlight-license
        // highlight-sceneBaseUri
        sceneBaseUri: "YOUR_SCENE_BASE_URI",
        // highlight-sceneBaseUri
        // highlight-assetBaseUri
        assetBaseUri: "YOUR_ASSET_BASE_URI",
        // highlight-assetBaseUri
        // highlight-userId
        userId: "YOUR_USER_ID"
        // highlight-userId
        );
    // highlight-configuration

    final _ = await IMGLYEditor.openEditor(
        // highlight-preset
        preset: EditorPreset.design,
        // highlight-preset
        settings: settings,
        // highlight-metadata
        metadata: {"MY_KEY": "MY_VALUE"}
        // highlight-metadata
        );
  }
}
