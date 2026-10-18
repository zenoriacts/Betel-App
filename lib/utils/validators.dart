/// Yield form validators and range rules.
/// Defines all required input boundaries and validation messages for Betel cultivation.
class FormValidators {
  // ── Range Configuration ──────────────────────────────────────────────────
  static const double tempMin = 15.0;
  static const double tempMax = 40.0;

  static const double humidityMin = 30.0;
  static const double humidityMax = 100.0;

  static const double soilMoistureMin = 0.0;
  static const double soilMoistureMax = 100.0;

  static const double soilPhMin = 4.0;
  static const double soilPhMax = 8.5;

  static const double npkMin = 0.0;
  static const double npkMax = 500.0;

  static const double rainfallMin = 0.0;
  static const double rainfallMax = 500.0;

  // ── Standard Validation Messages ─────────────────────────────────────────
  static const String requiredMsg = 'This field is required';
  static const String numberMsg = 'Enter a number';

  static const String tempMsg = 'Temperature must be between 15 and 40 °C';
  static const String humidityMsg = 'Humidity must be between 30 and 100%';
  static const String soilMoistureMsg =
      'Soil moisture must be between 0 and 100%';
  static const String soilPhMsg = 'pH must be between 4.0 and 8.5';
  static const String npkMsg = 'Value must be between 0 and 500';
  static const String rainfallMsg = 'Value must be between 0 and 500';

  // ── Field Validators ─────────────────────────────────────────────────────

  /// Validates Temperature (15 – 40 °C)
  static String? validateTemperature(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMsg;
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) return numberMsg;
    if (parsed < tempMin || parsed > tempMax) return tempMsg;
    return null;
  }

  /// Validates Humidity (30 – 100 %)
  static String? validateHumidity(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMsg;
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) return numberMsg;
    if (parsed < humidityMin || parsed > humidityMax) return humidityMsg;
    return null;
  }

  /// Validates Soil Moisture (0 – 100 %)
  static String? validateSoilMoisture(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMsg;
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) return numberMsg;
    if (parsed < soilMoistureMin || parsed > soilMoistureMax) {
      return soilMoistureMsg;
    }
    return null;
  }

  /// Validates Soil pH (4.0 – 8.5)
  static String? validateSoilPh(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMsg;
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) return numberMsg;
    if (parsed < soilPhMin || parsed > soilPhMax) return soilPhMsg;
    return null;
  }

  /// Validates Nitrogen (N) (0 – 500)
  static String? validateNitrogen(String? value) => _validateNpk(value);

  /// Validates Phosphorus (P) (0 – 500)
  static String? validatePhosphorus(String? value) => _validateNpk(value);

  /// Validates Potassium (K) (0 – 500)
  static String? validatePotassium(String? value) => _validateNpk(value);

  /// Validates Rainfall (0 – 500 mm)
  static String? validateRainfall(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMsg;
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) return numberMsg;
    if (parsed < rainfallMin || parsed > rainfallMax) return rainfallMsg;
    return null;
  }

  static String? _validateNpk(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMsg;
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) return numberMsg;
    if (parsed < npkMin || parsed > npkMax) return npkMsg;
    return null;
  }

  /// Generic validator by feature name
  static String? validateFeature(String featureName, String? value) {
    switch (featureName) {
      case 'Temperature':
        return validateTemperature(value);
      case 'Humidity':
        return validateHumidity(value);
      case 'Soil_Moisture':
        return validateSoilMoisture(value);
      case 'Soil_pH':
        return validateSoilPh(value);
      case 'N':
        return validateNitrogen(value);
      case 'P':
        return validatePhosphorus(value);
      case 'K':
        return validatePotassium(value);
      case 'Rainfall':
        return validateRainfall(value);
      default:
        if (value == null || value.trim().isEmpty) return requiredMsg;
        if (num.tryParse(value.trim()) == null) return numberMsg;
        return null;
    }
  }
}
