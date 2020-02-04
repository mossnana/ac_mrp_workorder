import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_user_response.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final OdooUser _odooUser;

  AuthenticationAuthenticated({
    @required OdooUser odooUser,
  }): _odooUser = odooUser;
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
