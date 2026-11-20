import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import '../test_driver/image_compare.dart';

// iOS 26 screenshots are 16-bit PNGs.
img.Image _rgb16(int r, int g, int b) {
  final image = img.Image(width: 1, height: 1, format: img.Format.uint16);
  image.setPixelRgb(0, 0, r, g, b);
  return image;
}

img.Image _grey16(int value) => _rgb16(value, value, value);

void main() {
  test('tints a differing pixel with the average of both screenshots', () {
    final diff = buildDiffImage(_grey16(65535), _grey16(65000));
    final pixel = diff.getPixel(0, 0);
    expect([pixel.r, pixel.g, pixel.b], [254, 254, 254]);

    final darker =
        buildDiffImage(_grey16(40000), _grey16(30000)).getPixel(0, 0);
    expect([darker.r, darker.g, darker.b], [136, 136, 136]);
  });

  test('averages each channel on its own', () {
    final diff = buildDiffImage(_rgb16(65535, 0, 0), _rgb16(65535, 13000, 0));
    final pixel = diff.getPixel(0, 0);
    expect([pixel.r, pixel.g, pixel.b], [255, 25, 0]);
  });

  test('keeps matching pixels black', () {
    final pixel = buildDiffImage(_grey16(65535), _grey16(65535)).getPixel(0, 0);
    expect([pixel.r, pixel.g, pixel.b], [0, 0, 0]);
  });
}
