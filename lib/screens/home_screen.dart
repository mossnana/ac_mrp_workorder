import 'dart:convert';

import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_bloc.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_event.dart';
import 'package:ac_mrp_workorder/screens/workorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';

class HomeScreen extends StatefulWidget {
  final OdooClient _userRepository;

  HomeScreen({
    @required Key key,
    @required userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  OdooClient get _userRepository => widget._userRepository;

  OdooUser get _odooUser => widget._userRepository.odooUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider<FetchUserBloc>(
            create: (BuildContext context) =>
            FetchUserBloc(odooUser: _odooUser)..add(FetchUserStarted()),
          ),
          BlocProvider<FetchWorkOrderBloc>(
            create: (BuildContext context) =>
                FetchWorkOrderBloc(odooClient: _userRepository)..add(FetchWorkOrderStarted()),
          ),
        ],
        child: WorkOrderScreen()
    );
  }
}
