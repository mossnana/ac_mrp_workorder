import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_event.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';

class FetchUserBloc extends Bloc<FetchDataEvent, FetchDataState> {
  final OdooUser _odooUser;

  FetchUserBloc({
    @required odooUser
  }): _odooUser = odooUser;

  @override
  FetchDataState get initialState => FetchUserInit();

  @override
  Stream<FetchDataState> mapEventToState(FetchDataEvent event) async* {
    if(event is FetchUserStarted) {
      yield FetchUserLoading();
      final result = _odooUser.sessionId != null;
      yield result ? FetchUserSuccess(odooUser: _odooUser) : FetchUserFailed();
    } else if(event is FetchUserStarted) {
      yield FetchUserSuccess(odooUser: _odooUser);
    } else {
      yield FetchUserFailed();
    }
  }
}

class FetchWorkOrderBloc extends Bloc<FetchDataEvent, FetchDataState> {
  final OdooClient _odooClient;

  FetchWorkOrderBloc({
    @required odooClient
  }): _odooClient = odooClient;

  @override
  FetchDataState get initialState => FetchWorkOrderInit();

  @override
  Stream<FetchDataState> mapEventToState(FetchDataEvent event) async* {
    if(event is FetchWorkOrderStarted) {
      yield FetchWorkOrderLoading();
      if(_odooClient.getSessionInfo() != null) {
        yield FetchWorkOrderSuccess(odooClient: _odooClient);
      } else {
        yield FetchWorkOrderFailed();
      }
    }
  }
}