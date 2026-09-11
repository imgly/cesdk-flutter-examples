// highlight-import-swift
import imgly_camera
import imgly_editor
import SwiftUI

// highlight-import-swift
// highlight-editor-configuration-swift
func useCustomEditor() {
  // highlight-closure-swift
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
  // highlight-closure-swift
}

private struct CustomEditor: View {
  init(settings _: EditorSettings, result _: @escaping EditorBuilder.EditorBuilderResult) {}

  var body: some View {
    Text("Custom Editor")
  }
}

// highlight-editor-configuration-swift

// highlight-camera-configuration-swift
func configureCamera() {
  // highlight-camera-configuration-closure-swift
  IMGLYCameraPlugin.builderClosure = { metadata in
    // Make decisions based on your own metadata.
    if metadata?["use_custom_camera"] as? Bool == true {
      // Return your custom camera.
      CameraBuilder.custom { settings, url, metadata, result in
        CustomCamera(settings: settings, url: url, metadata: metadata, result: result)
      }
    } else {
      // Return a custom or prebuilt camera.
      CameraBuilder.default()
    }
  }
  // highlight-camera-configuration-closure-swift
}

private struct CustomCamera: View {
  init(
    settings _: CameraSettings,
    url _: URL?,
    metadata _: [String: Any]?,
    result _: @escaping CameraBuilder.CameraBuilderResult
  ) {}

  var body: some View {
    Text("Custom Camera")
  }
}

// highlight-camera-configuration-swift
