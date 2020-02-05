import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';

abstract class FetchDataState extends Equatable {
  @override
  List<Object> get props => [];
}

// Work Order
class FetchWorkOrderInit extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Begin Fetching Work Orders Data ...';
}

class FetchWorkOrderLoading extends FetchDataState {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loading Work Orders Data ...';
}

class FetchWorkOrderSuccess extends FetchDataState {
  final OdooClient _odooClient;

  FetchWorkOrderSuccess({
    @required OdooClient odooClient
  }): _odooClient = odooClient;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Fetch Work Orders Data Success ...';

  Stream<dynamic> readAll() async* {
    var result = await _odooClient.searchRead('mrp.workorder', [], ['id','name'], limit: 1);
    if (!result.hasError()) {
      var response = result.getResult();
      var data = json.encode(response['records']);
      var decoded = json.decode(data);
      yield decoded;
    } else {
      print("Can't Streaming data from server.");
    }
  }
}

class FetchWorkOrderFailed extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Fetch Work Orders Data Failed ...';
}

// User
class FetchUserInit extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Begin Fetching User Data ...';
}

class FetchUserLoading extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loading User Data ...';
}

class FetchUserSuccess extends FetchDataState {
  final OdooUser _odooUser;

  FetchUserSuccess({
    @required OdooUser odooUser
  }): _odooUser = odooUser;

  @override
  List<Object> get props => [];

  Stream<dynamic> info() async* {
    var odooUserResponse = await _odooUser;
    yield {
      'uid': odooUserResponse.uid,
      'name': odooUserResponse.name,
      'sessionId': odooUserResponse.sessionId,
      'username': odooUserResponse.username,
      'companyId': odooUserResponse.companyId,
      'database': odooUserResponse.database,
    };
  }

  @override
  String toString() => 'Fetch User Data Success';
}

class FetchUserFailed extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Fetch User Data Failed';
}