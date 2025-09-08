import 'package:flutter/material.dart';
import 'package:imgly_camera/imgly_camera.dart';

class RecordingsReactionCameraSolution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        const settings = CameraSettings(
          license: "YOUR-LICENSE-KEY",
        );
        try {
          final result = await IMGLYCamera.openCamera(
            settings,
            video: 'YOUR-VIDEO-URL',
          );
          if (result == null) {
            print('The editor has been cancelled.');
            return;
          }
          print('Reaction video duration: ${result.reaction?.video.duration}');

          // Get the reaction video data.
          final originalVideos = result.reaction?.video.videos;
          if (originalVideos != null) {
            for (final video in originalVideos) {
              print('Video path: ${video.uri}');
              print('Video rect: ${video.rect}');
            }
          }
        } catch (error) {
          print('Error occurred in the camera session: $error');
        }
      },
      child: const Text('Open Reaction Camera'),
    );
  }
}
