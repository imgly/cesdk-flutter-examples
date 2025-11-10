// highlight-import
import "package:imgly_editor/imgly_editor.dart";
// highlight-import

class PostcardEditorSolution {
  /// Opens the editor.
  void openEditor() async {
    // highlight-configuration
    final settings = EditorSettings(
        license:
            "YOUR_LICENSE", // Get your license from https://img.ly/forms/free-trial, pass null for evaluation mode with watermark
        userId:
            "YOUR_USER_ID"); // A unique string to identify your user/session
    // highlight-configuration

    // highlight-preset
    // Use the `EditorPreset.postcard` to open the postcard editor.
    const preset = EditorPreset.postcard;
    // highlight-preset

    // highlight-editor
    // Open the editor and handle the result.
    final _ = await IMGLYEditor.openEditor(
        // highlight-preset
        preset: preset,
        // highlight-preset
        settings: settings);
    // highlight-editor
  }
}
