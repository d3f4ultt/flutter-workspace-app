/// Form validation utilities
class Validators {
  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Wallet address validation (Ethereum)
  static String? ethereumAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wallet address is required';
    }
    
    final addressRegex = RegExp(r'^0x[a-fA-F0-9]{40}$');
    
    if (!addressRegex.hasMatch(value)) {
      return 'Please enter a valid Ethereum address';
    }
    
    return null;
  }

  /// Solana address validation
  static String? solanaAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wallet address is required';
    }
    
    if (value.length < 32 || value.length > 44) {
      return 'Please enter a valid Solana address';
    }
    
    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  /// Numeric validation
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  /// Minimum value validation
  static String? minValue(String? value, double min) {
    final numericError = numeric(value);
    if (numericError != null) return numericError;
    
    final numValue = double.parse(value!);
    if (numValue < min) {
      return 'Value must be at least $min';
    }
    
    return null;
  }

  /// Maximum value validation
  static String? maxValue(String? value, double max) {
    final numericError = numeric(value);
    if (numericError != null) return numericError;
    
    final numValue = double.parse(value!);
    if (numValue > max) {
      return 'Value must be at most $max';
    }
    
    return null;
  }
}
