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


  Future scan(int id) async {
    try {
      String barcode = await BarcodeScanner.scan();
      print("Scanner Code : $barcode, Move Line ID : $id");
      setState((){
        this.barcode = barcode;
      });
      await BlocProvider.of<WriteStockMoveLineBloc>(context).add(WriteStockMoveLineStarted(id: id, lot_id: int.parse(this.barcode)));
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
            scan(movesList.datas[index].id);
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
                    height: 100.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5)
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("https://i.imgur.com/TQAOVkUb.jpg")
                        )
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(movesList.datas[index].product.name),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Container(
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.teal),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Text("Draft",textAlign: TextAlign.center,),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                            child: Container(
                              width: 260,
                              child: Text("Test Test",style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 48, 48, 54)
                              ),),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );

       /* return ListTile(
          title: Text(movesList.datas[index].product.name),
        );*/

      },
    ) : Text('No Data');

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Move Line Scanner'),
      ),
      body: Center(
        child: _myListView,
      ),
    );
  }
}