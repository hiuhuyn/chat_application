// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Member {
  String? userId;

  int? submitAt;

  Member({this.userId, this.submitAt});

  @override
  String toString() => 'Member(userId: $userId, submitAt: $submitAt)';
}
