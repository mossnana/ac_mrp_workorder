import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ac_mrp_workorder/blocs/write_data/write_data_event.dart';
import 'package:ac_mrp_workorder/blocs/write_data/write_data_state.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';

class WriteStockMoveLineBloc extends Bloc<WriteDataEvent, WriteDataState> {
  final OdooClient _odooClient;

  WriteStockMoveLineBloc({
    @required odooClient
  }): _odooClient = odooClient;

  dynamic decodedResult(OdooResponse result) {
    var response = result.getResult();
    var data = json.encode(response['records']);
    var decoded = json.decode(data);
    return decoded;
  }

  @override
  WriteDataState get initialState => WriteStockMoveLineInit();

  @override
  Stream<WriteDataState> mapEventToState(WriteDataEvent event) async* {
    if(event is WriteStockMoveLineStarted) {
      yield WriteStockMoveLineLoading();
      var lotNameSearchResult = await _odooClient.searchRead('stock.production.lot', [['name','=',event.lot_name], ['product_id','=',event.product_id]], ['id']);
      if(!lotNameSearchResult.hasError()) {
        var lotIds = decodedResult(lotNameSearchResult);
        if(lotIds.length != 0) {
          var res = await _odooClient.callKW('stock.move.line', 'add_new_line_mobile_app', [[event.id], lotIds[0]['id']]);
          if(!res.hasError()) {
            yield WriteStockMoveLineSuccess();
          } else {
            yield WriteStockMoveLineFailed();
          }
        }
      }
    }
  }
}