class SearchValidator {
  static String? validateCityName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a city name';
    }

    // kiểm tra ký tự đặc biệt
    final RegExp specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (specialChars.hasMatch(value)) {
      return 'City name cannot contain special characters';
    }

    // kiểm tra số
    final RegExp numbers = RegExp(r'[0-9]');
    if (numbers.hasMatch(value)) {
      return 'City name cannot contain numbers';
    }

    // kiểm tra ký tự tiếng việt
    final RegExp vietnameseChars = RegExp(
        r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]');
    if (vietnameseChars.hasMatch(value.toLowerCase())) {
      return 'Please use English characters only';
    }

    return null;
  }
}
