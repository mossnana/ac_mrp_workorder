import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ac_mrp_workorder/blocs/write_data/write_data_event.dart';
import 'package:ac_mrp_workorder/blocs/write_data/write_data_state.dart';
import 'package:odoo_api/odoo_api.dart';

class WriteStockMoveLineBloc extends Bloc<WriteDataEvent, WriteDataState> {
  final OdooClient _odooClient;

  WriteStockMoveLineBloc({
    @required odooClient
  }): _odooClient = odooClient;

  @override
  WriteDataState get initialState => WriteStockMoveLineInit();

  @override
  Stream<WriteDataState> mapEventToState(WriteDataEvent event) async* {
    if(event is WriteStockMoveLineStarted) {
      yield WriteStockMoveLineLoading();
      var res = await _odooClient.callKW('stock.move.line', 'add_new_line', [[event.id], event.lot_id]);
      if(!res.hasError()) {
        yield WriteStockMoveLineSuccess();
      } else {
        yield WriteStockMoveLineFailed();
      }
    }
  }
}