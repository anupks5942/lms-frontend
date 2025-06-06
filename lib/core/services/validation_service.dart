class ValidationService {
  static String? requiredValidation(dynamic value, {String? message}) {
    if (value == null || value.toString().trim().isEmpty) {
      return message ?? 'Required*';
    }
    return null;
  }

  static String? dobValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value.trim())) {
      return 'Enter date in YYYY-MM-DD format';
    }

    try {
      final dateParts = value.trim().split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final currentYear = DateTime.now().year;
      if (year < 1900 || year > currentYear) {
        return 'Year must be between 1900 and $currentYear';
      }

      if (month < 1 || month > 12) {
        return 'Month must be between 1 and 12';
      }

      final daysInMonth = _daysInMonth(month, year);
      if (day < 1 || day > daysInMonth) {
        return 'Day must be between 1 and $daysInMonth for the given month';
      }

      return null;
    } catch (_) {
      return 'Invalid date format';
    }
  }

  static int _daysInMonth(int month, int year) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        return 29;
      }
      return 28;
    }
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  static String? mobileNumberValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final trimmedValue = value.trim();
    final numberRegex = RegExp(r'^\d{10}$');
    if (!numberRegex.hasMatch(trimmedValue)) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  static String? sameNumberValidation(
    String? value,
    String? originalNumber, {
    String? message,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final trimmedValue = value.trim();
    final numberRegex = RegExp(r'^\d{10}$');
    if (!numberRegex.hasMatch(trimmedValue)) {
      return 'Enter a valid 10-digit mobile number';
    }

    if (trimmedValue != originalNumber?.trim()) {
      return 'New number must match the original number';
    }

    return null;
  }

  static String? passwordValidation(
    String? value, {
    String? message,
    bool isLogin = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!isLogin) {
      final complexityRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$');
      if (!complexityRegex.hasMatch(trimmedValue)) {
        return 'Password must contain uppercase, lowercase, and a number';
      }
    }

    return null;
  }

  static String? confirmPasswordValidation(
    String? confirmPassword,
    String? password, {
    String? message,
  }) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final trimmedConfirm = confirmPassword.trim();
    if (trimmedConfirm.length < 6) {
      return 'Confirm password must be at least 6 characters';
    }

    if (trimmedConfirm != password?.trim()) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? nameValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final nameRegex = RegExp(r"^[A-Za-z\s'-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, or apostrophes';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  static String? emailValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? requiredNumberValidation(
    String? value, {
    double? maximumNumber,
    double? minimumNumber,
    String? message,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final numberRegex = RegExp(r'^-?\d+$');
    if (!numberRegex.hasMatch(value.trim())) {
      return 'Enter a valid integer';
    }

    try {
      final number = double.parse(value.trim());

      if (maximumNumber != null && number > maximumNumber) {
        return 'Number cannot be greater than ${maximumNumber.toStringAsFixed(0)}';
      }

      if (minimumNumber != null && number < minimumNumber) {
        return 'Number cannot be less than ${minimumNumber.toStringAsFixed(0)}';
      }

      return null;
    } catch (_) {
      return 'Invalid number format';
    }
  }

  static String? courseValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    if (value.trim().length > 100) {
      return 'Title or Description cannot exceed 100 characters';
    }

    return null;
  }
}
