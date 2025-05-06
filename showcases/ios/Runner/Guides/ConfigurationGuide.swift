// #highlight-import
import imgly_camera
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

func configureCamera() {
  // #highlight-camera-configuration
  // #highlight-camera-configuration-closure
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
  // #highlight-camera-configuration-closure
  // #highlight-camera-configuration
}

private struct CustomEditor: View {
  init(settings _: EditorSettings, result _: @escaping EditorBuilder.EditorBuilderResult) {}

  var body: some View {
    Text("Custom Editor")
  }
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
