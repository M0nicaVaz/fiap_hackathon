import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';

abstract final class FailureMapper {
  static Failure fromException(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) {
      return error;
    }

    if (error is FirebaseAuthException) {
      return AuthFailure(message: error.message, cause: error);
    }

    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return PermissionFailure(message: error.message, cause: error);
        case 'not-found':
          return NotFoundFailure(message: error.message, cause: error);
        default:
          return UnknownFailure(message: error.message, cause: error);
      }
    }

    return UnknownFailure(message: error.toString(), cause: error);
  }

  static String toUserMessage(Failure failure) {
    return switch (failure) {
      ValidationFailure() =>
        failure.message ??
            'Dados invalidos. Revise os campos e tente novamente.',
      AuthFailure() =>
        failure.message ?? 'Falha de autenticacao. Tente novamente.',
      PermissionFailure() =>
        failure.message ?? 'Voce nao tem permissao para executar esta acao.',
      NotFoundFailure() =>
        failure.message ?? 'Nao foi possivel encontrar os dados solicitados.',
      UnknownFailure() =>
        failure.message ?? 'Ocorreu um erro inesperado. Tente novamente.',
    };
  }
}
