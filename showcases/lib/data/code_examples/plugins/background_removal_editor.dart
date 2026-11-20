import 'package:imgly_editor/imgly_editor.dart';
import 'package:showcases/model/code_example.dart';
import 'package:showcases/secrets/secrets.dart';

class BackgroundRemovalEditor extends CodeExample {
  @override
  void invoke() async {
    try {
      final settings = Secrets.editorSettings();
      final result = await IMGLYEditor.openEditor(
          source: Source.fromImage(
              "${settings.baseUri}/ly.img.image/images/sample_14.jpg"),
          preset: EditorPreset.photo,
          settings: settings,
          metadata: {"plugin": "backgroundRemoval"});
      handleResult(result);
    } catch (error) {
      handleError(error);
    }
  }
}
