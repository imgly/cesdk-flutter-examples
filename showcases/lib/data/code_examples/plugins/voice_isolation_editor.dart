import 'package:imgly_editor/imgly_editor.dart';
import 'package:showcases/model/code_example.dart';
import 'package:showcases/secrets/secrets.dart';

class VoiceIsolationEditor extends CodeExample {
  @override
  void invoke() async {
    try {
      final settings = Secrets.editorSettings();
      final result = await IMGLYEditor.openEditor(
          source: Source.fromVideo("assets/voice_isolation_sample.mp4"),
          preset: EditorPreset.video,
          settings: settings,
          metadata: {"plugin": "voiceIsolation"});
      handleResult(result);
    } catch (error) {
      handleError(error);
    }
  }
}
