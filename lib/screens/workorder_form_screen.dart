import 'package:ac_mrp_workorder/blocs/write_data/write_data_bloc.dart';
import 'package:ac_mrp_workorder/blocs/write_data/write_data_event.dart';
import 'package:ac_mrp_workorder/models/navigate_arguments.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String barcode = "No code";
  OdooClient get _userRepository => widget.userRepository;

  @override
  void initState() {
    super.initState();
  }

  Future scan(int id, int product_id) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState((){
        this.barcode = barcode;
      });
      await BlocProvider.of<WriteStockMoveLineBloc>(context).add(WriteStockMoveLineStarted(id: id, lot_name: this.barcode, product_id: product_id));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // The user did not grant the camera permission.
      } else {
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      // Unknown error.
    }
  }

  @override
  Widget build(BuildContext context) {
    final WorkOrderArgument args = ModalRoute.of(context).settings.arguments;
    final movesList = args.activeMoveLineIds;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<int> scannedIndex = [];

    Widget _myListView = movesList.count() != 0 ? ListView.builder(
      itemCount: movesList.count(),
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(movesList.datas[index].id.toString()),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.greenAccent,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            scan(movesList.datas[index].id, movesList.datas[index].product.id);
            setState(() {
              movesList.datas.removeAt(index);
            });
          },
          direction: DismissDirection.endToStart,
          child: Card(
            elevation: 5,
            child: Container(
              height: 100.0,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: width * 0.8,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: Text(movesList.datas[index].product.name, softWrap: true,)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: movesList.datas[index].scanned ? Container(
                              width: width * 0.5,
                              height: 20,
                              color: Colors.green,
                              child: Text("Scanned",textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                            ) : Container(
                              width: width * 0.5,
                              height: 20,
                              color: Colors.deepOrange,
                              child: Text("Ready to Scan",textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      iconSize: width * 0.1,
                      onPressed: () {
                        try {
                          scan(movesList.datas[index].id, movesList.datas[index].product.id);
                          movesList.datas[index].scanned = true;
                          setState(() {
                            scannedIndex.add(index);
                          });
                        } catch(e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ) : Text('No Data');

    return Scaffold(
      appBar: AppBar(
        title: Text('Move Line Scanner'),
      ),
      body: Center(
        child: _myListView,
      ),
    );
  }
}