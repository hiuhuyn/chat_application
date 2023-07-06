// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../models/user.dart';

class HomeState extends Equatable {
  int index;
  UserModel? user;
  HomeState({this.index = 0, this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [index, user];

  HomeState copyWith({
    int? index,
    UserModel? user,
  }) {
    return HomeState(
      index: index ?? this.index,
      user: user ?? this.user,
    );
  }
}
