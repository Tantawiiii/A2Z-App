
abstract class PasswordResetEvent {}

class PasswordResetRequested extends PasswordResetEvent {
  final String loginOrEmail;

  PasswordResetRequested(this.loginOrEmail);
}