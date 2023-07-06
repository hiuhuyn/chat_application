import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  String displayName;
  String email;
  String password;
  SignUpState(
      {required this.email, required this.password, required this.displayName});
  @override
  // TODO: implement props
  List<Object?> get props => [displayName, email, password];
}

class SignUpStateInit extends SignUpState {
  SignUpStateInit() : super(email: "", password: "", displayName: "");
}
