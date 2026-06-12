// highlight-import
import 'package:flutter/material.dart';
import 'package:imgly_camera/imgly_camera.dart';
// highlight-import

class RecordingsCameraSolution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // highlight-configuration
        const settings = CameraSettings(
          license:
              "YOUR-LICENSE-KEY", // Get your license from https://img.ly/forms/free-trial, pass null for evaluation mode with watermark
        );
        // highlight-configuration
        try {
          // highlight-camera-call
          final result = await IMGLYCamera.openCamera(settings);
          // highlight-camera-call
          // highlight-cancelled
          if (result == null) {
            print('The editor has been cancelled.');
            return;
          }
          // highlight-cancelled
          // highlight-standard
          final captures = result.capture?.captures;
          if (captures != null) {
            for (final capture in captures) {
              final photo = capture.photo;
              final video = capture.video;
              if (photo != null) {
                for (final image in photo.images) {
                  print('Photo path: ${image.uri}');
                  print('Photo rect: ${image.rect.toJson()}');
                }
              } else if (video != null) {
                print('Recording duration: ${video.duration}');
                for (final clip in video.videos) {
                  print('Video path: ${clip.uri}');
                  print('Video rect: ${clip.rect}');
                }
              }
            }
          }
          // highlight-standard
        } catch (error) {
          // highlight-failure
          print('Error occurred in the camera session: $error');
          // highlight-failure
        }
      },
      child: const Text('Open Camera'),
    );
  }
}
