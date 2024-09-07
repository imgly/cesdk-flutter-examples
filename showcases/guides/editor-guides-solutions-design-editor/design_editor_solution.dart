// highlight-import
import "package:imgly_editor/imgly_editor.dart";
// highlight-import

class DesignEditorSolution {
  /// Opens the editor.
  void openEditor() async {
    // highlight-configuration
    final settings =
        EditorSettings(license: "YOUR_LICENSE", userId: "YOUR_USER_ID");
    // highlight-configuration

    // highlight-preset
    // Use the `EditorPreset.design` to open the design editor.
    const preset = EditorPreset.design;
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
