// highlight-import
import "package:imgly_camera/imgly_camera.dart";
// highlight-import

class CameraFlutter {
  /// Opens the camera.
  void openCamera() async {
    // highlight-configuration
    final settings =
        CameraSettings(license: "YOUR_LICENSE", userId: "YOUR_USER_ID");
    // highlight-configuration

    // highlight-camera-call
    final _ = await IMGLYCamera.openCamera(
      settings,
      // Optional, if you want to react to a video
      video: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_2mb.mp4',
    )
    // highlight-camera-call
  }
}
