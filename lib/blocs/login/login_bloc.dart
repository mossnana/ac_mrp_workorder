import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';

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

  LoginState get initialState => LoginInitial(odooClient: userRepository);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        print(event.db);
        print(event.employeeCode);
        var response = await userRepository.authenticateWithMobileApp(
          event.db, event.employeeCode
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

extension on OdooClient {
  // Authenticate user with mobile app
  Future<AuthenticateCallback> authenticateWithMobileApp(String database, String employeeCode) async {
    var url = createPath("/web/session/authenticate_with_mobile_app");
    var params = {
      "db": database,
      "employee_code": employeeCode,
    };
    final response = await callRequest(url, createPayload(params));
    print(url);
    final session = await getSessionInfo();
    final authCallBack = new AuthenticateCallback(!response.hasError(), response, session.getSessionId());
    odooUser = authCallBack.getUser();
    return authCallBack;
  }
}
