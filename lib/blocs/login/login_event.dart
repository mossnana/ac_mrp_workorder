import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String db;

  const LoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.db,
  });

  @override
  List<Object> get props => [username, password, db];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password, database: $db }';
}
