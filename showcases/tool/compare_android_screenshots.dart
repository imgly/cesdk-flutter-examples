import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../test_driver/image_compare.dart';

// Tuning knobs for Android — deliberately looser than the iOS 0.01% because real
// FTL device GPUs are less deterministic than the iOS simulator. Revisit after the
// first FTL baseline runs.
//
// Per-pixel channel tolerance (0–255): R/G/B deltas at or below this are ignored,
// which absorbs minor GPU rounding / anti-aliasing that varies run to run.
const _channelTolerance = 4;
// Percentage of pixels still allowed to differ (after the channel tolerance) before
// a screenshot is treated as a regression.
const _threshold = 0.01;

Future<void> main(List<String> args) async {
  final pulledDir = args.isNotEmpty ? args[0] : 'output/pulled';
  const snapshotsDir = 'snapshots';
  const outputDir = 'output';

  final input = Directory(pulledDir);
  if (!input.existsSync()) {
    stderr.writeln('❌ Pulled screenshots directory not found: $pulledDir');
    exit(1);
  }

  final screenshots =
      input
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('_android.png'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (screenshots.isEmpty) {
    stderr.writeln(
      '❌ No *_android.png screenshots found under $pulledDir. '
      'The capture step likely failed on-device.',
    );
    exit(1);
  }

  var failures = 0;
  var recorded = 0;
  var passed = 0;

  for (final file in screenshots) {
    final name = file.uri.pathSegments.last.replaceFirst('.png', '');
    final baseline = File('$snapshotsDir/$name.png');
    final newBytes = file.readAsBytesSync();

    if (!baseline.existsSync()) {
      _write('$outputDir/new/$name.png', newBytes);
      recorded++;
      stdout.writeln('🟡 $name: no baseline — recorded new reference');
      continue;
    }

    final reference = img.decodeImageFile(baseline.path);
    final candidate = img.decodePng(Uint8List.fromList(newBytes));
    final referenceImage = await reference;
    if (referenceImage == null || candidate == null) {
      _write('$outputDir/new/$name.png', newBytes);
      failures++;
      stderr.writeln('❌ $name: could not decode baseline or candidate image');
      continue;
    }

    try {
      final percentage = diffPercentage(
        referenceImage,
        candidate,
        channelTolerance: _channelTolerance,
      );
      if (percentage > _threshold) {
        final diff = buildDiffImage(
          referenceImage,
          candidate,
          channelTolerance: _channelTolerance,
        );
        _write(
          '$outputDir/diff/${name}_diff.png',
          Uint8List.fromList(img.encodePng(diff)),
        );
        _write('$outputDir/new/$name.png', newBytes);
        _write('$outputDir/old/$name.png', baseline.readAsBytesSync());
        failures++;
        stderr.writeln(
          '❌ $name: ${percentage.toStringAsFixed(3)}% differ (> $_threshold%)',
        );
      } else {
        passed++;
        stdout.writeln('✅ $name: match (${percentage.toStringAsFixed(3)}%)');
      }
    } on Exception catch (e) {
      // Most commonly a size mismatch (baseline captured on a different device).
      _write('$outputDir/new/$name.png', newBytes);
      _write('$outputDir/old/$name.png', baseline.readAsBytesSync());
      failures++;
      stderr.writeln('❌ $name: $e');
    }
  }

  stdout.writeln(
    '\nSummary: $passed matched, $recorded newly recorded, $failures failed '
    '(${screenshots.length} total).',
  );

  if (recorded > 0) {
    stdout.writeln(
      'ℹ️  Newly recorded baselines are in $outputDir/new/. Commit them to '
      '$snapshotsDir/ to enable diffing on subsequent runs.',
    );
  }

  exit(failures > 0 ? 1 : 0);
}

void _write(String path, List<int> bytes) {
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes);
}
