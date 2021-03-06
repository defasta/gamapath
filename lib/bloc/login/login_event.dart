part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent{
  final String email;
  final String password;
  const LoginButtonPressed({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString () =>
      'LoginButtonPressed { email: $email, password: $password }';
}

class RegisterButtonPressed extends LoginEvent{
  const RegisterButtonPressed();
  @override
  List<Object> get props => [];
  @override
  String toString () =>
      'RegisterButtonPressed { }';
}