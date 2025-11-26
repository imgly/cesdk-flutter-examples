// highlight-import
import "package:imgly_editor/imgly_editor.dart";
// highlight-import

class EditorQuickstartSolution {
  /// Opens the editor.
  void openEditor() async {
    // highlight-configuration
    final settings = EditorSettings(
        license:
            "YOUR_LICENSE", // Get your license from https://img.ly/forms/free-trial, pass null for evaluation mode with watermark
        userId:
            "YOUR_USER_ID"); // A unique string to identify your user/session
    // highlight-configuration

    // highlight-editor
    final _ = await IMGLYEditor.openEditor(settings: settings);
    // highlight-editor
  }
}
