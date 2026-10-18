# Betel App (Smart Betel Cultivation Assistant)

A comprehensive Flutter application designed to assist betel farmers and agricultural researchers with AI-driven cultivation insights. The app runs offline inference via bundled ONNX models using the `onnxruntime` package.

---

## Features

| Feature | Model & Architecture | Inputs | Outputs & Capabilities |
| :--- | :--- | :--- | :--- |
| **Yield Prediction** | XGBoost (ONNX) | 8 environmental & nutrient parameters | Predicted yield (kg/ha), feature importance, optimal condition advice |
| **Leaf Quality Grading** | EfficientNetB0 (ONNX) | Leaf photo (Camera / Gallery) | 5 Quality Grades (A–E) + Mahalanobis Out-of-Distribution (OOD) check |
| **Disease Classification** | EfficientNetB0 (ONNX) | Leaf photo (Camera / Gallery) | 4-class classification (Bacterial, Fungal Brown Spot, Dried, Healthy) + OOD scoring |
| **Insect Detection** | YOLOv8 (ONNX) | Leaf/plant photo (Camera / Gallery) | Bounding box overlays, pest count, classification, and OOD detection |

---

## Prerequisites & Installation

### 1. Install Flutter SDK

If you are using **`mise`** (recommended on this system):
```bash
# Install and set Flutter globally
mise use -g flutter@3.47.7

# Verify the environment
flutter doctor
```

Alternatively, install via git:
```bash
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:$HOME/flutter/bin"
```

### 2. Choose a Target Device

Because the application relies on **Camera**, **Image Picker**, and **ONNX Runtime (`onnxruntime`)**:

* **Physical Android Device (Recommended)**:
  * Enable **Developer Options** and **USB Debugging** on your phone.
  * Connect your device via USB and allow access.
  * Verify detection with `flutter devices`.
* **Android Emulator**:
  * Launch an AVD via Android Studio's Virtual Device Manager.
* **Linux Desktop**:
  * Requires native development packages (`sudo pacman -S cmake ninja clang pkgconf gtk3`).
  * Best for testing UI and Yield Prediction without physical cameras.

---

## How to Test & Run

### Running from the Command Line

```bash
# 1. Navigate to the project root
cd /home/sandeepa/Projects/betel_app

# 2. Fetch project dependencies
flutter pub get

# 3. Check connected devices
flutter devices

# 4. Launch the application
flutter run
```

If multiple devices are connected, specify the target:
```bash
flutter run -d <device-id>
```

### Running from VS Code

1. Open the project folder in VS Code:
   ```bash
   code /home/sandeepa/Projects/betel_app
   ```
2. Ensure the **Flutter** and **Dart** extensions are installed.
3. Select your target device from the bottom-right status bar.
4. Press **`F5`** (or navigate to **Run -> Start Debugging**).

---

## Testing Application Features

* **Yield Prediction**: Navigate to *Yield Prediction*, adjust sliders/numerical inputs (Temperature, Humidity, Soil Moisture, N-P-K levels, pH), and tap **Predict Yield**.
* **Quality Grading**: Select *Quality Grading*, provide an image via Camera or Gallery, and verify grade badge (A–E), confidence metrics, and OOD detection.
* **Disease Classification**: Select *Disease Classification*, provide a photo, and observe per-class probabilities, severity diagnosis, and treatment recommendations.
* **Insect Detection**: Select *Insect Detection*, submit a leaf photo, and inspect the real-time YOLOv8 bounding boxes and detection tallies.

---

## Project Structure

```
lib/
├── main.dart              # App entry point, light theme configuration
├── screens/               # Feature screens (Home, Yield, Quality, Disease, Insect, Results)
├── services/              # ONNX model inference pipelines, preprocessing, OOD scoring
├── models/                # Data structures, feature engineering, and result definitions
├── widgets/               # Reusable UI widgets (cards, meters, overlays, buttons)
└── theme/
    └── app_theme.dart     # Material 3 light theme (AppTheme.light) and AppColors
assets/
└── models/                # Bundled ONNX models, label mappings, and OOD configuration files
```

---

## Code Quality & Verification

Run static analysis and tests:
```bash
flutter analyze
flutter test
```
