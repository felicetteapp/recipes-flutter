class FRValidations {
  static String? validateEmail(
    String? value, {
    bool isRequired = true,
    String? isRequiredErrorMessage,
  }) {
    if (isRequired && (value == null || value.isEmpty)) {
      return isRequiredErrorMessage ?? 'required';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (value == null || value.isEmpty) {
      return 'invalid email';
    }

    if (!emailRegex.hasMatch(value)) {
      return 'invalid email';
    }
    return null;
  }
}
