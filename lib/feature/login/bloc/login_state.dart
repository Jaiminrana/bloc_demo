class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final String? user;

  LoginState({this.isLoading = false, this.errorMessage, this.user});

  LoginState copyWith({required bool isLoading, String? error, String? user}) {
    return LoginState(
      isLoading: isLoading,
      errorMessage: error ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
