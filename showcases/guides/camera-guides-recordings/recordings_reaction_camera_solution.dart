import 'package:flutter/material.dart';
import 'package:imgly_camera/imgly_camera.dart';

class ReactionRecordingsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final settings = CameraSettings(
          license: "YOUR-LICENSE-KEY",
        );
        try {
          final result = await IMGLYCamera.openCamera(
            settings,
            cameraMode: CameraMode.reaction(
              videoUri: 'YOUR-VIDEO-URL',
            ),
          );
          if (result == null) {
            print('The editor has been cancelled.');
            return;
          }
          print('Reaction video duration: ${result.video.duration}');
          for (final video in result.video.videos) {
            print('Video path: ${video.path}');
            print('Video rect: ${video.rect}');
          }
          for (final recording in result.recordings) {
            print('Recording duration: ${recording.duration}');
            for (final video in recording.videos) {
              print('Video path: ${video.path}');
              print('Video rect: ${video.rect}');
            }
          }
        } catch (error) {
          print('Error occurred in the camera session: $error');
        }
      },
      child: Text('Open Reaction Camera'),
    );
  }
}
