# Light theme: complete changed source
This document contains the full contents of every changed source file and the updated AI navigation guide. No code is omitted.
## Changed files
- [AGENTS.md](../AGENTS.md)
- [lib/main.dart](../lib/main.dart)
- [lib/screens/analysis_screen.dart](../lib/screens/analysis_screen.dart)
- [lib/screens/home_screen.dart](../lib/screens/home_screen.dart)
- [lib/screens/home_screen_disease.dart](../lib/screens/home_screen_disease.dart)
- [lib/screens/home_screen_insect.dart](../lib/screens/home_screen_insect.dart)
- [lib/screens/home_screen_quality.dart](../lib/screens/home_screen_quality.dart)
- [lib/screens/home_screen_yield.dart](../lib/screens/home_screen_yield.dart)
- [lib/screens/result_screen.dart](../lib/screens/result_screen.dart)
- [lib/theme/app_theme.dart](../lib/theme/app_theme.dart)
- [lib/theme.dart](../lib/theme.dart)
- [lib/utils/theme.dart](../lib/utils/theme.dart)
- [lib/widgets/common_widgets.dart](../lib/widgets/common_widgets.dart)
- [lib/widgets/confidence_bar_disease.dart](../lib/widgets/confidence_bar_disease.dart)
- [lib/widgets/confidence_bars.dart](../lib/widgets/confidence_bars.dart)
- [lib/widgets/detection_overlay.dart](../lib/widgets/detection_overlay.dart)
- [lib/widgets/image_source_sheet.dart](../lib/widgets/image_source_sheet.dart)
- [lib/widgets/ood_badge.dart](../lib/widgets/ood_badge.dart)
- [lib/widgets/ood_indicator.dart](../lib/widgets/ood_indicator.dart)
- [lib/widgets/result_card.dart](../lib/widgets/result_card.dart)
- [lib/widgets/result_card_disease.dart](../lib/widgets/result_card_disease.dart)
- [lib/widgets/result_panel.dart](../lib/widgets/result_panel.dart)
- [lib/widgets/source_button.dart](../lib/widgets/source_button.dart)

The existing `test/widget_test.dart` remains unchanged and still references the obsolete `MyApp` widget. Native UI/model execution has not been verified.

## AGENTS.md

````markdown
# AI code navigation guide

This file is the starting point for AI assistants working on this project. Paths
are relative to the project root. Update this map when routes, services, assets,
or directory responsibilities change. Verify the current code before editing;
this guide describes the inspected source, not a guarantee of runtime behavior.

## Project overview

Flutter/Dart application for betel cultivation with four features: disease
classification, insect detection, leaf quality grading, and yield prediction.
Inference uses bundled ONNX models through `onnxruntime`. The Dart SDK constraint
is `^3.10.4`; dependencies and asset declarations live in `pubspec.yaml`.

## Start here

- `lib/main.dart`: initializes the yield ONNX model before `runApp`, configures
  system UI/orientation, and starts `BetelYieldApp` → `MainNavigationShell`.
- `lib/screens/home_screen.dart`: `HomeScreen`, the four-feature landing page;
  opens feature screens with `Navigator.push`.
- `lib/screens/`: page layouts, user input, navigation, and feature UI state.
- `lib/services/`: image model loading, preprocessing, inference, and
  out-of-distribution (OOD) checks.
- `lib/models/`: yield inference/feature engineering and result data structures.
- `lib/widgets/`: reusable inputs, result cards, confidence and OOD displays.
- `lib/theme/app_theme.dart`: the single Material 3 light theme (`AppTheme.light`)
  and semantic result colours. `lib/utils/theme.dart` and `lib/theme.dart` are
  compatibility exports. Use `Theme.of(context).colorScheme` for surfaces/text.

## Feature map

| Feature | Screens | Logic and data | Supporting widgets |
| --- | --- | --- | --- |
| Yield prediction | `lib/screens/home_screen_yield.dart`, `lib/screens/result_screen.dart` | `lib/models/onnx_predictor.dart`, `lib/models/feature_engineering.dart` | `lib/widgets/common_widgets.dart` |
| Quality grading | `lib/screens/home_screen_quality.dart`, `lib/screens/analysis_screen.dart` | `lib/services/model_initializer.dart`, `lib/services/inference_service.dart`, `lib/models/inference_result.dart` | `lib/widgets/result_card.dart`, `lib/widgets/confidence_bars.dart`, `lib/widgets/ood_indicator.dart` |
| Disease classification | `lib/screens/home_screen_disease.dart` | `lib/services/inference_service_disease.dart` (also defines its own `PredictionResult`) | `lib/widgets/result_card_disease.dart`, `lib/widgets/confidence_bar_disease.dart`, `lib/widgets/image_source_sheet.dart` |
| Insect detection | `lib/screens/home_screen_insect.dart` | `lib/services/inference_service_insect.dart`, `lib/models/detection_result.dart` | `lib/widgets/detection_overlay.dart`, `lib/widgets/result_panel.dart`, `lib/widgets/ood_badge.dart`, `lib/widgets/source_button.dart` |

### Main data flows

- Yield: eight environmental/nutrient inputs →
  `BetelFeatureEngineering.engineerFeatures` → 25 ordered features →
  `OnnxPredictor.predictDetailed` → `ResultScreen`.
- Quality: `QualityHomeScreen` → `AnalysisScreen` → camera/gallery image →
  `ModelInitializer.instance.ensureReady()` → quality `InferenceService` →
  `InferenceResult` and result widgets. The initializer owns a singleton service
  and exposes loading state through a `ValueNotifier`.
- Disease: the landing page constructs the disease `InferenceService` and passes
  it into `DiseaseHomeScreen`; the screen handles image selection and results.
- Insects: `InsectHomeScreen` owns its service; inference produces detections,
  bounding boxes, and OOD information rendered by its supporting widgets.

## Model and asset map

| Purpose | Files |
| --- | --- |
| Yield | `assets/model.onnx`, `assets/feature_columns.json` |
| Quality | `assets/models/betel_quality_model.onnx`, `assets/models/betel_quality_feature_extractor.onnx`, `assets/models/betel_quality_labels.json`, `assets/models/betel_quality_ood_config.json` |
| Disease | `assets/models/disease_betel_model.onnx`, `assets/models/disease_feature_extractor.onnx`, `assets/models/disease_ood_config.json`; `assets/models/disease_labels.json` is also present |
| Insects | `assets/models/model.onnx`, `assets/models/feature_extractor.onnx`, `assets/models/label.json`, `assets/models/ood_config.json`, `assets/models/ood_precisions.json` |

Other stored artifacts include `assets/models/ood_precisions.npz` and
`assets/models/feature_extractor_tmp.onnx.data`. Check actual service usage before
changing or removing model artifacts.

`lib/Betel Yield Prediction/Betel Yield Prediction/` contains a notebook, model,
and feature-column reference files; `lib/Betel Yield Prediction.zip` is an archive.
The running yield predictor loads `assets/model.onnx`, not the reference copy.

## Important navigation pitfalls

- All three image service files define a class named `InferenceService`. Follow
  the import path; use import aliases when combining them, as the landing page
  already does for disease inference.
- `lib/models/predictor.dart` contains a separate formula-based predictor and
  duplicate yield result/metric types. The current yield screens import
  `onnx_predictor.dart`; do not mistake the formula implementation for the active
  ONNX prediction path.
- Feature order matters. The eight input field names and the 25 model feature
  names have different orders. Preserve alignment between feature engineering,
  `assets/feature_columns.json`, and the model tensor contract.
- The application forces `ThemeMode.light`. Use dark text on white surfaces and
  `onPrimary` only on filled primary buttons/badges. Keep healthy/Grade A green,
  warnings orange, and disease/pest/error results red.
- Camera/gallery and ONNX behavior needs target-device verification. Platform
  directories existing does not establish that every target is supported.
- `test/widget_test.dart` is a stale Flutter counter-template test referencing
  `MyApp`; the current root widget is `BetelYieldApp`. Do not treat it as passing
  feature coverage. This is a source observation, not a recorded test run.

## Configuration and verification

- `pubspec.yaml`: dependencies, Dart constraint, and bundled assets.
- `pubspec.lock`: resolved package versions; avoid unrelated dependency upgrades.
- `analysis_options.yaml`: analyzer/lint configuration.
- `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`: platform runners and
  configuration. Inspect the relevant platform for permission/build changes.
- `README.md`: currently the default Flutter getting-started text.
- `docs/light-theme-full-code.md`: complete source snapshot for the light-theme
  migration; `lib/` remains the authoritative application source.

Run commands from the project root when the Flutter SDK is available:

```sh
flutter pub get
flutter analyze
flutter test
flutter run -d <device-id>
```

Use `dart format <changed-dart-files>` for Dart edits. Choose checks appropriate
to the change and report pre-existing failures separately. For model changes,
verify preprocessing, tensor shape/order, labels, OOD configuration, and native
resource cleanup together. Do not edit binary models or generated platform files
for an unrelated UI change.

## Quick searches

```sh
rg --files lib test assets
rg -n 'Navigator|MaterialPageRoute|PageRouteBuilder' lib/screens lib/main.dart
rg -n 'class |predict|initialize|dispose' lib/models lib/services
rg -n 'assets/' lib pubspec.yaml
rg -n 'theme.dart' lib
```

````

## lib/main.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/onnx_predictor.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load ONNX model at startup
  await OnnxPredictor.initialize();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppTheme.light.colorScheme.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BetelYieldApp());
}

class BetelYieldApp extends StatelessWidget {
  const BetelYieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});
  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomeScreen());
  }
}

````

## lib/screens/analysis_screen.dart

````dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/model_initializer.dart';
import '../models/inference_result.dart';
import '../widgets/result_card.dart';
import '../widgets/confidence_bars.dart';
import '../widgets/ood_indicator.dart';

