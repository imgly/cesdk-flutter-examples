import 'package:imgly_editor/imgly_editor.dart';
import 'package:showcases/model/code_example.dart';
import 'package:showcases/secrets/secrets.dart';

class DefaultVideoEditor extends CodeExample {
  @override
  void invoke() async {
    try {
      final settings = EditorSettings(license: Secrets.license);
      final result = await IMGLYEditor.openEditor(
          preset: EditorPreset.video, settings: settings);
      handleResult(result);
    } catch (error) {
      handleError(error);
    }
  }
}
