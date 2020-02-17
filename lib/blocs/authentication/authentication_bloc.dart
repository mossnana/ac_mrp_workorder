import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

export 'authentication_event.dart';
export 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final OdooClient userRepository;

  AuthenticationBloc({@required this.userRepository}): assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      final hasToken = await userRepository.getSessionInfo();
      if (!hasToken.hasError()) {
        final odooUser = userRepository.odooUser;
        yield AuthenticationAuthenticated(odooUser: odooUser, odooClient: userRepository);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      final odooUser = userRepository.odooUser;
      yield AuthenticationAuthenticated(odooUser: odooUser, odooClient: userRepository);
    }

    if (event is LoggedOut) {
      await userRepository.logout();
      yield AuthenticationLoading();
      yield AuthenticationUnauthenticated();
    }
  }

}

extension on OdooClient {
  Future<void> logout() async{
    var url = createPath("/web/session/destroy");
    OdooResponse response =  await callRequest(url, createPayload({}));
    return response.hasError();
  }
}