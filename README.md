![Hero image showing the configuration abilities of IMGLYEngine](https://img.ly/static/cesdk_release_header_flutter.png)

# IMGLY Creative Editor - Flutter Examples

This repository contains the Flutter examples for the IMG.LY mobile editor solutions.
The underlying `Engine` enables you to build any design editing UI, automation and creative workflow for iOS and Android.
It offers performant and robust graphics processing capabilities combining the best of layout, typography and image processing with advanced workflows centered around templating and adaptation.

The `Engine` seamlessly integrates into any iOS or Android app whether you are building a photo editor, template-based design tool or scalable automation of content creation for your app.
The mobile editor is fully built on top of the `Engine`.

## Documentation

The full documentation of the [mobile editor](https://img.ly/docs/cesdk/mobile-editor/quickstart?platform=flutter) can be found on our website.
There you will learn how to integrate and configure them for your use case.

## License

The `Engine` is a commercial product. To use it you need to unlock the SDK with a license file. You can purchase a license at https://img.ly/pricing.

In order to run the `showcases` application in this repository use the instructions below:

1. Get a free trial license at https://img.ly/forms/free-trial.
2. Copy the license key.
3. Include the license key in the `lib/secrets/secrets.dart` file:

```
static const String license = {YOUR_LICENSE_KEY}
```

Note that failing to provide the license key will display an error when opening any of the showcases.
