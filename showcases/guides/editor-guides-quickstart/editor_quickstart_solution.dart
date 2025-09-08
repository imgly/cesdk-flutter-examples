// highlight-import
import "package:imgly_editor/imgly_editor.dart";
// highlight-import

class EditorQuickstartSolution {
  /// Opens the editor.
  void openEditor() async {
    // highlight-configuration
    final settings =
        EditorSettings(license: "YOUR_LICENSE", userId: "YOUR_USER_ID");
    // highlight-configuration

    // highlight-editor
    final _ = await IMGLYEditor.openEditor(settings: settings);
    // highlight-editor
  }
}
