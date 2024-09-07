import 'dart:io';

import 'package:showcases/data/code_examples/design/custom_design_editor.dart';
import 'package:showcases/data/code_examples/design/default_design_editor.dart';
import 'package:showcases/data/code_examples/photo/custom_photo_editor.dart';
import 'package:showcases/data/code_examples/photo/default_photo_editor.dart';
import 'package:showcases/data/code_examples/postcard/custom_postcard_editor.dart';
import 'package:showcases/data/code_examples/postcard/default_postcard_editor.dart';
import 'package:showcases/data/code_examples/video/custom_video_editor.dart';
import 'package:showcases/data/code_examples/video/default_video_editor.dart';
import 'package:showcases/model/example.dart';
import 'package:showcases/model/section.dart';

import 'code_examples/apparel/custom_apparel_editor.dart';
import 'code_examples/apparel/default_apparel_editor.dart';

final List<Section> _examples = [
  Section("Photo Editor", "Edit Photo", [
    Example("Default Photo Editor", "Loads empty image.", DefaultPhotoEditor()),
    Example(
        "Custom Photo Editor", "Loads a selected image.", CustomPhotoEditor())
  ]),
  Section("Design Editor", "Built to edit various designs.", [
    Example("Default Design Editor", "Loads empty design scene.",
        DefaultDesignEditor()),
    Example(
        "Custom Design Editor",
        "Loads custom design scene and adds Unsplash asset source and libray.",
        CustomDesignEditor())
  ]),
  Section(
      "Apparel Editor",
      "Customize and export a print-ready design with a mobile apparel editor.",
      [
        Example("Default Apparel Editor", "Loads empty apparel scene.",
            DefaultApparelEditor()),
        Example(
            "Custom Apparel Editor",
            "Loads custom apparel scene and adds Unsplash asset source and libray.",
            CustomApparelEditor())
      ]),
  Section(
      "Post- & Greeting-Card Editor",
      "Built to facilitate optimal card design, from changing accent colors to selecting fonts.",
      [
        Example("Default Postcard Editor", "Loads empty postcard scene.",
            DefaultPostcardEditor()),
        Example(
            "Custom Postcard Editor",
            "Loads custom postcard scene and adds Unsplash asset source and libray.",
            CustomPostcardEditor())
      ]),
];

List<Section> examples = [];

void loadExamples() {
  examples = _examples;
  if (Platform.isIOS &&
      examples.where((e) => e.title == "Video Editor").isEmpty) {
    examples.add(Section("Video Editor", "Edit video.", [
      Example("Default Video Editor", "Loads empty video scene.",
          DefaultVideoEditor()),
      Example(
          "Custom Video Editor",
          "Loads custom video scene and adds Unsplash asset source and libray.",
          CustomVideoEditor())
    ]));
  }
}
