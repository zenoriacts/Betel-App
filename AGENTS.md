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
