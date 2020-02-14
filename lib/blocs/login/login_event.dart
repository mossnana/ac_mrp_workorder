import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  String username;
  String password;
  final String db;
  final String employeeCode;

  LoginButtonPressed({
    this.username,
    this.password,
    @required this.db,
    @required this.employeeCode,
  });

  @override
  List<Object> get props => [username, password, db];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password, database: $db }';
}
