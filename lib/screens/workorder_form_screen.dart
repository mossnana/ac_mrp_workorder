
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
  var moveLines;

  @override
  void initState() {
    super.initState();
  }

  OdooClient get _userRepository => widget.userRepository;

  @override
  Widget build(BuildContext context) {
    final WorkOrderArgument args = ModalRoute.of(context).settings.arguments;
    final movesList = args.activeMoveLineIds;

    Widget x(index)  => args.activeMoveLineIds.count() != 0 ? Text(args.activeMoveLineIds.datas[index].product.name) : Text('Loading');

    Widget _myListView = movesList.count() != 0 ? ListView.builder(
      itemCount: movesList.count(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(movesList.datas[index].product.name),
        );
      },
    ) : Text('No Data');

    return Scaffold(
      body: Center(
        child: _myListView
      ),
    );
  }
}