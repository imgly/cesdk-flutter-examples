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
          license: "YOUR-LICENSE-KEY",
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
          final recordedVideos = result.recording?.recordings;
          if (recordedVideos != null) {
            for (final recording in recordedVideos) {
              print('Recording duration: ${recording.duration}');
              for (final video in recording.videos) {
                print('Video path: ${video.uri}');
                print('Video rect: ${video.rect}');
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
