// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  String email = "";
  String password = "";
  LoginState({required this.email, required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [email, password];

  LoginState copyWith({
    String? email,
    String? password,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoginInitState extends LoginState {
  LoginInitState() : super(email: "", password: "");
}