/// Camera + Gallery → ONNX inference → result display.
///
/// Pipeline (notebook Cell 22 / ONNX test cell):
///   1. User picks image (Camera or Gallery)
///   2. preprocess → (1, 3, 224, 224) float32 tensor
///      – resize 224×224 bilinear
///      – normalize: mean=[0.485,0.456,0.406] std=[0.229,0.224,0.225]
///   3. Classification session → logits → softmax probabilities
///   4. Feature extractor session → (1, 1280) features
///   5. Mahalanobis OOD scoring → min_c D²(x, μ_c)
///   6. is_ood = ood_score > threshold (95th pct val IN-dist)
class AnalysisScreen extends StatefulWidget {
  final bool useCamera;
  const AnalysisScreen({super.key, required this.useCamera});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final _picker = ImagePicker();
  final _init = ModelInitializer.instance;

  Uint8List? _imageBytes;
  InferenceResult? _result;
  bool _analyzing = false;
  bool _initializing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> _boot() async {
    if (_init.state.value != ModelState.ready) {
      setState(() => _initializing = true);
      await _init.ensureReady();
      if (!mounted) return;
      if (_init.state.value == ModelState.error) {
        setState(() {
          _initializing = false;
          _error = 'Model failed to load:\n${_init.errorMessage}';
        });
        return;
      }
      setState(() => _initializing = false);
    }
    await _pickImage(widget.useCamera);
  }

  // ── Image picking + inference ──────────────────────────────────────────────

  Future<void> _pickImage(bool fromCamera) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 95,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (picked == null) {
        if (_imageBytes == null && mounted) Navigator.pop(context);
        return;
      }

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      setState(() {
        _imageBytes = bytes;
        _result = null;
        _analyzing = true;
        _error = null;
      });

