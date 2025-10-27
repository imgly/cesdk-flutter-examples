import 'package:imgly_camera/imgly_camera.dart';
import 'package:showcases/model/code_example.dart';
import 'package:showcases/secrets/secrets.dart';

class DefaultCamera extends CodeExample {
  @override
  void invoke() async {
    try {
      final settings = CameraSettings(license: Secrets.license);
      final result = await IMGLYCamera.openCamera(settings);
      handleCameraResult(result);
    } catch (error) {
      handleError(error);
    }
  }
}
