sealed class LoginEvent {}

final class LoginSubmitted extends LoginEvent {
  final String email, password;

  LoginSubmitted({required this.email, required this.password});
}
