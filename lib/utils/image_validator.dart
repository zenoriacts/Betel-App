import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Holds the outcome of image quality and format checks.
class ImageValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int width;
  final int height;
  final double brightness;
  final double blurScore;

  const ImageValidationResult({
    required this.isValid,
    this.errorMessage,
    this.width = 0,
    this.height = 0,
    this.brightness = 0.0,
    this.blurScore = 0.0,
  });

  factory ImageValidationResult.valid({
    required int width,
    required int height,
    required double brightness,
    required double blurScore,
  }) =>
      ImageValidationResult(
        isValid: true,
        width: width,
        height: height,
        brightness: brightness,
        blurScore: blurScore,
      );

  factory ImageValidationResult.invalid(String message) =>
      ImageValidationResult(isValid: false, errorMessage: message);
}

/// Parameters passed to the background compute isolate.
class _ImageCheckParams {
  final Uint8List bytes;
  final String filename;
  final double blurThreshold;
  final double minBrightness;
  final double maxBrightness;

  const _ImageCheckParams({
    required this.bytes,
    required this.filename,
    required this.blurThreshold,
    required this.minBrightness,
    required this.maxBrightness,
  });
}

/// Comprehensive validator for leaf & plant images before running ONNX models.
class ImageValidator {
  // ── Tunable Thresholds ───────────────────────────────────────────────────
  static const int minWidth = 224;
  static const int minHeight = 224;

  /// Laplacian variance threshold. Images with variance below this are flagged as blurry.
  static const double blurThreshold = 100.0;

  /// Mean brightness bounds (0 – 255)
  static const double minBrightness = 40.0;
  static const double maxBrightness = 220.0;

  /// Confidence cutoff threshold (60%)
  static const double minConfidenceThreshold = 0.60;

  // ── Standard Validation Messages ─────────────────────────────────────────
  static const String noImageMsg = 'Please take or select a leaf photo';
  static const String invalidFormatOrSizeMsg =
      'Please use a clear JPG or PNG photo';
  static const String lowConfidenceMsg = 'Not sure. Please retake the photo.';
  static const String blurryMsg = 'Photo is blurry, please retake.';
  static const String tooDarkMsg = 'Too dark, retake in better light';
  static const String tooBrightMsg = 'Too bright, retake in better light';

  /// Validates an image in a background isolate using [compute].
  /// Checks format (JPG/PNG), minimum size (>= 224x224), brightness (40-220),
  /// and blur (Laplacian variance >= 100).
  static Future<ImageValidationResult> validateImage({
    required Uint8List bytes,
    required String filename,
    double blurThreshold = ImageValidator.blurThreshold,
    double minBrightness = ImageValidator.minBrightness,
    double maxBrightness = ImageValidator.maxBrightness,
  }) async {
    return await compute(
      _performValidation,
      _ImageCheckParams(
        bytes: bytes,
        filename: filename,
        blurThreshold: blurThreshold,
        minBrightness: minBrightness,
        maxBrightness: maxBrightness,
      ),
    );
  }

  /// Synchronous validation logic executed inside the compute isolate.
  static ImageValidationResult _performValidation(_ImageCheckParams params) {
    // 1. Check file extension (JPG/JPEG/PNG)
    final ext = params.filename.toLowerCase();
    final isJpg = ext.endsWith('.jpg') || ext.endsWith('.jpeg');
    final isPng = ext.endsWith('.png');

    // Also check magic bytes if extension is ambiguous
    bool matchesMagicBytes = false;
    if (params.bytes.length >= 4) {
      // JPEG: FF D8 FF
      final isJpegMagic =
          params.bytes[0] == 0xFF &&
          params.bytes[1] == 0xD8 &&
          params.bytes[2] == 0xFF;
      // PNG: 89 50 4E 47
      final isPngMagic =
          params.bytes[0] == 0x89 &&
          params.bytes[1] == 0x50 &&
          params.bytes[2] == 0x4E &&
          params.bytes[3] == 0x47;
      matchesMagicBytes = isJpegMagic || isPngMagic;
    }

    if (!isJpg && !isPng && !matchesMagicBytes) {
      return ImageValidationResult.invalid(invalidFormatOrSizeMsg);
    }

    // 2. Decode image
    final img.Image? decoded = img.decodeImage(params.bytes);
    if (decoded == null) {
      return ImageValidationResult.invalid(invalidFormatOrSizeMsg);
    }

    // 3. Minimum resolution check (at least 224x224 px)
    if (decoded.width < minWidth || decoded.height < minHeight) {
      return ImageValidationResult.invalid(invalidFormatOrSizeMsg);
    }

    // 4. Downscale for fast CPU checks (max 512px) & convert to grayscale
    img.Image target = decoded;
    if (target.width > 512 || target.height > 512) {
      final double ratio = target.width >= target.height
          ? 512.0 / target.width
          : 512.0 / target.height;
      target = img.copyResize(
        target,
        width: (target.width * ratio).round(),
        height: (target.height * ratio).round(),
        interpolation: img.Interpolation.linear,
      );
    }

    final img.Image gray = img.grayscale(target);

    // 5. Lighting check (mean brightness 0 – 255)
    double totalBrightness = 0.0;
    final int numPixels = gray.width * gray.height;
    for (final pixel in gray) {
      totalBrightness += pixel.r;
    }
    final double meanBrightness =
        numPixels > 0 ? (totalBrightness / numPixels) : 0.0;

    if (meanBrightness < params.minBrightness) {
      return ImageValidationResult.invalid(tooDarkMsg);
    }
    if (meanBrightness > params.maxBrightness) {
      return ImageValidationResult.invalid(tooBrightMsg);
    }

    // 6. Blur check (Laplacian variance)
    final double laplacianVar = _computeLaplacianVariance(gray);
    if (laplacianVar < params.blurThreshold) {
      return ImageValidationResult.invalid(blurryMsg);
    }

    return ImageValidationResult.valid(
      width: decoded.width,
      height: decoded.height,
      brightness: meanBrightness,
      blurScore: laplacianVar,
    );
  }

  /// Computes the variance of the 3x3 Laplacian on a grayscale image.
  static double _computeLaplacianVariance(img.Image gray) {
    final int w = gray.width;
    final int h = gray.height;
    if (w < 3 || h < 3) return 0.0;

    double sum = 0.0;
    double sumSq = 0.0;
    int count = 0;

    for (int y = 1; y < h - 1; y++) {
      for (int x = 1; x < w - 1; x++) {
        final double center = gray.getPixel(x, y).r.toDouble();
        final double top = gray.getPixel(x, y - 1).r.toDouble();
        final double bottom = gray.getPixel(x, y + 1).r.toDouble();
        final double left = gray.getPixel(x - 1, y).r.toDouble();
        final double right = gray.getPixel(x + 1, y).r.toDouble();

        // Standard discrete Laplacian filter kernel [[0, 1, 0], [1, -4, 1], [0, 1, 0]]
        final double lap = top + bottom + left + right - (4.0 * center);
        sum += lap;
        sumSq += lap * lap;
        count++;
      }
    }

    if (count == 0) return 0.0;
    final double mean = sum / count;
    return (sumSq / count) - (mean * mean);
  }

  /// Checks if prediction confidence is sufficient (>= 60%).
  static bool isConfidenceSufficient(double confidence) {
    return confidence >= minConfidenceThreshold;
  }
}