      final result = await _init.service.predict(bytes);
      if (!mounted) return;
      setState(() {
        _result = result;
        _analyzing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        _error = 'Analysis failed:\n$e';
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Quality Analysis',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      actions: [
        if (_imageBytes != null && !_analyzing && !_initializing)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _showSourceSheet,
              icon: const Icon(
                Icons.cameraswitch_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              label: Text(
                'Retake',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (_initializing) {
      return _CentredStatus(
        icon: const _Spinner(),
        title: 'Loading Model',
        subtitle: 'Initialising EfficientNetB0 + OOD detector…',
      );
    }

    if (_error != null && _imageBytes == null) {
      return _ErrorView(message: _error!, onRetry: _boot);
    }

    if (_imageBytes == null) {
      return _PickerPrompt(
        onCamera: () => _pickImage(true),
        onGallery: () => _pickImage(false),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ImagePreview(bytes: _imageBytes!),
          const SizedBox(height: 20),

          if (_analyzing)
            const _AnalyzingCard()
          else if (_error != null)
            _InlineError(message: _error!, onRetry: () => _pickImage(false))
          else if (_result != null) ...[
            ResultCard(result: _result!)
                .animate()
                .fadeIn(duration: 380.ms)
                .slideY(begin: 0.05, end: 0, duration: 350.ms),
            const SizedBox(height: 14),

            OodIndicator(
              result: _result!,
            ).animate().fadeIn(delay: 120.ms, duration: 380.ms),
            const SizedBox(height: 14),

            if (!_result!.isOod) ...[
              ConfidenceBars(
                result: _result!,
              ).animate().fadeIn(delay: 220.ms, duration: 380.ms),
              const SizedBox(height: 14),
            ],

            _DescriptionCard(
              result: _result!,
            ).animate().fadeIn(delay: 320.ms, duration: 380.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (_initializing || (_error != null && _imageBytes == null)) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PickerButton(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              color: AppColors.accent,
              onTap: () => _pickImage(true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _PickerButton(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              color: AppColors.purple,
              onTap: () => _pickImage(false),
            ),
          ),
        ],
      ),
    );
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SourceSheet(
        onCamera: () {
          Navigator.pop(context);
          _pickImage(true);
        },
        onGallery: () {
          Navigator.pop(context);
          _pickImage(false);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ImagePreview extends StatelessWidget {
  final Uint8List bytes;
  const _ImagePreview({required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.07),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.memory(bytes, fit: BoxFit.cover, width: double.infinity),
      ),
    ).animate().scale(
      begin: const Offset(0.96, 0.96),
      duration: 320.ms,
      curve: Curves.easeOut,
    );
  }
}

class _AnalyzingCard extends StatelessWidget {
  const _AnalyzingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(AppColors.accent),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Analysing…',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'EfficientNetB0 forward pass + Mahalanobis OOD scoring',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          delay: 300.ms,
          duration: 1600.ms,
          color: AppColors.accent.withOpacity(0.10),
        );
  }
}

class _DescriptionCard extends StatelessWidget {
  final InferenceResult result;
  const _DescriptionCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                size: 15,
                color: AppColors.accent3,
              ),
              const SizedBox(width: 8),
              Text(
                'Recommendation',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            result.gradeDescription,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _CentredStatus extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  const _CentredStatus({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 48,
    height: 48,
    child: CircularProgressIndicator(
      strokeWidth: 2.5,
      valueColor: AlwaysStoppedAnimation(AppColors.accent),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerPrompt extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  const _PickerPrompt({required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: const Icon(
                Icons.eco_rounded,
                color: AppColors.accent,
                size: 52,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select a Betel Leaf',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo or choose from your gallery to begin '
              'AI quality grading.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCamera,
                    icon: const Icon(Icons.camera_alt_rounded, size: 18),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGallery,
                    icon: const Icon(Icons.photo_library_rounded, size: 18),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  const _SourceSheet({required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Image',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SheetTile(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: AppColors.accent,
                    onTap: onCamera,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetTile(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: AppColors.purple,
                    onTap: onGallery,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SheetTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.30)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PickerButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

````

## lib/screens/home_screen.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

import 'home_screen_disease.dart' as disease_mod;
import '../services/inference_service_disease.dart' as disease_svc;
import 'home_screen_insect.dart';
import 'home_screen_quality.dart';
import 'home_screen_yield.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  Text(
                    'Select a Tool',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 14),
                  _FeatureCard(
                    title: 'Disease Detection',
                    subtitle: 'EfficientNetB0 · 4-class · OOD Detection',
                    icon: Icons.eco_rounded,
                    gradient: AppColors.accentGradient,
                    delay: 150,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => disease_mod.DiseaseHomeScreen(
                          inferenceService: disease_svc.InferenceService(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FeatureCard(
                    title: 'Insect Detection',
                    subtitle: 'YOLOv8 · Bounding Boxes · OOD Detection',
                    icon: Icons.bug_report_rounded,
                    gradient: AppColors.purpleGradient,
                    delay: 220,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InsectHomeScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FeatureCard(
                    title: 'Leaf Quality Grading',
                    subtitle: 'EfficientNetB0 · 5-Grade Detection',
                    icon: Icons.grade_rounded,
                    gradient: const LinearGradient(
                      colors: [AppColors.accent3, AppColors.accent2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    delay: 290,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QualityHomeScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FeatureCard(
                    title: 'Yield Predictor',
                    subtitle: 'XGBoost · ONNX Runtime · Leaf Count Estimation',
                    icon: Icons.analytics_rounded,
                    gradient: const LinearGradient(
                      colors: [AppColors.blue, AppColors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    delay: 360,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const YieldHomeScreen(),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.spa_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ).animate().scale(delay: 80.ms, duration: 400.ms),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Betel Smart Suite',
                  style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'AI-powered tools for betel cultivation',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 140.ms),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final int delay;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.7,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms)
        .slideY(begin: 0.08, end: 0, delay: delay.ms, duration: 400.ms);
  }
}

````

## lib/screens/home_screen_disease.dart

````dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/inference_service_disease.dart';
import '../widgets/result_card_disease.dart';
import '../widgets/image_source_sheet.dart';

class DiseaseHomeScreen extends StatefulWidget {
  final InferenceService inferenceService;

  const DiseaseHomeScreen({super.key, required this.inferenceService});

  @override
  State<DiseaseHomeScreen> createState() => _DiseaseHomeScreenState();
}

class _DiseaseHomeScreenState extends State<DiseaseHomeScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();

  File? _selectedImage;
  PredictionResult? _result;
  bool _isAnalyzing = false;
  String? _errorMessage;

  // ── Image picking ─────────────────────────────────────────
  Future<void> _pickFromCamera() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );
      if (xFile != null) await _analyse(xFile);
    } catch (e) {
      _showError('Camera error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (xFile != null) await _analyse(xFile);
    } catch (e) {
      _showError('Gallery error: $e');
    }
  }

  Future<void> _analyse(XFile xFile) async {
    setState(() {
      _selectedImage = File(xFile.path);
      _result = null;
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      // FIX: ensure the model is initialized before predicting
      await widget.inferenceService.init();

      final bytes = await xFile.readAsBytes();
      final result = await widget.inferenceService.predict(bytes);
      if (mounted) {
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'Analysis failed: $e';
        });
      }
    }
  }

  void _showError(String msg) {
    if (mounted) setState(() => _errorMessage = msg);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  void _openSourceSheet() {
    ImageSourceSheet.show(
      context,
      onCamera: _pickFromCamera,
      onGallery: _pickFromGallery,
    );
  }

  // ── Build helpers ─────────────────────────────────────────
  Widget _buildHeroSection() {
    return Column(
      children: [
        // Gradient icon
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.eco_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) =>
              AppColors.accentGradient.createShader(bounds),
          child: Text(
            'Betel Leaf Analyser',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'EfficientNetB0 · 4-class · OOD Detection',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildClassBadges() {
    const classes = [
      ('Bacterial', AppColors.error),
      ('Dried', AppColors.warning),
      ('Fungal', AppColors.accent2),
      ('Healthy', AppColors.success),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: classes.map((c) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: c.$2.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.$2.withOpacity(0.3)),
          ),
          child: Text(
            c.$1,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: c.$2,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) {
      return GestureDetector(
        onTap: _openSourceSheet,
        child: Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.accent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Tap to add betel leaf image',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Camera or Gallery',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 300.ms);
    }

    return GestureDetector(
      onTap: _openSourceSheet,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            ),
            // Overlay tap hint
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      size: 14,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Change',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.97, 0.97));
  }

  Widget _buildAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (_selectedImage == null || _isAnalyzing)
            ? null
            : () async {
                if (_selectedImage != null) {
                  final bytes = await _selectedImage!.readAsBytes();
                  await _analyse(XFile(_selectedImage!.path));
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerLow,
          disabledForegroundColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: _isAnalyzing
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const Icon(Icons.search_rounded, size: 20),
        label: Text(
          _isAnalyzing ? 'Analysing…' : 'Analyse Leaf',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Running EfficientNetB0 inference…',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Computing OOD score via Mahalanobis distance',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                Icons.eco_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Betel AI',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          // Model info chip
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'EffNetB0',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Hero
              _buildHeroSection(),
              const SizedBox(height: 16),

              // Class badges
              _buildClassBadges(),
              const SizedBox(height: 24),

              // Image preview
              _buildImagePreview(),
              const SizedBox(height: 16),

              // Source selection buttons
              Row(
                children: [
                  Expanded(
                    child: _buildSourceButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: AppColors.accent,
                      onTap: _pickFromCamera,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSourceButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: AppColors.blue,
                      onTap: _pickFromGallery,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Analyse button (shown only when image selected and not already loading)
              if (_selectedImage != null) ...[
                _buildAnalysisButton(),
                const SizedBox(height: 24),
              ],

              // Loading
              if (_isAnalyzing) ...[
                _buildLoadingIndicator(),
                const SizedBox(height: 24),
              ],

              // Error
              if (_errorMessage != null) ...[
                _ErrorBanner(message: _errorMessage!),
                const SizedBox(height: 24),
              ],

              // Result
              if (_result != null) ...[
                _SectionHeader(title: 'Analysis Result'),
                const SizedBox(height: 12),
                ResultCard(result: _result!),
                const SizedBox(height: 32),
              ],

              // Getting started hint (when no image)
              if (_selectedImage == null) ...[
                const SizedBox(height: 8),
                _buildGettingStartedTips(),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),

      // FAB for quick image source selection
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSourceSheet,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: Text(
          'New Scan',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.4)),
        backgroundColor: color.withOpacity(0.06),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildGettingStartedTips() {
    const tips = [
      (
        Icons.center_focus_strong_rounded,
        'Hold the camera steady, close to the leaf',
      ),
      (Icons.wb_sunny_outlined, 'Use good natural or indoor lighting'),
      (Icons.crop_rounded, 'Keep the leaf centred in the frame'),
      (Icons.visibility_outlined, 'Ensure the leaf surface is clearly visible'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips for best results',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(t.$1, size: 16, color: AppColors.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.$2,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

````

## lib/screens/home_screen_insect.dart

````dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/inference_service_insect.dart';
import '../models/detection_result.dart';
import '../widgets/detection_overlay.dart';
import '../widgets/result_panel.dart';
import '../widgets/ood_badge.dart';
import '../widgets/source_button.dart';

class InsectHomeScreen extends StatefulWidget {
  const InsectHomeScreen({super.key});

  @override
  State<InsectHomeScreen> createState() => _InsectHomeScreenState();
}

class _InsectHomeScreenState extends State<InsectHomeScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  final _inferenceService = InferenceService();

  String? _imagePath;
  DetectionResult? _result;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    // Pre-warm
    _inferenceService.initialize().catchError((_) {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _inferenceService.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 95);
      if (picked == null) return;

      setState(() {
        _imagePath = picked.path;
        _result = null;
        _errorMessage = null;
        _isLoading = true;
      });

      final result = await _inferenceService.runInference(picked.path);

      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }

  void _reset() => setState(() {
    _imagePath = null;
    _result = null;
    _errorMessage = null;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: _imagePath == null ? _buildWelcome() : _buildAnalysisView(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.bug_report,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'BetelDetect',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Text(
              'YOLOv8',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (_imagePath != null)
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
            onPressed: _reset,
            tooltip: 'Reset',
          ),
      ],
    );
  }

  // ── Welcome screen ────────────────────────────────────────────────
  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.biotech_rounded,
                  size: 56,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Betel Insect Detector',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Detect and classify insects on betel crops\nusing YOLOv8 with OOD detection.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildClassGrid(),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: SourceButton(
                  label: 'Gallery',
                  icon: Icons.photo_library_rounded,
                  gradient: AppColors.accentGradient,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SourceButton(
                  label: 'Camera',
                  icon: Icons.camera_alt_rounded,
                  gradient: AppColors.purpleGradient,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildFeatureRow(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildClassGrid() {
    const classes = [
      ('Green-Leafhopper', AppColors.error, Icons.grass),
      ('Aphid', AppColors.error, Icons.lens_blur),
      ('Beetle', AppColors.error, Icons.circle),
      ('Grasshopper', AppColors.error, Icons.nature),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detectable Classes',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: classes.map((c) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.$2.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: c.$2.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(c.$3, size: 14, color: c.$2),
                  const SizedBox(width: 6),
                  Text(
                    c.$1,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: c.$2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeatureRow() {
    final features = [
      ('Bounding Boxes', Icons.crop_free_rounded, AppColors.accent),
      ('Confidence', Icons.percent_rounded, AppColors.blue),
      ('OOD Detection', Icons.radar_rounded, AppColors.purple),
    ];
    return Row(
      children: features.map((f) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Icon(f.$2, color: f.$3, size: 22),
                const SizedBox(height: 6),
                Text(
                  f.$1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Analysis view ─────────────────────────────────────────────────
  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageSection(),
          if (_isLoading) _buildLoadingSection(),
          if (_errorMessage != null) _buildErrorSection(),
          if (_result != null) ...[
            OodBadge(result: _result!),
            ResultPanel(result: _result!),
          ],
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: SourceButton(
                    label: 'Gallery',
                    icon: Icons.photo_library_rounded,
                    gradient: AppColors.accentGradient,
                    onTap: () => _pickImage(ImageSource.gallery),
                    compact: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SourceButton(
                    label: 'Camera',
                    icon: Icons.camera_alt_rounded,
                    gradient: AppColors.purpleGradient,
                    onTap: () => _pickImage(ImageSource.camera),
                    compact: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(
            File(_imagePath!),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        if (_result != null)
          Positioned.fill(child: DetectionOverlay(result: _result!)),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: AppColors.accent,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Running YOLOv8 inference…',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

````

## lib/screens/home_screen_quality.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'analysis_screen.dart';

class QualityHomeScreen extends StatelessWidget {
  const QualityHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _buildHeroCard(context),
                  const SizedBox(height: 24),
                  _buildGradeGuide(context),
                  const SizedBox(height: 24),
                  _buildModelInfo(context),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo mark
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.eco,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 22,
            ),
          ).animate().scale(delay: 100.ms, duration: 400.ms),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Betel Quality AI',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'EfficientNetB0 · 5-Grade Detection',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 150.ms),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.success.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'v1.0',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon row
              Row(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColors.accentGradient.createShader(bounds),
                    child: Icon(
                      Icons.center_focus_strong_rounded,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Instant Quality Analysis',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Capture or select a betel leaf photo to receive an AI-powered '
                'grade assessment with OOD rejection.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      gradient: AppColors.accentGradient,
                      onTap: () => _openAnalysis(context, useCamera: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      gradient: AppColors.purpleGradient,
                      onTap: () => _openAnalysis(context, useCamera: false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0.0, delay: 200.ms, duration: 400.ms);
  }

  void _openAnalysis(BuildContext context, {required bool useCamera}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnalysisScreen(useCamera: useCamera)),
    );
  }

  Widget _buildGradeGuide(BuildContext context) {
    const grades = [
      _GradeInfo(
        'A',
        'Premium',
        AppColors.accent,
        'Pristine, deep green, no blemishes',
      ),
      _GradeInfo(
        'B',
        'Good',
        AppColors.success,
        'Minor surface marks acceptable',
      ),
      _GradeInfo(
        'C',
        'Average',
        AppColors.accent3,
        'Some yellowing or light damage',
      ),
      _GradeInfo('D', 'Below Avg', AppColors.warning, 'Notable discoloration'),
      _GradeInfo('E', 'Poor', AppColors.error, 'Significant damage or disease'),
    ];

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Grade Reference',
              icon: Icons.grade_rounded,
              color: AppColors.accent3,
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: grades.asMap().entries.map((entry) {
                  final i = entry.key;
                  final g = entry.value;
                  return Column(
                    children: [
                      _GradeRow(grade: g),
                      if (i < grades.length - 1)
                        Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withOpacity(0.5),
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.05, end: 0.0, delay: 300.ms);
  }

  Widget _buildModelInfo(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Model Architecture',
              icon: Icons.memory_rounded,
              color: AppColors.purple,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.auto_awesome,
                    label: 'Backbone',
                    value: 'EfficientNetB0',
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.category_rounded,
                    label: 'Classes',
                    value: '5 Grades',
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.shield_rounded,
                    label: 'OOD Detection',
                    value: 'Mahalanobis',
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.tune_rounded,
                    label: 'Input Size',
                    value: '224 × 224',
                    color: AppColors.accent3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'OOD threshold calibrated at the 95th percentile of '
                      'validation in-distribution Mahalanobis scores. '
                      'Samples exceeding this are rejected rather than mis-classified.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 500.ms)
        .slideY(begin: 0.05, end: 0.0, delay: 400.ms);
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openAnalysis(context, useCamera: true),
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openAnalysis(context, useCamera: false),
              icon: const Icon(Icons.photo_library_rounded, size: 20),
              label: const Text('Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeInfo {
  final String grade;
  final String label;
  final Color color;
  final String description;

  const _GradeInfo(this.grade, this.label, this.color, this.description);
}

class _GradeRow extends StatelessWidget {
  final _GradeInfo grade;

  const _GradeRow({required this.grade});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: grade.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: grade.color.withOpacity(0.4)),
            ),
            alignment: Alignment.center,
            child: Text(
              grade.grade,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: grade.color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade ${grade.grade} — ${grade.label}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  grade.description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

````

## lib/screens/home_screen_yield.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/feature_engineering.dart';
import '../models/onnx_predictor.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'result_screen.dart';

class YieldHomeScreen extends StatefulWidget {
  const YieldHomeScreen({super.key});
  @override
  State<YieldHomeScreen> createState() => _YieldHomeScreenState();
}

class _YieldHomeScreenState extends State<YieldHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Notebook sample input (Section 17):
  // SM=60, Rain=100, Hum=70, N=135, P=45, K=100, T=29, pH=6 → 35.73 leaves (real ONNX)
  final Map<String, double> _inputs = {
    'Soil_Moisture': 60.0,
    'Rainfall': 100.0,
    'Humidity': 70.0,
    'N': 135.0,
    'P': 45.0,
    'K': 100.0,
    'Temperature': 29.0,
    'Soil_pH': 6.0,
  };

  final Map<String, String?> _errors = {};
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    _errors.clear();
    bool valid = true;
    for (final feat in BetelFeatureEngineering.baseFeatureNames) {
      final bounds = BetelFeatureEngineering.inputBounds[feat]!;
      final val = _inputs[feat]!;
      if (val < bounds['min']! || val > bounds['max']!) {
        // Mirrors notebook: "⚠  Please enter a valid number."
        _errors[feat] =
            '⚠ Valid range: ${bounds['min']} – ${bounds['max']} ${BetelFeatureEngineering.featureUnits[feat]}';
        valid = false;
      }
    }
    setState(() {});
    return valid;
  }

  Future<void> _predict() async {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⚠  Please enter valid numbers within the allowed ranges.',
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isCalculating = true);

    try {
      // Real ONNX inference — same as notebook sess.run(['variable'], {'float_input': arr})
      final result = await OnnxPredictor.predictDetailed(_inputs);
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) =>
              ResultScreen(result: result, inputs: Map.from(_inputs)),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          ),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ONNX inference error: $e',
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isCalculating = false);
    }
  }

  void _resetSample() => setState(() {
    _inputs.addAll({
      'Soil_Moisture': 60.0,
      'Rainfall': 100.0,
      'Humidity': 70.0,
      'N': 135.0,
      'P': 45.0,
      'K': 100.0,
      'Temperature': 29.0,
      'Soil_pH': 6.0,
    });
    _errors.clear();
  });

  void _resetOptimal() => setState(() {
    _inputs.addAll({
      'Soil_Moisture': 65.0,
      'Rainfall': 225.0,
      'Humidity': 75.0,
      'N': 150.0,
      'P': 80.0,
      'K': 120.0,
      'Temperature': 28.5,
      'Soil_pH': 6.25,
    });
    _errors.clear();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── App bar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 128,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            AnimatedBuilder(
                              animation: _pulseAnim,
                              builder: (_, child) => Transform.scale(
                                scale: _pulseAnim.value,
                                child: child,
                              ),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: AppColors.accentGradient,
                                ),
                                child: const Center(
                                  child: Text(
                                    '🌿',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GradientText(
                                  'Betel Yield Predictor',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'XGBoost · ONNX Runtime · R² 94.48%',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _Stat('Features', '25', AppColors.accent),
                            const SizedBox(width: 16),
                            _Stat('R² Test', '94.48%', AppColors.blue),
                            const SizedBox(width: 16),
                            _Stat('MAE', '±1.88', AppColors.purple),
                            const SizedBox(width: 16),
                            _Stat('MAPE', '4.94%', AppColors.accent2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                const Text('🌿', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                // Text('Betel Yield Predictor',
                //     style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
            // actions: [
            //   PopupMenuButton<String>(
            //     icon: Icon(Icons.tune_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
            //     color: Theme.of(context).colorScheme.surface,
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
            //         side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            //     onSelected: (v) { if (v=='sample') _resetSample(); if (v=='optimal') _resetOptimal(); },
            //     itemBuilder: (_) => [
            //       PopupMenuItem(value: 'sample', child: Row(children: [
            //         Icon(Icons.science_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            //         const SizedBox(width: 8),
            //         Text('Notebook sample (→35.73 leaves)',
            //             style: GoogleFonts.inter(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
            //       ])),
            //       PopupMenuItem(value: 'optimal', child: Row(children: [
            //         const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.accent),
            //         const SizedBox(width: 8),
            //         Text('All optimal flags = 1',
            //             style: GoogleFonts.inter(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
            //       ])),
            //     ],
            //   ),
            //   const SizedBox(width: 8),
            // ],
          ),

          // ── Input form ────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // // Info banner
                // FadeInDown(duration: const Duration(milliseconds: 400), child: Container(
                //   padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 14),
                //   decoration: BoxDecoration(
                //     color: AppColors.accent.withOpacity(0.06), borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: AppColors.accent.withOpacity(0.2))),
                //   child: Row(children: [
                //     const Icon(Icons.memory_rounded, size: 15, color: AppColors.accent),
                //     const SizedBox(width: 8),
                //     Expanded(child: Text(
                //       'Enter 8 base features → engineer_features_single() builds 25 features → '
                //       'XGBoost ONNX model (float_input [1×25]) → Leaf_Count_per_Bed prediction.',
                //       style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant))),
                //   ]),
                // )),

                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 40),
                  child: _SectionLabel('Soil Conditions', '🌱'),
                ),
                ..._buildFields(['Soil_Moisture', 'Soil_pH'], 80),
                const SizedBox(height: 14),

                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 140),
                  child: _SectionLabel('Weather', '🌤️'),
                ),
                ..._buildFields(['Rainfall', 'Humidity', 'Temperature'], 180),
                const SizedBox(height: 14),

                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 240),
                  child: _SectionLabel('NPK Fertilizer', '🧪'),
                ),
                ..._buildFields(['N', 'P', 'K'], 280),
                const SizedBox(height: 18),

                // Live optimal flags
                // FadeInDown(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 360),
                //     child: _LiveFlagsCard(inputs: _inputs)),
                // const SizedBox(height: 18),
              ]),
            ),
          ),
        ],
      ),

      // ── Predict button ────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isCalculating ? null : _predict,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCalculating
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isCalculating
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.accent.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Running ONNX inference…',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Predict Leaf Count per Bed',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields(List<String> feats, int baseDelay) =>
      feats.asMap().entries.map((e) {
        final name = e.value;
        final bounds = BetelFeatureEngineering.inputBounds[name]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FadeInLeft(
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: baseDelay + e.key * 50),
            child: FeatureInputField(
              featureName: name,
              displayName: name.replaceAll('_', ' '),
              unit: BetelFeatureEngineering.featureUnits[name] ?? '',
              icon: BetelFeatureEngineering.featureIcons[name] ?? '📊',
              description:
                  BetelFeatureEngineering.featureDescriptions[name] ?? '',
              minValue: bounds['min']!,
              maxValue: bounds['max']!,
              currentValue: _inputs[name]!,
              errorText: _errors[name],
              onChanged: (v) => setState(() {
                _inputs[name] = v;
                _errors.remove(name);
              }),
            ),
          ),
        );
      }).toList();
}

// Live optimal flags widget
// class _LiveFlagsCard extends StatelessWidget {
//   final Map<String, double> inputs;
//   const _LiveFlagsCard({required this.inputs});

//   @override
//   Widget build(BuildContext context) {
//     final sm   = inputs['Soil_Moisture'] ?? 0;
//     final temp = inputs['Temperature']   ?? 0;
//     final ph   = inputs['Soil_pH']       ?? 0;
//     final rain = inputs['Rainfall']      ?? 0;

//     final flags = {
//       'optimal_moisture': sm   >= 55 && sm   <= 75,
//       'optimal_temp':     temp >= 25 && temp <= 32,
//       'optimal_pH':       ph   >= 5.5 && ph  <= 7.0,
//       'optimal_rain':     rain >= 150 && rain <= 300,
//     };
//     final metCount = flags.values.where((v) => v).length;

//     return GlowCard(
//       glowColor: metCount >= 3 ? AppColors.success : AppColors.accent3,
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         SectionHeader(
//           title: 'Live Optimal Flags',
//           subtitle: 'Section 2 — int(condition) — these are features 21–24 of the ONNX input',
//           trailing: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: (metCount >= 3 ? AppColors.success : AppColors.accent3).withOpacity(0.15),
//               borderRadius: BorderRadius.circular(8)),
//             child: Text('$metCount/4 = 1',
//                 style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700,
//                     color: metCount >= 3 ? AppColors.success : AppColors.accent3)),
//           ),
//         ),
//         Row(children: [
//           _FlagChip('optimal_moisture', flags['optimal_moisture']!, '55–75%',  21),
//           const SizedBox(width: 6),
//           _FlagChip('optimal_temp',     flags['optimal_temp']!,     '25–32°C', 22),
//         ]),
//         const SizedBox(height: 6),
//         Row(children: [
//           _FlagChip('optimal_pH',       flags['optimal_pH']!,       '5.5–7.0', 23),
//           const SizedBox(width: 6),
//           _FlagChip('optimal_rain',     flags['optimal_rain']!,     '150–300mm',24),
//         ]),
//       ]),
//     );
//   }
// }

class _FlagChip extends StatelessWidget {
  final String label;
  final bool value;
  final String range;
  final int featureIndex;
  const _FlagChip(this.label, this.value, this.range, this.featureIndex);

  @override
  Widget build(BuildContext context) {
    final color = value
        ? AppColors.success
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'f$featureIndex',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    range,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value ? '1' : '0',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label, icon;
  const _SectionLabel(this.label, this.icon);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(
        '$label: ',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      Text(
        value,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ],
  );
}

````

## lib/screens/result_screen.dart

````dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/onnx_predictor.dart';
import '../models/feature_engineering.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResult result;
  final Map<String, double> inputs;
  const ResultScreen({super.key, required this.result, required this.inputs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Prediction Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: Center(
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //         decoration: BoxDecoration(
        //           color: AppColors.accent.withOpacity(0.1),
        //           borderRadius: BorderRadius.circular(20),
        //           border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        //         ),
        //         child: Text('XGBoost · ONNX',
        //             style: GoogleFonts.jetBrainsMono(
        //                 fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Main prediction + yield bucket
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: _MainPredictionCard(result: result),
            ),
            const SizedBox(height: 14),

            // 2. Yield range bucket (Section 15 — exact bins/labels)
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 80),
              child: _YieldBucketCard(result: result),
            ),
            const SizedBox(height: 14),

            // 7. Optimal conditions (Section 2 flags)
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 480),
              child: _OptimalConditionsCard(result: result, inputs: inputs),
            ),
            const SizedBox(height: 14),

            // 8. Feature contributions (SHAP-style, Section 12)
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 560),
              child: _FeatureContributionCard(result: result),
            ),
            const SizedBox(height: 14),

            // 9. Input summary
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 640),
              child: _InputSummaryCard(inputs: inputs),
            ),
            const SizedBox(height: 14),

            // 10. All 25 engineered features (Section 2 pipeline)
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 720),
              child: _EngineeredFeaturesCard(result: result),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── 1. Main prediction card ──────────────────────────────────────────────────
class _MainPredictionCard extends StatelessWidget {
  final PredictionResult result;
  const _MainPredictionCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Predicted Leaf Count per Bed',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (b) => AppColors.accentGradient.createShader(b),
                child: Text(
                  result.predictedLeafCount.round().toString(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  ' leaves',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Out-of-range warning — mirrors notebook "⚠ N samples fell outside bin range"
          if (result.isOutOfRange)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent3.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accent3.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: AppColors.accent3,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '⚠ Value outside bucket range [20–68)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.accent3,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _bucketColor(context).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _bucketColor(context).withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(result.bucketEmoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '${result.bucketDescription}  (${result.bucketDisplay} leaves)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _bucketColor(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  'Prediction Score (R²): ${(result.r2 * 100).toStringAsFixed(2)}%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  '✔ Prediction carries ~±${result.mae.toStringAsFixed(1)} leaf margin of error',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _bucketColor(BuildContext context) {
    switch (result.yieldBucket) {
      case '20–29':
        return AppColors.error;
      case '30–34':
        return AppColors.accent3;
      case '35–39':
        return AppColors.accent3;
      case '40–44':
        return AppColors.success;
      case '45–49':
        return AppColors.success;
      case '50–54':
        return AppColors.accent;
      case '55–67':
        return AppColors.accent;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}

// ── 2. Yield Bucket Card — exact Section 15 bins ─────────────────────────────
class _YieldBucketCard extends StatelessWidget {
  final PredictionResult result;
  const _YieldBucketCard({required this.result});

  @override
  Widget build(BuildContext context) {
    // bins = [20,30,35,40,45,50,55,68], labels = 7 buckets
    const bins = YieldBucket.bins;
    const labels = YieldBucket.labels;

    return GlowCard(
      glowColor: AppColors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Yield Range Bucket',
            subtitle: 'Section 15 — bins=[20,30,35,40,45,50,55,68] right=False',
          ),
          // Show all 7 buckets as tiles, highlight the active one
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(labels.length, (i) {
              final label = labels[i];
              final isActive = label == result.yieldBucket;
              final color = isActive
                  ? AppColors.accent
                  : Theme.of(context).colorScheme.onSurfaceVariant;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.accent.withOpacity(0.15)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withOpacity(0.5),
                    width: isActive ? 1.5 : 0.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.w800
                            : FontWeight.w400,
                        color: color,
                      ),
                    ),
                    if (isActive)
                      Text(
                        '← YOUR VALUE',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          color: AppColors.accent,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Text(result.bucketEmoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.bucketDescription,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Bucket: ${result.bucketDisplay} leaves/bed',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (result.isOutOfRange)
                        Text(
                          '⚠ Outside bucket range — excluded in notebook classification report',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.accent3,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 3. Regression Report — Section 5 (Train/Val/Test) ────────────────────────
class _RegressionReportCard extends StatelessWidget {
  const _RegressionReportCard();

  @override
  Widget build(BuildContext context) {
    final reports = [
      AllRegressionReports.train,
      AllRegressionReports.validation,
      AllRegressionReports.test,
    ];
    final colors = [AppColors.accent, AppColors.accent2, AppColors.blue];

    return GlowCard(
      glowColor: AppColors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Regression Report',
            subtitle: 'Section 5 — regression_report() on Train / Val / Test',
          ),
          // Header row
          _TableRow(
            cells: const ['Split', 'R²', 'MAE', 'RMSE', 'MAPE%'],
            isHeader: true,
            color: AppColors.accent,
          ),
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
            height: 1,
          ),
          ...List.generate(reports.length, (i) {
            final r = reports[i];
            return _TableRow(
              cells: [
                r.splitName,
                r.r2Percent,
                r.mae.toStringAsFixed(4),
                r.rmse.toStringAsFixed(4),
                '${r.mape.toStringAsFixed(2)}%',
              ],
              color: colors[i],
              isHeader: false,
            );
          }),
          const SizedBox(height: 10),
          // R² bar comparison
          ...List.generate(reports.length, (i) {
            final r = reports[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 78,
                    child: Text(
                      r.splitName,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: r.r2,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(colors[i]),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    r.r2Percent,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: colors[i],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final Color color;
  const _TableRow({
    required this.cells,
    required this.isHeader,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: cells.asMap().entries.map((e) {
          final isFirst = e.key == 0;
          return Expanded(
            flex: isFirst ? 2 : 2,
            child: Text(
              e.value,
              style: isHeader
                  ? GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    )
                  : isFirst
                  ? GoogleFonts.inter(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    )
                  : GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              textAlign: isFirst ? TextAlign.left : TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── 4. Tolerance Curve — Section 13 ──────────────────────────────────────────
// tolerances = [1,2,3,4,5,7,10], % within each tolerance
class _ToleranceCurveCard extends StatelessWidget {
  const _ToleranceCurveCard();

  @override
  Widget build(BuildContext context) {
    final tolerances = ModelMetrics.toleranceLevels;
    final percents = ModelMetrics.tolerancePercents;
    final maxPct = percents.last; // 99.1

    return GlowCard(
      glowColor: AppColors.accent3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Prediction Tolerance Curve',
            subtitle: 'Section 13 — % predictions within ±N leaves (Test set)',
          ),
          // Bar chart representation
          ...List.generate(tolerances.length, (i) {
            final pct = percents[i];
            final isTarget = pct >= 95.0; // notebook's 95% axhline
            final color = isTarget ? AppColors.success : AppColors.accent3;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '±${tolerances[i]}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: pct / 100.0,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '${pct.toStringAsFixed(1)}%',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  if (isTarget)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: AppColors.success,
                ),
                const SizedBox(width: 6),
                Text(
                  '95% threshold line — matches notebook axhline(95)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 5. Cross-Validation — Section 14 ─────────────────────────────────────────
// 5-fold KFold, shuffle=True, random_state=42, scoring='r2'
class _CrossValidationCard extends StatelessWidget {
  const _CrossValidationCard();

  @override
  Widget build(BuildContext context) {
    final folds = ModelMetrics.cvFoldScores;
    final mean = ModelMetrics.cvMean;
    final std = ModelMetrics.cvStdDev;
    final minVal = folds.reduce((a, b) => a < b ? a : b);
    final maxVal = folds.reduce((a, b) => a > b ? a : b);

    return GlowCard(
      glowColor: AppColors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '5-Fold Cross-Validation',
            subtitle:
                'Section 14 — KFold(n_splits=5, shuffle=True, random_state=42), scoring="r2"',
          ),
          // Fold scores
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(folds.length, (i) {
                    final v = folds[i];
                    final isMin = v == minVal;
                    final isMax = v == maxVal;
                    final color = isMax
                        ? AppColors.accent
                        : (isMin ? AppColors.accent2 : AppColors.blue);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                            child: Text(
                              'Fold ${i + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: v,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  color,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 58,
                            child: Text(
                              '${(v * 100).toStringAsFixed(2)}%',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Summary stats matching notebook print output
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CV R²: ${mean.toStringAsFixed(4)} ± ${std.toStringAsFixed(4)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fold scores: [${folds.map((s) => s.toStringAsFixed(4)).join(", ")}]',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 6. Absolute Error Distribution — Section 13 ───────────────────────────────
class _AbsErrorCard extends StatelessWidget {
  const _AbsErrorCard();

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      glowColor: AppColors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Test Absolute Error Distribution',
            subtitle: 'Section 13 — abs_err = |y_test − y_pred|',
          ),
          Row(
            children: [
              Expanded(
                child: MetricChip(
                  label: 'Mean AbsErr',
                  value: ModelMetrics.absErrorMean.toStringAsFixed(2),
                  color: AppColors.accent3,
                  subtitle: 'leaves',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricChip(
                  label: '90th Pctile',
                  value: ModelMetrics.absError90thPct.toStringAsFixed(2),
                  color: AppColors.accent2,
                  subtitle: 'leaves',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricChip(
                  label: 'RMSE',
                  value: ModelMetrics.rmseTest.toStringAsFixed(2),
                  color: AppColors.blue,
                  subtitle: 'leaves',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Visual histogram approximation using bars
          _AbsErrorHistogram(),
        ],
      ),
    );
  }
}

class _AbsErrorHistogram extends StatelessWidget {
  // Approximate histogram based on MAE=1.88, RMSE=2.44 — normal-like distribution
  final List<_HistBin> bins = const [
    _HistBin('0–1', 0.362, AppColors.accent),
    _HistBin('1–2', 0.286, AppColors.accent),
    _HistBin('2–3', 0.145, AppColors.blue),
    _HistBin('3–4', 0.082, AppColors.blue),
    _HistBin('4–5', 0.049, AppColors.accent3),
    _HistBin('5–7', 0.052, AppColors.accent3),
    _HistBin('7–10', 0.024, AppColors.accent2),
  ];
  const _AbsErrorHistogram();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Approximate error histogram (Test set):',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...bins.map(
          (b) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    b.label,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: b.fraction,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.outlineVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(b.color),
                      minHeight: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(b.fraction * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: b.color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(width: 10, height: 10, color: AppColors.accent3),
            const SizedBox(width: 4),
            Text(
              'Mean=1.88  ',
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.accent3),
            ),
            Container(width: 10, height: 10, color: AppColors.accent2),
            const SizedBox(width: 4),
            Text(
              '90th pct=4.21',
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.accent2),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistBin {
  final String label;
  final double fraction;
  final Color color;
  const _HistBin(this.label, this.fraction, this.color);
}

// ── 7. Optimal Conditions — Section 2 binary flags ───────────────────────────
class _OptimalConditionsCard extends StatelessWidget {
  final PredictionResult result;
  final Map<String, double> inputs;
  const _OptimalConditionsCard({required this.result, required this.inputs});

  @override
  Widget build(BuildContext context) {
    final metCount = result.conditionsMetCount;
    return GlowCard(
      glowColor: metCount >= 3 ? AppColors.success : AppColors.accent3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Optimal Range Flags',
            subtitle: 'Section 2 — binary features (int cast, right=False)',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (metCount >= 3 ? AppColors.success : AppColors.accent3)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$metCount/4 = 1',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: metCount >= 3 ? AppColors.success : AppColors.accent3,
                ),
              ),
            ),
          ),
          // Each flag exactly matches the notebook condition
          _FlagRow(
            'optimal_moisture',
            'Soil_Moisture',
            '55 ≤ SM ≤ 75',
            inputs['Soil_Moisture']!,
            result.optimalConditions['optimal_moisture'] ?? false,
          ),
          _FlagRow(
            'optimal_temp',
            'Temperature',
            '25 ≤ Temp ≤ 32',
            inputs['Temperature']!,
            result.optimalConditions['optimal_temp'] ?? false,
          ),
          _FlagRow(
            'optimal_pH',
            'Soil_pH',
            '5.5 ≤ pH ≤ 7.0',
            inputs['Soil_pH']!,
            result.optimalConditions['optimal_pH'] ?? false,
          ),
          _FlagRow(
            'optimal_rain',
            'Rainfall',
            '150 ≤ Rain ≤ 300',
            inputs['Rainfall']!,
            result.optimalConditions['optimal_rain'] ?? false,
          ),
        ],
      ),
    );
  }
}

class _FlagRow extends StatelessWidget {
  final String flagName, featName, condition;
  final double value;
  final bool isMet;
  const _FlagRow(
    this.flagName,
    this.featName,
    this.condition,
    this.value,
    this.isMet,
  );

  @override
  Widget build(BuildContext context) {
    final color = isMet
        ? AppColors.success
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(
              isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flagName,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    condition,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'value: ${value.toStringAsFixed(1)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'flag = ${isMet ? "1" : "0"}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── 8. Feature Contribution (SHAP-style) — Section 12 ────────────────────────
class _FeatureContributionCard extends StatelessWidget {
  final PredictionResult result;
  const _FeatureContributionCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final sorted = result.featureContributions.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    final maxAbs = sorted.isEmpty ? 1.0 : sorted.first.value.abs();

    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Feature Contributions',
            subtitle:
                'Section 12 — SHAP-style leave-one-out on 8 base features',
          ),
          ...sorted.map((e) {
            final isPos = e.value >= 0;
            final color = isPos ? AppColors.accent : AppColors.accent2;
            final frac = maxAbs > 0 ? (e.value.abs() / maxAbs) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    BetelFeatureEngineering.featureIcons[e.key] ?? '📊',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 110,
                    child: Text(
                      e.key.replaceAll('_', ' '),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: frac.toDouble(),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 52,
                    child: Text(
                      '${isPos ? "+" : ""}${e.value.toStringAsFixed(2)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── 9. Input Summary ──────────────────────────────────────────────────────────
class _InputSummaryCard extends StatelessWidget {
  final Map<String, double> inputs;
  const _InputSummaryCard({required this.inputs});

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Input Summary',
            subtitle: '8 base features (BASE_FEATURES list)',
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.2,
            children: BetelFeatureEngineering.baseFeatureNames.map((name) {
              final value = inputs[name] ?? 0.0;
              final icon = BetelFeatureEngineering.featureIcons[name] ?? '📊';
              final unit = BetelFeatureEngineering.featureUnits[name] ?? '';
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name.replaceAll('_', ' '),
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1)} $unit',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── 10. All 25 Engineered Features — Section 2 pipeline ──────────────────────
class _EngineeredFeaturesCard extends StatefulWidget {
  final PredictionResult result;
  const _EngineeredFeaturesCard({required this.result});
  @override
  State<_EngineeredFeaturesCard> createState() =>
      _EngineeredFeaturesCardState();
}

class _EngineeredFeaturesCardState extends State<_EngineeredFeaturesCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final entries = widget.result.engineeredValues.entries.toList();
    final displayed = _expanded ? entries : entries.take(8).toList();

    return GlowCard(
      glowColor: AppColors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Engineered Feature Vector',
            subtitle:
                'Section 2 — engineer_features_single() → 25 values passed to ONNX',
            trailing: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? 'Show less' : 'All 25 →',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.accent),
              ),
            ),
          ),
          ...displayed.asMap().entries.map((e) {
            final idx = e.key;
            final entry = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      'f$idx',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 160,
                    child: Text(
                      entry.key,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                  ),
                  Text(
                    _fmtVal(entry.value),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (!_expanded && entries.length > 8)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '… ${entries.length - 8} more features hidden',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _fmtVal(double v) {
    if (v == v.roundToDouble() && v.abs() < 10000) return v.toInt().toString();
    if (v.abs() > 100000) return v.toStringAsExponential(2);
    return v.toStringAsFixed(3);
  }
}

````

## lib/theme/app_theme.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic colours remain readable on white and lightly tinted surfaces.
/// Neutral surfaces and text should use Theme.of(context).colorScheme.
abstract final class AppColors {
  static const accent = Color(0xFF1B5E20);
  static const success = accent;
  static const warning = Color(0xFF9A4300);
  static const error = Color(0xFFB3261E);
  static const info = Color(0xFF0D47A1);
  static const blue = info;
  static const purple = Color(0xFF6A1B9A);
  static const accent2 = error;
  static const accent3 = warning;

  static const accentGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const purpleGradient = LinearGradient(
    colors: [purple, Color(0xFF4527A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

abstract final class AppTheme {
  static final ThemeData light = _buildLight();

  static ThemeData _buildLight() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF2E7D32),
          onPrimary: Colors.white,
          secondary: const Color(0xFF66BB6A),
          onSecondary: const Color(0xFF1B1B1B),
          surface: Colors.white,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: Colors.white,
          surfaceContainer: Colors.white,
          surfaceContainerHigh: const Color(0xFFF5F5F5),
          surfaceContainerHighest: const Color(0xFFF0F0F0),
          onSurface: const Color(0xFF1B1B1B),
          onSurfaceVariant: const Color(0xFF5F6368),
          outline: const Color(0xFF5F6368),
          outlineVariant: const Color(0xFFE0E0E0),
          error: AppColors.error,
          onError: Colors.white,
          surfaceTint: Colors.transparent,
        );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: scheme.outlineVariant),
    );
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.light(useMaterial3: true).textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: scheme.surface,
      textTheme: textTheme.copyWith(
        bodySmall: textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      iconTheme: IconThemeData(color: scheme.primary),
      dividerColor: scheme.outlineVariant,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: scheme.primary),
        actionsIconTheme: IconThemeData(color: scheme.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.surfaceContainerHighest,
          disabledForegroundColor: scheme.onSurfaceVariant,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: inputBorder(scheme.outlineVariant),
        enabledBorder: inputBorder(scheme.outlineVariant),
        focusedBorder: inputBorder(scheme.primary, 2),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 2),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        helperStyle: TextStyle(color: scheme.onSurfaceVariant),
        errorStyle: TextStyle(color: scheme.error),
        floatingLabelStyle: TextStyle(color: scheme.primary),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.12),
        shape: shape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: shape,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.primary),
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        elevation: 2,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        elevation: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        modalBackgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: shape,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surface,
        contentTextStyle: textTheme.bodyMedium,
        actionTextColor: scheme.primary,
        closeIconColor: scheme.onSurfaceVariant,
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        shape: shape,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.surfaceContainerHighest,
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimaryContainer),
        side: BorderSide(color: scheme.outlineVariant),
        checkmarkColor: scheme.primary,
        deleteIconColor: scheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.outlineVariant,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: scheme.primary,
        valueIndicatorTextStyle: TextStyle(color: scheme.onPrimary),
      ),
    );
  }
}

````

## lib/theme.dart

````dart
// Compatibility export. All theme definitions live in theme/app_theme.dart.
export 'theme/app_theme.dart';

````

## lib/utils/theme.dart

````dart
// Compatibility export. All theme definitions live in theme/app_theme.dart.
export '../theme/app_theme.dart';

````

## lib/widgets/common_widgets.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = AppColors.accentGradient,
  });
  @override
  Widget build(BuildContext context) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (b) => gradient.createShader(b),
    child: Text(text, style: style),
  );
}

class GlowCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.accent,
    this.borderRadius = 16,
    this.padding,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.08),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    ),
    padding: padding ?? const EdgeInsets.all(16),
    child: child,
  );
}

class FeatureInputField extends StatefulWidget {
  final String featureName, displayName, unit, icon, description;
  final double minValue, maxValue, currentValue;
  final ValueChanged<double> onChanged;
  final String? errorText;
  const FeatureInputField({
    super.key,
    required this.featureName,
    required this.displayName,
    required this.unit,
    required this.icon,
    required this.description,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.onChanged,
    this.errorText,
  });
  @override
  State<FeatureInputField> createState() => _FeatureInputFieldState();
}

class _FeatureInputFieldState extends State<FeatureInputField> {
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentValue.toStringAsFixed(1));
  }

  @override
  void didUpdateWidget(FeatureInputField old) {
    super.didUpdateWidget(old);
    if (!_editing && old.currentValue != widget.currentValue)
      _ctrl.text = widget.currentValue.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit(String v) {
    final parsed = double.tryParse(v);
    if (parsed != null)
      widget.onChanged(parsed.clamp(widget.minValue, widget.maxValue));
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (widget.currentValue - widget.minValue) /
        (widget.maxValue - widget.minValue);
    final bool hasError = widget.errorText != null;
    Color progressColor = hasError
        ? AppColors.error
        : (progress < 0.3
              ? AppColors.error
              : (progress < 0.6 ? AppColors.accent3 : AppColors.accent));

    return GlowCard(
      glowColor: hasError ? AppColors.error : progressColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _ctrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onTap: () => setState(() => _editing = true),
                  onSubmitted: _submit,
                  onEditingComplete: () => _submit(_ctrl.text),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: progressColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    suffixText: widget.unit,
                    suffixStyle: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
          // Error message — mirrors notebook "⚠  Please enter a valid number."
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.errorText!,
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.error),
              ),
            ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: progressColor,
              inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
              thumbColor: progressColor,
              overlayColor: progressColor.withOpacity(0.15),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: widget.currentValue.clamp(
                widget.minValue,
                widget.maxValue,
              ),
              min: widget.minValue,
              max: widget.maxValue,
              onChanged: (v) {
                widget.onChanged(v);
                if (!_editing) _ctrl.text = v.toStringAsFixed(1);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.minValue.toStringAsFixed(widget.minValue == widget.minValue.roundToDouble() ? 0 : 1)} ${widget.unit}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${widget.maxValue.toStringAsFixed(widget.maxValue == widget.maxValue.roundToDouble() ? 0 : 1)} ${widget.unit}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricChip extends StatelessWidget {
  final String label, value;
  final Color color;
  final String? subtitle;
  const MetricChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    ),
  );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    ),
  );
}

````

## lib/widgets/confidence_bar_disease.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Animated horizontal confidence bar for a single class.
class ConfidenceBar extends StatelessWidget {
  final String label;
  final double confidence; // 0.0 – 1.0
  final bool isTopPrediction;
  final int animationDelayMs;

  const ConfidenceBar({
    super.key,
    required this.label,
    required this.confidence,
    this.isTopPrediction = false,
    this.animationDelayMs = 0,
  });

  Color _barColor(BuildContext context) {
    if (isTopPrediction) {
      if (label == 'Healthy Leaf') return AppColors.success;
      if (label == 'Dried Leaf') return AppColors.warning;
      return AppColors.error;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: animationDelayMs),
          duration: 300.ms,
        ),
        SlideEffect(
          delay: Duration(milliseconds: animationDelayMs),
          duration: 300.ms,
          begin: const Offset(-0.1, 0),
          end: Offset.zero,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isTopPrediction) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _barColor(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isTopPrediction
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isTopPrediction
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(confidence * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isTopPrediction
                        ? _barColor(context)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Background track
                    Container(
                      width: constraints.maxWidth,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Filled bar
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: confidence),
                      duration: Duration(milliseconds: 600 + animationDelayMs),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return Container(
                          width: constraints.maxWidth * value,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTopPrediction
                                  ? [
                                      _barColor(context),
                                      _barColor(context).withOpacity(0.6),
                                    ]
                                  : [
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.5),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

````

## lib/widgets/confidence_bars.dart

````dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/inference_result.dart';
import '../theme/app_theme.dart';

/// Per-class confidence bar chart.
/// Mirrors the horizontal bar chart (axes[1]) in the notebook ONNX test cell.
/// Predicted class bar uses a contrasting colour; others use muted teal.
class ConfidenceBars extends StatelessWidget {
  final InferenceResult result;

  const ConfidenceBars({super.key, required this.result});

  Color _barColor(BuildContext context, String className, bool isPredicted) {
    if (isPredicted) {
      switch (className) {
        case 'Grade A Quality':
          return AppColors.accent;
        case 'Grade B Quality':
          return AppColors.success;
        case 'Grade C Quality':
          return AppColors.accent3;
        case 'Grade D Quality':
          return AppColors.warning;
        case 'Grade E Quality':
          return AppColors.error;
        default:
          return AppColors.accent;
      }
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final scores = result.classScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 16,
                color: AppColors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                'Class Probabilities',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...scores.map((entry) {
            final isPred = entry.key == result.predictedClass;
            final color = _barColor(context, entry.key, isPred);
            final pct = entry.value * 100;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Bar(
                label: _shortLabel(entry.key),
                value: entry.value,
                pct: pct,
                color: color,
                isPredicted: isPred,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _shortLabel(String name) {
    // "Grade A Quality" → "Grade A"
    final parts = name.split(' ');
    return parts.length >= 2 ? '${parts[0]} ${parts[1]}' : name;
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final double pct;
  final Color color;
  final bool isPredicted;

  const _Bar({
    required this.label,
    required this.value,
    required this.pct,
    required this.color,
    required this.isPredicted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isPredicted ? FontWeight.w700 : FontWeight.w400,
              color: isPredicted
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Bar
        Expanded(
          child: Stack(
            children: [
              // Background track
              Container(
                height: 18,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Fill
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 18,
                    width: constraints.maxWidth * value,
                    decoration: BoxDecoration(
                      color: color.withOpacity(isPredicted ? 0.85 : 0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Percentage
        SizedBox(
          width: 46,
          child: Text(
            '${pct.toStringAsFixed(1)}%',
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isPredicted ? FontWeight.w700 : FontWeight.w400,
              color: isPredicted
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // Predicted marker
        SizedBox(
          width: 20,
          child: isPredicted
              ? Icon(Icons.chevron_left_rounded, size: 16, color: color)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

````

## lib/widgets/detection_overlay.dart

````dart
import 'package:flutter/material.dart';
import '../models/detection_result.dart';

class DetectionOverlay extends StatelessWidget {
  final DetectionResult result;
  const DetectionOverlay({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _BoxPainter(
            result: result,
            colors: Theme.of(context).colorScheme,
          ),
        );
      },
    );
  }
}

class _BoxPainter extends CustomPainter {
  final DetectionResult result;

  final ColorScheme colors;

  _BoxPainter({required this.result, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / result.imageWidth;
    final scaleY = size.height / result.imageHeight;

    for (final det in result.detections) {
      final color = colors.error;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      final rect = Rect.fromLTWH(
        det.bbox.x1 * scaleX,
        det.bbox.y1 * scaleY,
        det.bbox.width * scaleX,
        det.bbox.height * scaleY,
      );
      canvas.drawRect(rect, paint);

      // Corner accents
      _drawCorner(canvas, rect, color);

      // Label
      final label =
          '${det.className}  ${(det.confidence * 100).toStringAsFixed(1)}%';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: colors.onError,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final bgTop = rect.top - tp.height - 8;
      final bgRect = Rect.fromLTWH(
        rect.left,
        bgTop < 0 ? rect.top + 2 : bgTop,
        tp.width + 12,
        tp.height + 6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
        Paint()..color = color,
      );
      tp.paint(canvas, Offset(bgRect.left + 6, bgRect.top + 3));
    }
  }

  void _drawCorner(Canvas canvas, Rect rect, Color color) {
    const len = 12.0;
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top-left
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(len, 0), p);
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, len), p);
    // Top-right
    canvas.drawLine(rect.topRight, rect.topRight + const Offset(-len, 0), p);
    canvas.drawLine(rect.topRight, rect.topRight + const Offset(0, len), p);
    // Bottom-left
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(len, 0), p);
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -len),
      p,
    );
    // Bottom-right
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-len, 0),
      p,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -len),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _BoxPainter old) =>
      old.result != result || old.colors != colors;
}

````

## lib/widgets/image_source_sheet.dart

````dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Bottom sheet that lets the user choose between Camera and Gallery.
class ImageSourceSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const ImageSourceSheet({
    super.key,
    required this.onCamera,
    required this.onGallery,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ImageSourceSheet(onCamera: onCamera, onGallery: onGallery),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Select Image Source',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how to provide the betel leaf image',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  subtitle: 'Take a photo',
                  color: AppColors.accent,
                  onTap: () {
                    Navigator.pop(context);
                    onCamera();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  subtitle: 'Pick from library',
                  color: AppColors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    onGallery();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

````

## lib/widgets/ood_badge.dart

````dart
import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../theme/app_theme.dart';

class OodBadge extends StatelessWidget {
  final DetectionResult result;
  const OodBadge({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isOod = result.isOod;
    final color = isOod ? AppColors.error : AppColors.success;
    final icon = isOod
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;
    final label = isOod ? 'OUT-OF-DISTRIBUTION' : 'IN-DISTRIBUTION';
    final sub = isOod
        ? 'Image may not belong to training distribution'
        : 'Image is within training distribution';

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Mahal.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              Text(
                result.mahalanobisDistance.toStringAsFixed(2),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '/ ${result.oodThreshold.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

````

## lib/widgets/ood_indicator.dart

````dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/inference_result.dart';
import '../theme/app_theme.dart';

/// Displays the Mahalanobis OOD score with a visual gauge.
/// Mirrors the score/threshold annotation in the notebook ONNX test cell.
///
/// Gauge colour:
///   Green  → well inside distribution (score ≪ threshold)
///   Amber  → approaching threshold   (score in [0.7, 1.0) × threshold)
///   Red    → OOD (score > threshold)
class OodIndicator extends StatelessWidget {
  final InferenceResult result;

  const OodIndicator({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result.oodScore;
    final threshold = result.threshold;
    final ratio = (score / threshold).clamp(0.0, 2.0); // normalise to threshold

    // Determine status colour
    final Color statusColor;
    final String statusText;
    final IconData statusIcon;

    if (result.isOod) {
      statusColor = AppColors.error;
      statusText = 'OOD — Rejected';
      statusIcon = Icons.dangerous_rounded;
    } else if (ratio >= 0.7) {
      statusColor = AppColors.warning;
      statusText = 'Near Boundary';
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusColor = AppColors.success;
      statusText = 'In-Distribution';
      statusIcon = Icons.check_circle_outline_rounded;
    }

    // Gauge fill: capped at 1.0 visually
    final gaugeFill = (ratio / 2.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 16, color: statusColor),
              const SizedBox(width: 8),
              Text(
                'OOD Detection',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Score gauge
          _Gauge(fill: gaugeFill, color: statusColor),
          const SizedBox(height: 10),

          // Score / threshold row
          Row(
            children: [
              _ScorePill(
                label: 'OOD Score',
                value: score.toStringAsFixed(1),
                color: statusColor,
              ),
              const SizedBox(width: 10),
              _ScorePill(
                label: 'Threshold (95th pct)',
                value: threshold.toStringAsFixed(1),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Explanation
          Text(
            'Mahalanobis distance measures how far the extracted features are '
            'from the training class centres. Score > threshold → OOD rejection.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Gauge extends StatelessWidget {
  final double fill; // 0.0 – 1.0
  final Color color;

  const _Gauge({required this.fill, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Threshold marker at 50% of gauge width
        const thresholdX = 0.5;

        return Stack(
          children: [
            // Track
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Fill
            Container(
              height: 10,
              width: w * fill,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Threshold tick
            Positioned(
              left: w * thresholdX - 1,
              top: 0,
              child: Container(
                width: 2,
                height: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            // Threshold label
            Positioned(
              left: w * thresholdX - 24,
              top: 12,
              child: Text(
                'threshold',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScorePill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color == Theme.of(context).colorScheme.onSurfaceVariant
                    ? Theme.of(context).colorScheme.onSurface
                    : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

````

## lib/widgets/result_card.dart

````dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/inference_result.dart';
import '../theme/app_theme.dart';

/// Displays the primary prediction result:
/// grade badge, predicted class, confidence pill, and OOD badge.
///
/// Visual language mirrors the notebook's matplotlib output (Cell 23):
/// blue = predicted, gray = others, red/green status line.
class ResultCard extends StatelessWidget {
  final InferenceResult result;

  const ResultCard({super.key, required this.result});

  Color _gradeColor(BuildContext context) {
    switch (result.gradeLabel) {
      case 'Grade A':
        return AppColors.accent;
      case 'Grade B':
        return AppColors.success;
      case 'Grade C':
        return AppColors.accent3;
      case 'Grade D':
        return AppColors.warning;
      case 'Grade E':
        return AppColors.error;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result.isOod) return _buildOodCard(context);
    return _buildGradeCard(context);
  }

  Widget _buildGradeCard(BuildContext context) {
    final color = _gradeColor(context);
    final grade = result.gradeLabel;
    final gradeChar = grade.length >= 7 ? grade[6] : '?'; // "Grade X" → 'X'

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Big grade badge
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: Text(
                  gradeChar,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.predictedClass,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _Pill(
                          label:
                              '${((result.confidence ?? 0) * 100).toStringAsFixed(1)}% confidence',
                          color: color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Checkmark
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Confidence meter
          _ConfidenceMeter(value: result.confidence ?? 0, color: color),
        ],
      ),
    );
  }

  Widget _buildOodCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withOpacity(0.4), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Out-of-Distribution',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Image rejected — not a recognisable betel leaf',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ConfidenceMeter extends StatelessWidget {
  final double value; // 0.0 – 1.0
  final Color color;

  const _ConfidenceMeter({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Model Confidence',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

````

## lib/widgets/result_card_disease.dart

````dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/inference_service_disease.dart';
import 'confidence_bar_disease.dart';

class ResultCard extends StatelessWidget {
  final PredictionResult result;

  const ResultCard({super.key, required this.result});

  // ── Disease metadata matching the notebook's CLASS_NAMES ──
  static const Map<String, _DiseaseInfo> _diseaseInfo = {
    'Bacterial Leaf Disease': _DiseaseInfo(
      icon: '🦠',
      description:
          'Caused by bacterial pathogens. Look for water-soaked lesions, yellowing, and wilting. Treat with copper-based bactericides and remove infected leaves.',
      severity: 'High',
      severityColor: AppColors.error,
    ),
    'Dried Leaf': _DiseaseInfo(
      icon: '🍂',
      description:
          'Leaf desiccation due to water stress, nutrient deficiency, or environmental conditions. Improve irrigation and check soil moisture.',
      severity: 'Medium',
      severityColor: AppColors.warning,
    ),
    'Fungal Brown Spot Disease': _DiseaseInfo(
      icon: '🔴',
      description:
          'Caused by fungal infection. Visible as brown circular spots with yellow halos. Apply fungicide and improve air circulation.',
      severity: 'High',
      severityColor: AppColors.error,
    ),
    'Healthy Leaf': _DiseaseInfo(
      icon: '✅',
      description:
          'No disease detected. The leaf appears healthy with good coloration and texture. Continue regular care and monitoring.',
      severity: 'None',
      severityColor: AppColors.success,
    ),
    'OOD — Rejected': _DiseaseInfo(
      icon: '🚨',
      description:
          'The image does not resemble a betel leaf based on the model\'s distribution. Please use a clear, close-up photo of a betel leaf.',
      severity: 'N/A',
      severityColor: AppColors.warning,
    ),
  };

  Color get _statusColor {
    if (result.isOod) return AppColors.warning;
    if (result.predictedClass == 'Healthy Leaf') return AppColors.success;
    if (result.predictedClass == 'Dried Leaf') return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final info =
        _diseaseInfo[result.predictedClass] ?? _diseaseInfo['OOD — Rejected']!;

    // Sort class scores descending
    final sortedScores = result.classScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Animate(
      effects: [
        FadeEffect(duration: 400.ms),
        SlideEffect(
          duration: 400.ms,
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Primary result banner ─────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _statusColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(info.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.predictedClass,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _statusColor,
                            ),
                          ),
                          if (!result.isOod)
                            Text(
                              'Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Severity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: info.severityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: info.severityColor.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        info.severity,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: info.severityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  info.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── OOD status row ────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  result.isOod
                      ? Icons.warning_amber_rounded
                      : Icons.verified_rounded,
                  size: 16,
                  color: result.isOod ? AppColors.warning : AppColors.success,
                ),
                const SizedBox(width: 8),
                Text(
                  result.isOod ? 'Out-of-Distribution' : 'In-Distribution',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: result.isOod ? AppColors.warning : AppColors.success,
                  ),
                ),
                const Spacer(),
                if (result.oodScore > 0) ...[
                  Text(
                    'OOD Score: ${result.oodScore.toStringAsFixed(1)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '/ ${result.oodThreshold.toStringAsFixed(1)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Per-class confidence bars ─────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Class Probabilities',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ...sortedScores.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  return ConfidenceBar(
                    label: e.key,
                    confidence: e.value,
                    isTopPrediction: i == 0 && !result.isOod,
                    animationDelayMs: i * 80,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiseaseInfo {
  final String icon;
  final String description;
  final String severity;
  final Color severityColor;

  const _DiseaseInfo({
    required this.icon,
    required this.description,
    required this.severity,
    required this.severityColor,
  });
}

````

## lib/widgets/result_panel.dart

````dart
import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../theme/app_theme.dart';

class ResultPanel extends StatelessWidget {
  final DetectionResult result;
  const ResultPanel({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.finalLabel != null) _buildFinalPrediction(context),
          const SizedBox(height: 16),
          // Detection count header
          Row(
            children: [
              Text(
                'Detections',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${result.detections.length}',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppColors.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (result.detections.isEmpty)
            _buildNoDetections(context)
          else
            ...result.detections.asMap().entries.map(
              (e) => _buildDetectionCard(context, e.key + 1, e.value),
            ),
        ],
      ),
    );
  }

  Widget _buildNoDetections(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No insects detected above confidence threshold.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPrediction(BuildContext context) {
    final label = result.finalLabel!;
    final conf = result.finalConfidence ?? 0;
    final count = result.finalDetCount;
    final color = Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.18), color.withOpacity(0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.verified_rounded, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FINAL PREDICTION',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$count detection${count > 1 ? 's' : ''}  •  '
                  'avg conf ${(conf * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Confidence ring
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: conf,
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 4,
                ),
                Text(
                  '${(conf * 100).toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCard(BuildContext context, int index, Detection det) {
    final color = Theme.of(context).colorScheme.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  det.className,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'BBox  [${det.bbox.x1.toStringAsFixed(0)}, '
                  '${det.bbox.y1.toStringAsFixed(0)}, '
                  '${det.bbox.x2.toStringAsFixed(0)}, '
                  '${det.bbox.y2.toStringAsFixed(0)}]',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(det.confidence * 100).toStringAsFixed(1)}%',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  value: det.confidence,
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

````

## lib/widgets/source_button.dart

````dart
import 'package:flutter/material.dart';

class SourceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool compact;

  const SourceButton({
    super.key,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: compact ? 50 : 70,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: compact ? 20 : 24,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

````
