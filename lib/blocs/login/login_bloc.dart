import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:odoo_api/odoo_api.dart';

import'../authentication/authentication_bloc.dart';
import 'login_state.dart';
import 'login_event.dart';

export 'login_state.dart';
export 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final OdooClient userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        var response = await userRepository.authenticate(
          event.username, event.password, event.db
        );
        if(response.isSuccess) {
          authenticationBloc.add(LoggedIn(userRepository: userRepository));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: 'Wrong Login or Password');
        }

      } catch (error) {
        yield LoginFailure(error: "Can't connect to server");
      }
    }
  }
}
