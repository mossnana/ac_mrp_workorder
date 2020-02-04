import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import '../blocs/authentication/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  final OdooClient _userRepository;

  HomeScreen({
    @required Key key,
    @required userRepository,
  }): assert(userRepository != null), _userRepository = userRepository, super(key: key);

  State<HomeScreen> createState() => _HomeScreen();

}

class _HomeScreen extends State<HomeScreen> {

  OdooClient get _userRepository => widget._userRepository;
  dynamic name = '';
  dynamic uid = '';
  dynamic partnerId = '';
  dynamic companyId = '';
  dynamic username = '';
  dynamic sessionId = '';
  List<dynamic> workOrderLists = [];

  Future<void> getUserInfo() async {
    OdooUser result = _userRepository.odooUser;
    setState(() {
      name = result.name;
      uid = result.uid;
      sessionId = result.sessionId;
      partnerId = result.partnerId;
      companyId = result.companyId;
      username = result.username;
    });
  }

  Future<void> getWorkOrders() async {
    OdooResponse result = await _userRepository.searchRead("mrp.workorder", [], ['id','name']);
    if (!result.hasError()) {
      var response = result.getResult();
      var data = json.encode(response['records']);
      var decoded = json.decode(data);
      setState(() {
        workOrderLists = decoded;
      });
    } else {
      print(result.getError());
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    // TODO: Imprement Work Orders
    // getWorkOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
      body: Center(
        child: Container(),
      ),
      drawer: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Main Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Work Orders'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Work Centers'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
