import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:betel_app/utils/image_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageValidator Unit Tests', () {
    test('isConfidenceSufficient returns true for >= 0.60 and false for < 0.60', () {
      expect(ImageValidator.isConfidenceSufficient(0.60), isTrue);
      expect(ImageValidator.isConfidenceSufficient(0.85), isTrue);
      expect(ImageValidator.isConfidenceSufficient(0.59), isFalse);
      expect(ImageValidator.isConfidenceSufficient(0.10), isFalse);
    });

    test('rejects unsupported file formats or invalid bytes', () async {
      final invalidBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await ImageValidator.validateImage(
        bytes: invalidBytes,
        filename: 'test.pdf',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, ImageValidator.invalidFormatOrSizeMsg);
    });

    test('rejects images smaller than 224x224', () async {
      final smallImg = img.Image(width: 100, height: 100);
      img.fill(smallImg, color: img.ColorRgb8(128, 128, 128));
      final pngBytes = Uint8List.fromList(img.encodePng(smallImg));

      final result = await ImageValidator.validateImage(
        bytes: pngBytes,
        filename: 'small.png',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, ImageValidator.invalidFormatOrSizeMsg);
    });

    test('rejects image that is too dark (brightness < 40)', () async {
      final darkImg = img.Image(width: 250, height: 250);
      img.fill(darkImg, color: img.ColorRgb8(10, 10, 10));
      final pngBytes = Uint8List.fromList(img.encodePng(darkImg));

      final result = await ImageValidator.validateImage(
        bytes: pngBytes,
        filename: 'dark.png',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, ImageValidator.tooDarkMsg);
    });

    test('rejects image that is too bright (brightness > 220)', () async {
      final brightImg = img.Image(width: 250, height: 250);
      img.fill(brightImg, color: img.ColorRgb8(245, 245, 245));
      final pngBytes = Uint8List.fromList(img.encodePng(brightImg));

      final result = await ImageValidator.validateImage(
        bytes: pngBytes,
        filename: 'bright.png',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, ImageValidator.tooBrightMsg);
    });

    test('rejects uniformly flat/blurry image (Laplacian variance < 100)', () async {
      // Solid gray image has zero variance across neighbors
      final uniformImg = img.Image(width: 250, height: 250);
      img.fill(uniformImg, color: img.ColorRgb8(100, 100, 100));
      final pngBytes = Uint8List.fromList(img.encodePng(uniformImg));

      final result = await ImageValidator.validateImage(
        bytes: pngBytes,
        filename: 'flat.png',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, ImageValidator.blurryMsg);
    });

    test('accepts high-contrast, well-lit, non-blurry image >= 224x224', () async {
      final testImg = img.Image(width: 250, height: 250);
      // Create high-contrast pattern (checkerboard)
      for (int y = 0; y < 250; y++) {
        for (int x = 0; x < 250; x++) {
          final isEven = ((x ~/ 10) + (y ~/ 10)) % 2 == 0;
          final val = isEven ? 60 : 180;
          testImg.setPixelRgb(x, y, val, val, val);
        }
      }
      final pngBytes = Uint8List.fromList(img.encodePng(testImg));

      final result = await ImageValidator.validateImage(
        bytes: pngBytes,
        filename: 'valid.png',
      );
      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
      expect(result.width, 250);
      expect(result.height, 250);
      expect(result.brightness, greaterThanOrEqualTo(40));
      expect(result.brightness, lessThanOrEqualTo(220));
      expect(result.blurScore, greaterThan(100));
    });
  });
}
