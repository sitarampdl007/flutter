enum AuthResultStatus {
  NOT_A_RIDER_USER,
  USER_DOESNOT_EXISTS,
  invalid_grant,
  UNDEFINED
}

class AuthException implements Exception {
  //returns us the status based on exception
  static AuthResultStatus handleException(errorMsg) {
    print(errorMsg);
    AuthResultStatus status;
    switch (errorMsg) {
      case "NOT_A_RIDER_USER":
        status = AuthResultStatus.NOT_A_RIDER_USER;
        break;
      case "USER_DOESNOT_EXISTS":
        status = AuthResultStatus.USER_DOESNOT_EXISTS;
        break;
      case "invalid_grant":
        status = AuthResultStatus.invalid_grant;
        break;
      default:
        status = AuthResultStatus.UNDEFINED;
    }
    return status;
  }

  //returns us the error message based on the status
  static String generatedExceptionMessage(status) {
    String errorMessage;
    switch (status) {
      case AuthResultStatus.NOT_A_RIDER_USER:
        errorMessage = "You are not associated as Rider";
        break;
      case AuthResultStatus.USER_DOESNOT_EXISTS:
        errorMessage = "User with this id doesn't exist.";
        break;
      case AuthResultStatus.invalid_grant:
        errorMessage = "Invalid user credentials.";
        break;
      default:
        errorMessage = "An Unknown Error occurred. Try again!";
    }
    return errorMessage;
  }
}
