// highlight-import
import 'package:imgly_camera/imgly_camera.dart';
// highlight-import

class CameraQuickstartSolution {
  /// Opens the camera.
  // highlight-camera-start
  void openCamera() async {
    // highlight-configuration
    const settings = CameraSettings(
      license:
          "YOUR_LICENSE", // Get your license from https://img.ly/forms/free-trial, pass null for evaluation mode with watermark
      userId: "YOUR_USER_ID", // A unique string to identify your user/session
    );
    // highlight-configuration

    // highlight-camera-call
    final result = await IMGLYCamera.openCamera(settings);
    print(result?.toJson());
    // highlight-camera-call
  }
  // highlight-camera-end
}
