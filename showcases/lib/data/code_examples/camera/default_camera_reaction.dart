import 'package:imgly_camera/imgly_camera.dart';
import 'package:showcases/model/code_example.dart';
import 'package:showcases/secrets/secrets.dart';

class DefaultCameraRecation extends CodeExample {
  @override
  void invoke() async {
    try {
      final settings = CameraSettings(license: Secrets.license);
      final result = await IMGLYCamera.openCamera(
			  settings,
			  video: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_2mb.mp4',
			);
      handleCameraResult(result);
    } catch (error) {
      handleError(error);
    }
  }
}