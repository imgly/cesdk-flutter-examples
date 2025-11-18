// highlight-import-dart
import "package:imgly_camera/imgly_camera.dart";
// highlight-import-dart

class CameraConfigurationSolution {
  /// Opens the camera.
  void openCamera() async {
    // highlight-configuration-dart
    final settings = CameraSettings(
        license:
            "YOUR_LICENSE", // Get your license from https://img.ly/forms/free-trial, pass null for evaluation mode with watermark
        userId:
            "YOUR_USER_ID"); // A unique string to identify your user/session
    // highlight-configuration-dart

    // highlight-camera-call-dart
    final _ = await IMGLYCamera.openCamera(
      settings,
      // Optional, if you want to react to a video
      video:
          'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_2mb.mp4',
    );
    // highlight-camera-call-dart
  }
}
