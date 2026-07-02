import 'package:imgly_editor/imgly_editor.dart';

class Secrets {
  // Enter your license here.
  static const String license =
      String.fromEnvironment("SHOWCASES_LICENSE_FLUTTER", defaultValue: "");

  /// Optional override for the editor base URI, set via
  /// `--dart-define=SHOWCASES_BASE_URI=...` in CI to test against per-branch
  /// staging deployments. When empty, [EditorSettings] uses its built-in
  /// default (the production CDN for the current SDK version).
  static const String _baseUri =
      String.fromEnvironment("SHOWCASES_BASE_URI", defaultValue: "");

  /// Builds [EditorSettings] from these secrets, applying the optional
  /// baseUri override when present.
  static EditorSettings editorSettings() => _baseUri.isEmpty
      ? EditorSettings(license: license)
      : EditorSettings(license: license, baseUri: _baseUri);
}
