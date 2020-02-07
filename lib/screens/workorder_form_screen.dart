
import 'package:ac_mrp_workorder/models/navigate_arguments.dart';
import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api.dart';

class WorkOrderFormScreen extends StatefulWidget {
  final OdooClient userRepository;

  WorkOrderFormScreen({
    @required this.userRepository
  });

  State<WorkOrderFormScreen> createState() => _WorkOrderFormScreen();

}

class _WorkOrderFormScreen extends State<WorkOrderFormScreen> {

  @override
  void initState() {
    super.initState();
  }

  OdooClient get _userRepository => widget.userRepository;

  @override
  Widget build(BuildContext context) {
    final WorkOrderArgument args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            Text('Args'),
            Text(args.id.toString()),
            Text(args.name)
          ],
        ),
      ),
    );
  }
}