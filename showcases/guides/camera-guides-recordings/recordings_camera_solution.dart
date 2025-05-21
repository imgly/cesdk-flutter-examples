// highlight-import
import 'package:flutter/material.dart';
import 'package:imgly_camera/imgly_camera.dart';
// highlight-import

class RecordingsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // highlight-configuration
        final settings = CameraSettings(
          license: "YOUR-LICENSE-KEY",
        );
        // highlight-configuration
        try {
          // highlight-camera
          final result = await IMGLYCamera.openCamera(settings);
          // highlight-cancelled
          if (result == null) {
            print('The editor has been cancelled.');
            return;
          }
          // highlight-cancelled
          // highlight-standard
          for (final recording in result.recordings) {
            print('Recording duration: ${recording.duration}');
            for (final video in recording.videos) {
              print('Video path: ${video.path}');
              print('Video rect: ${video.rect}');
            }
          }
          // highlight-standard
        } catch (error) {
          // highlight-failure
          print('Error occurred in the camera session: $error');
          // highlight-failure
        }
      },
      child: Text('Open Camera'),
    );
  }
} 