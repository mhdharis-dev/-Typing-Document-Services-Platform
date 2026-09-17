class AppValidators {
  AppValidators._();

  static String? requiredValidator(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? nameValidator(String? value, [String fieldName = 'Full Name']) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName.';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return '$fieldName must be at least 2 characters long.';
    }
    final nameRegExp = RegExp(r"^[a-zA-Z\s\-\.\']+$");
    if (!nameRegExp.hasMatch(trimmed)) {
      return '$fieldName contains invalid characters.';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address.';
    }
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address (e.g. name@domain.com).';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a phone number.';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleaned.length < 8 || cleaned.length > 15) {
      return 'Please enter a valid phone number (8 to 15 digits).';
    }
    final digitsOnly = RegExp(r'^\d+$');
    if (!digitsOnly.hasMatch(cleaned)) {
      return 'Phone number must contain only numeric digits.';
    }
    return null;
  }

  static String? urlValidator(String? value, [String fieldName = 'Website URL']) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional fields can be empty unless combined with required
    }
    final urlRegExp = RegExp(
        r'^(https?:\/\/)?([\w\d\-]+\.)+[\w\-]+(\/[\w\d\-\.\?\%&=]*)?$');
    if (!urlRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid URL (e.g., https://example.com).';
    }
    return null;
  }

  static String? priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a price.';
    }
    final doubleVal = double.tryParse(value.trim());
    if (doubleVal == null || doubleVal < 0) {
      return 'Please enter a valid positive price amount.';
    }
    return null;
  }

  static String? messageValidator(String? value, {int minLength = 10, int maxLength = 1000}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a message.';
    }
    final trimmed = value.trim();
    if (trimmed.length < minLength) {
      return 'Message must be at least $minLength characters long.';
    }
    if (trimmed.length > maxLength) {
      return 'Message cannot exceed $maxLength characters.';
    }
    return null;
  }

  static String? descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description.';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters.';
    }
    return null;
  }

  static String? integerValidator(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName.';
    }
    final intVal = int.tryParse(value.trim());
    if (intVal == null || intVal < 0) {
      return 'Please enter a valid positive number.';
    }
    return null;
  }
}
