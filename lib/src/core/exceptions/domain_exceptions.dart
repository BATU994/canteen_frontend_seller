sealed class DomainException implements Exception {
  DomainException({required this.message, this.stackTrace});
  String message;
  StackTrace? stackTrace;

  @override
  String toString() {
    String message = this.message;
    return 'Exception: $message';
  }
}

class UnknownException extends DomainException {
  UnknownException({String? message, super.stackTrace})
    : super(message: message ?? 'Unknown Exception');
}

class BadRequest extends DomainException {
  BadRequest({super.stackTrace}) : super(message: 'Bad Request');
}

class UnknownError extends DomainException {
  UnknownError() : super(message: 'Unknown Error');
}

class NoInternetConnectionException extends DomainException {
  NoInternetConnectionException()
    : super(message: 'No Internet Connection Exception');
}

class NetworkException extends DomainException {
  NetworkException({required super.message, super.stackTrace});
}

class AddressNotFoundException extends DomainException {
  AddressNotFoundException()
    : super(message: 'Incorrect address or does not exist in DB');
}

class IncorrectUsernameOrPassword extends DomainException {
  IncorrectUsernameOrPassword() : super(message: 'Incorrect email or password');
}

class EmailAlreadyTaken extends DomainException {
  EmailAlreadyTaken() : super(message: 'Email is already taken');
}

class NotEnoughSupply extends DomainException {
  NotEnoughSupply({required super.message});
}

class OrderNotFound extends DomainException {
  OrderNotFound() : super(message: 'Order is not found');
}
