import 'package:imgly_editor/imgly_editor_platform_interface.dart';
import 'package:imgly_camera/imgly_camera_platform_interface.dart';

/// A [CodeExample] that is invokable.
class CodeExample {
  /// Invokes the example.
  void invoke() async {}

  /// Handles the editor result.
  void handleResult(EditorResult? result) {}

  /// Handles the editor result.
  void handleCameraResult(CameraResult? result) {}

  /// Handles an error.
  void handleError(Object error) {}
}
