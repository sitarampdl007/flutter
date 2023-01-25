import 'package:email_validator/email_validator.dart';

class Validators {
  //----------------- VALIDATORS -----------------------------

  static bool validPassStruct(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please provide correct email address';
    }
    return null;
  }

  static String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'The password must be 8 characters or more.';
    }
    // if (!Validators.validPassStruct(value)) {
    //   return 'Must have upper and lower case, digit and special character';
    // }
    return null;
  }

  static String validateReenterPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'The password must be 8 characters or more.';
    }
    if (value != password) {
      return 'The password is not same as above.';
    }
    return null;
  }

  static String validateNote(String value) {
    if (value.isEmpty) {
      return 'Please specify a note';
    }
    if (value.length < 10) {
      return 'The note must be clear and precise';
    }
    return null;
  }

  static String validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 8) {
      return 'Please specify full name';
    }
    return null;
  }

  static String validateIssue(String value) {
    if (value == null || value.isEmpty) {
      return 'Please select your issue';
    }
    return null;
  }
}
