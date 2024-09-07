// #highlight-import
import imgly_editor
import SwiftUI

// #highlight-import

func useCustomEditor() {
  // #highlight-closure
  IMGLYEditorPlugin.builderClosure = { _, metadata in
    // Make decisions based on your own metadata.
    if metadata?["use_custom_editor"] as? Bool == true {
      // Return your custom editor.
      EditorBuilder.custom { settings, _, _, result in
        CustomEditor(settings: settings, result: result)
      }
    } else {
      // Return a custom or prebuilt editor.
      EditorBuilder.design()
    }
  }
  // #highlight-closure
}

private struct CustomEditor: View {
  init(settings _: EditorSettings, result _: @escaping EditorBuilder.EditorBuilderResult) {}

  var body: some View {
    Text("Custom Editor")
  }
}
