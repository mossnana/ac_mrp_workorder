import 'package:ac_mrp_workorder/screens/select_databases_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../blocs/login/login_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  List<dynamic> _databases = [];
  String selectedDatabase = "";

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() async {
      try {
        String employeeCode = await BarcodeScanner.scan();
        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(
              db: '$selectedDatabase',
              employeeCode: employeeCode
          ),
        );
      } catch(e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Can not login to server'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    Widget _selectDatabaseWidget() {
      if(_databases.length != 0) {
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.storage),
                  title: Text('$selectedDatabase'),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Change Databases'),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectDatabasesScreen(databasesList: _databases,)),
                        );
                        setState(() {
                          selectedDatabase = result;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      } else {
        return Container(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.storage),
                  title: Text('Loading ...'),
                ),
              ],
            ),
          ),
        );
      }
    }

    _getDatabase(state) async {
      if(selectedDatabase == "") {
        var databases = await state.getDatabases();
        setState(() {
          _databases = databases;
          selectedDatabase = databases[0];
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          _getDatabase(state);
          return Form(
            child: Column(
              children: [
                _selectDatabaseWidget(),
                RaisedButton(
                  onPressed:
                  state is! LoginLoading ? _onLoginButtonPressed : null,
                  child: Text('Login'),
                ),
                Container(
                  child: state is LoginLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
