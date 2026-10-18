import 'package:flutter_test/flutter_test.dart';
import 'package:betel_app/utils/validators.dart';

void main() {
  group('FormValidators Unit Tests', () {
    // ── Temperature (15 – 40 °C) ───────────────────────────────────────────
    group('Temperature Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validateTemperature(''), FormValidators.requiredMsg);
        expect(FormValidators.validateTemperature(null), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validateTemperature('abc'), FormValidators.numberMsg);
        expect(FormValidators.validateTemperature('twenty'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validateTemperature('14.9'), FormValidators.tempMsg);
        expect(FormValidators.validateTemperature('0'), FormValidators.tempMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validateTemperature('40.1'), FormValidators.tempMsg);
        expect(FormValidators.validateTemperature('55'), FormValidators.tempMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validateTemperature('15.0'), isNull);
        expect(FormValidators.validateTemperature('28.5'), isNull);
        expect(FormValidators.validateTemperature('40.0'), isNull);
      });
    });

    // ── Humidity (30 – 100 %) ──────────────────────────────────────────────
    group('Humidity Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validateHumidity(''), FormValidators.requiredMsg);
        expect(FormValidators.validateHumidity(null), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validateHumidity('xyz'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validateHumidity('29.9'), FormValidators.humidityMsg);
        expect(FormValidators.validateHumidity('10'), FormValidators.humidityMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validateHumidity('100.1'), FormValidators.humidityMsg);
        expect(FormValidators.validateHumidity('120'), FormValidators.humidityMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validateHumidity('30'), isNull);
        expect(FormValidators.validateHumidity('75'), isNull);
        expect(FormValidators.validateHumidity('100'), isNull);
      });
    });

    // ── Soil Moisture (0 – 100 %) ──────────────────────────────────────────
    group('Soil Moisture Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validateSoilMoisture(''), FormValidators.requiredMsg);
        expect(FormValidators.validateSoilMoisture(null), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validateSoilMoisture('bad'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validateSoilMoisture('-1'), FormValidators.soilMoistureMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validateSoilMoisture('100.5'), FormValidators.soilMoistureMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validateSoilMoisture('0'), isNull);
        expect(FormValidators.validateSoilMoisture('60.0'), isNull);
        expect(FormValidators.validateSoilMoisture('100'), isNull);
      });
    });

    // ── Soil pH (4.0 – 8.5) ────────────────────────────────────────────────
    group('Soil pH Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validateSoilPh(''), FormValidators.requiredMsg);
        expect(FormValidators.validateSoilPh(null), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validateSoilPh('ph-value'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validateSoilPh('3.9'), FormValidators.soilPhMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validateSoilPh('8.6'), FormValidators.soilPhMsg);
        expect(FormValidators.validateSoilPh('10'), FormValidators.soilPhMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validateSoilPh('4.0'), isNull);
        expect(FormValidators.validateSoilPh('6.5'), isNull);
        expect(FormValidators.validateSoilPh('8.5'), isNull);
      });
    });

    // ── Nitrogen (0 – 500) ─────────────────────────────────────────────────
    group('Nitrogen Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validateNitrogen(''), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validateNitrogen('n/a'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validateNitrogen('-5'), FormValidators.npkMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validateNitrogen('501'), FormValidators.npkMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validateNitrogen('0'), isNull);
        expect(FormValidators.validateNitrogen('135.0'), isNull);
        expect(FormValidators.validateNitrogen('500'), isNull);
      });
    });

    // ── Phosphorus (0 – 500) ───────────────────────────────────────────────
    group('Phosphorus Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validatePhosphorus(''), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validatePhosphorus('invalid'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validatePhosphorus('-1'), FormValidators.npkMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validatePhosphorus('550'), FormValidators.npkMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validatePhosphorus('45.0'), isNull);
        expect(FormValidators.validatePhosphorus('500'), isNull);
      });
    });

    // ── Potassium (0 – 500) ────────────────────────────────────────────────
    group('Potassium Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validatePotassium(''), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validatePotassium('none'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validatePotassium('-2'), FormValidators.npkMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validatePotassium('600'), FormValidators.npkMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validatePotassium('100.0'), isNull);
        expect(FormValidators.validatePotassium('500'), isNull);
      });
    });

    // ── Rainfall (0 – 500 mm) ──────────────────────────────────────────────
    group('Rainfall Validator', () {
      test('empty value returns required message', () {
        expect(FormValidators.validateRainfall(''), FormValidators.requiredMsg);
      });

      test('non-number returns number message', () {
        expect(FormValidators.validateRainfall('rain'), FormValidators.numberMsg);
      });

      test('value below minimum returns range message', () {
        expect(FormValidators.validateRainfall('-10'), FormValidators.rainfallMsg);
      });

      test('value above maximum returns range message', () {
        expect(FormValidators.validateRainfall('501'), FormValidators.rainfallMsg);
      });

      test('valid value returns null', () {
        expect(FormValidators.validateRainfall('100.0'), isNull);
        expect(FormValidators.validateRainfall('500'), isNull);
      });
    });

    // ── Generic Feature Dispatcher ─────────────────────────────────────────
    group('Generic Feature Validator', () {
      test('routes correctly for all base features', () {
        expect(FormValidators.validateFeature('Temperature', '55'), FormValidators.tempMsg);
        expect(FormValidators.validateFeature('Humidity', '20'), FormValidators.humidityMsg);
        expect(FormValidators.validateFeature('Soil_pH', '10'), FormValidators.soilPhMsg);
        expect(FormValidators.validateFeature('N', '600'), FormValidators.npkMsg);
        expect(FormValidators.validateFeature('Soil_Moisture', '50'), isNull);
      });
    });
  });
}
