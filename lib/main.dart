import 'package:ac_mrp_workorder/delegates/bloc_delegate.dart';
import 'package:ac_mrp_workorder/screens/workorder_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import './blocs/authentication/authentication_bloc.dart';
import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './widgets/loading.dart';

void main() {
  /* BloC Delegate for check State Change */
  // BlocSupervisor.delegate = AppBlocDelegate();
  final userRepository = OdooClient('http://erp.naraipak.com');
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final OdooClient userRepository;
  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) {
              return SplashPage();
            }
            if (state is AuthenticationAuthenticated) {
              return HomeScreen(userRepository: userRepository);
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginScreen(userRepository: userRepository);
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
            return SplashPage();
          },
        ),
        '/workOrderItem': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            debugPrint('state is $state');
            if (state is AuthenticationAuthenticated) {
              return WorkOrderFormScreen(userRepository: userRepository);
            }
            return SplashPage();
          },
        ),
      },
    );
  }
}
