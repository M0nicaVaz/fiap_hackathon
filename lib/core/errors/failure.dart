sealed class Failure {
  const Failure({this.message, this.cause});

  final String? message;
  final Object? cause;
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.message, super.cause});
}

final class AuthFailure extends Failure {
  const AuthFailure({super.message, super.cause});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message, super.cause});
}

final class PermissionFailure extends Failure {
  const PermissionFailure({super.message, super.cause});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message, super.cause});
}
