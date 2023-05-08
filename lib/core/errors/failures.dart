import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.connectionTimeout:
        return ServerFailure('Connection Time Out with ApiServer');

      case DioErrorType.sendTimeout:
        return ServerFailure('Send Time Out with ApiServer');

      case DioErrorType.receiveTimeout:
        return ServerFailure('Receive Time Out with ApiServer');

      case DioErrorType.badCertificate:
        return ServerFailure('Connection Time Out with ApiServer');

      case DioErrorType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode, dioError.response!.data);

      case DioErrorType.cancel:
        return ServerFailure('cancel with ApiServer');

      case DioErrorType.connectionError:
        return ServerFailure('error connect with ApiServer');

      case DioErrorType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure('No Internet connection');
        }
        return ServerFailure('Unexpected Error, Please try again');
      default:
        return ServerFailure('opps There was an error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statesCode, dynamic response) {
    if (statesCode == 400 || statesCode == 401 || statesCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statesCode == 404) {
      return ServerFailure('Your request not found, Please try again later!');
    } else if (statesCode == 500) {
      return ServerFailure('Internal server error, Please try again later!');
    } else {
      return ServerFailure('opps There was an error, Please try again');
    }
  }
}
