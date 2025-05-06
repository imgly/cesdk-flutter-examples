// highlight-import
import 'package:flutter/material.dart';
import 'package:imgly_camera/imgly_camera.dart';
// highlight-import

class CameraFlutter {
  /// Opens the camera.
  // highlight-camera
  void openCamera() async {
    // highlight-configuration
    final settings = CameraSettings(
      license: "YOUR_LICENSE", // Your license key here
      userId: "YOUR_USER_ID", // Optional: Your user ID here
    );
    // highlight-configuration

    // highlight-camera
    final result = await IMGLYCamera.openCamera(settings);
    // highlight-camera
  }
  // highlight-camera
}
