import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final OdooUser _odooUser;
  final OdooClient _userRepository;

  AuthenticationAuthenticated({
    @required OdooUser odooUser,
    @required OdooClient odooClient,
  }): _odooUser = odooUser, _userRepository = odooClient;
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
