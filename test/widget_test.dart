import 'package:flutter_test/flutter_test.dart';
import 'package:service_platform/core/validators/app_validators.dart';

void main() {
  group('AppValidators Unit Tests', () {
    test('Name validator requires value and min length', () {
      expect(AppValidators.nameValidator(null), 'Please enter Full Name.');
      expect(AppValidators.nameValidator('  '), 'Please enter Full Name.');
      expect(AppValidators.nameValidator('A'), 'Full Name must be at least 2 characters long.');
      expect(AppValidators.nameValidator('John Doe'), null);
    });

    test('Email validator validates email format correctly', () {
      expect(AppValidators.emailValidator(null), 'Please enter an email address.');
      expect(AppValidators.emailValidator('invalid-email'), 'Please enter a valid email address (e.g. name@domain.com).');
      expect(AppValidators.emailValidator('user@domain.com'), null);
    });

    test('Phone validator validates phone number format', () {
      expect(AppValidators.phoneValidator(null), 'Please enter a phone number.');
      expect(AppValidators.phoneValidator('123'), 'Please enter a valid phone number (8 to 15 digits).');
      expect(AppValidators.phoneValidator('+971 50 123 4567'), null);
    });

    test('Price validator enforces positive numbers', () {
      expect(AppValidators.priceValidator(null), 'Please enter a price.');
      expect(AppValidators.priceValidator('abc'), 'Please enter a valid positive price amount.');
      expect(AppValidators.priceValidator('-10'), 'Please enter a valid positive price amount.');
      expect(AppValidators.priceValidator('250.00'), null);
    });

    test('URL validator accepts valid URLs or empty string optional input', () {
      expect(AppValidators.urlValidator('https://example.com'), null);
      expect(AppValidators.urlValidator('invalid_url'), 'Please enter a valid URL (e.g., https://example.com).');
    });
  });
}
