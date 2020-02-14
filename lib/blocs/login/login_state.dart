import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:odoo_api/odoo_api.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  OdooClient odooClient;

  LoginInitial({this.odooClient});

  Future<dynamic> getDatabases() async {
    return await odooClient.getDatabases();
  }
}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
