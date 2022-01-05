import 'package:dio/dio.dart';

class ErrorInterceptors extends Interceptor {
  final Dio dio;

  ErrorInterceptors(this.dio);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);

      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 460:
            throw EmailExistException(err.requestOptions);
          case 461:
            throw EmailNotExistException(err.requestOptions);
          case 462:
            throw EmailNotConfirmedException(err.requestOptions);
          case 463:
            throw PasswordNotCorrectException(err.requestOptions);
          case 465:
            throw GuestEmailNotExistException(err.requestOptions);
          case 499:
            throw UnauthorizedException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }
}


class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Неверно указаны параметры';
  }
}

class EmailExistException extends DioError {
  EmailExistException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Такой email уже существует';
  }
}

class EmailNotExistException extends DioError {
  EmailNotExistException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Неверно указан email';
  }
}

class EmailNotConfirmedException extends DioError {
  EmailNotConfirmedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Email не подтвержден';
  }
}

class PasswordNotCorrectException extends DioError {
  PasswordNotCorrectException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Неверно указан пароль';
  }
}

class GuestEmailNotExistException extends DioError {
  GuestEmailNotExistException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Email приглашенного указан неверно';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Ошибка сервера повторите позже';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Истек токен доступа';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Отсутствует подключение к интернету';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Время запроса истекло';
  }
}