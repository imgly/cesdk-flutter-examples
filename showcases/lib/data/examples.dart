import 'package:showcases/data/code_examples/camera/default_camera.dart';
import 'package:showcases/data/code_examples/camera/default_camera_reaction.dart';
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

final List<Section> examples = [
  Section("Camera", "Capture a Photo", [
    Example("Open Camera", "Loads the camera.", DefaultCamera()),
    Example(
        "Camera with Reaction", "Loads the camera that react to an video.", DefaultCameraRecation())
  ]),
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
        "Loads custom design scene and adds Unsplash asset source and library.",
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
            "Loads custom apparel scene and adds Unsplash asset source and library.",
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
            "Loads custom postcard scene and adds Unsplash asset source and library.",
            CustomPostcardEditor())
      ]),
  Section("Video Editor", "Edit video.", [
    Example("Default Video Editor", "Loads empty video scene.",
        DefaultVideoEditor()),
    Example(
        "Custom Video Editor",
        "Loads custom video scene and adds Unsplash asset source and library.",
        CustomVideoEditor())
  ])
];
