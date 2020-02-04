import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:odoo_api/odoo_api.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final OdooClient userRepository;

  const LoggedIn({
    @required this.userRepository,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent {}
