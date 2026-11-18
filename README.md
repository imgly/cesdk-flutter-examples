![Hero image showing the configuration abilities of IMGLYEngine](https://img.ly/static/cesdk_release_header_flutter.png)

# IMGLY Creative Editor - Flutter Examples

This repository contains the Flutter examples for the IMG.LY mobile editor solutions.
The underlying `Engine` enables you to build any design editing UI, automation, and creative workflow for iOS and Android.
It offers performant and robust graphics processing capabilities combining the best of layout, typography, and image processing with advanced workflows centered around templating and adaptation.

The `Engine` seamlessly integrates into any iOS or Android app whether you are building a photo editor, template-based design tool, or scalable automation of content creation for your app.
The mobile editor is fully built on top of the `Engine`.

## Documentation

Find the full documentation of the mobile editor on [IMG.ly website](https://img.ly/docs/cesdk/mobile-editor/quickstart?platform=flutter).
There you will learn how to integrate and configure the mobile editor for your use case.

## Plugins

The **Plugins** section of the showcase adds two on-device plugins to the editor:

- **Background Removal** opens a photo editor with `BackgroundRemovalPlugin` on a sample photo.
- **Voice Isolation** opens a video editor with `VoiceIsolationPlugin` on a speech clip with background noise.

Each entry passes its own `metadata` to `IMGLYEditor.openEditor`, and the native code returns a dedicated editor for it.
The paths in this section start in the `showcases` folder. The editors are in `ios/Runner/AppDelegate.swift` and `android/app/src/main/kotlin/ly/img/editor/flutter/showcases/MainActivity.kt`.
Each plugin uses exactly the version of `imgly_editor`.

The voice isolation sample uses a LibriVox recording of *Cleek of Scotland Yard*, chapter 6, read by Ruth Golding ([CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/), [archive.org](https://archive.org/details/cleek_scotland_yard_rg_librivox)), mixed with generated noise.

### Android

`android/app/build.gradle` adds the plugins:

```groovy
implementation "ly.img:plugin-background-removal-imgly:1.87.0-rc.1"
implementation "ly.img:plugin-voice-isolation-imgly:1.87.0-rc.1"
```

### iOS with Swift Package Manager

Flutter 3.44 and later use Swift Package Manager by default.
The Runner target references two packages, each with the exact version of `imgly_editor`:

- [IMGLYPluginBackgroundRemoval-swift](https://github.com/imgly/IMGLYPluginBackgroundRemoval-swift), product `IMGLYPluginBackgroundRemoval`
- [IMGLYPluginVoiceIsolation-swift](https://github.com/imgly/IMGLYPluginVoiceIsolation-swift), product `IMGLYPluginVoiceIsolation`

To add them to your app, open `ios/Runner.xcworkspace` in Xcode, choose **File > Add Package Dependencies…**, set the dependency rule to **Exact Version**, and add the product to the Runner target.

### iOS with CocoaPods

Apps on Flutter before 3.44, and apps that stay on CocoaPods, add the plugins as pods.
The Swift code stays the same.

1. On Flutter 3.44 or later, turn off Swift Package Manager for the app in `pubspec.yaml`:

   ```yaml
   flutter:
     config:
       enable-swift-package-manager: false
   ```

2. In Xcode, remove the two plugin packages from the Runner project (**Package Dependencies**).
   With both the packages and the pods, the app links the editor twice.
3. In `ios/Podfile`, add IMG.LY's spec repository and the CocoaPods trunk as sources, in this order, and the plugin pods
   to the Runner target:

   ```ruby
   source 'https://github.com/imgly/cesdk-specs.git'
   source 'https://cdn.cocoapods.org/'

   target 'Runner' do
     use_frameworks!
     use_modular_headers!

     pod 'IMGLYPluginBackgroundRemoval', '1.87.0-rc.1'
     pod 'IMGLYPluginVoiceIsolation', '1.87.0-rc.1'

     flutter_install_all_ios_pods __dir__
   ```

## License

The `Engine` is a commercial product. To use it you need to unlock the SDK with a license file. You can purchase a license at https://img.ly/pricing.

### Evaluation Mode

You can run the SDK in evaluation mode by passing `null` or an empty string as the license key. This will add a watermark to all exports but allows you to try out the SDK without a license.

### Using a License Key

In order to run the `showcases` application in this repository with a license key, use the instructions below:

1. Request a license at https://img.ly/forms/contact-sales/.
2. Copy the license key.
3. Include the license key in the `lib/secrets/secrets.dart` file:

```
static const String license = {YOUR_LICENSE_KEY}
```
