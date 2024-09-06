import 'package:imgly_editor/imgly_editor.dart';
import 'package:showcases/model/code_example.dart';
import 'package:showcases/secrets/secrets.dart';

class CustomApparelEditor extends CodeExample {
  @override
  void invoke() async {
    try {
      final settings = EditorSettings(license: Secrets.license);
      final result = await IMGLYEditor.openEditor(
          source: Source.fromScene("assets/apparel-ui-b-4.scene"),
          preset: EditorPreset.apparel,
          settings: settings,
          metadata: {"custom": true});
      handleResult(result);
    } catch (error) {
      handleError(error);
    }
  }
}
