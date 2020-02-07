import 'dart:convert';
import 'package:ac_mrp_workorder/models/data_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';

abstract class FetchDataState extends Equatable {
  @override
  List<Object> get props => [];

  dynamic decodedResult(OdooResponse result) {
    var response = result.getResult();
    var data = json.encode(response['records']);
    var decoded = json.decode(data);
    return decoded;
  }
}

// Work Order
class FetchWorkOrderInit extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Begin Fetching Work Orders Data ...';
}

class FetchWorkOrderLoading extends FetchDataState {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loading Work Orders Data ...';
}

class FetchWorkOrderSuccess extends FetchDataState {
  final OdooClient _odooClient;

  FetchWorkOrderSuccess({
    @required OdooClient odooClient
  }): _odooClient = odooClient;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Fetch Work Orders Data Success ...';

  Stream<dynamic> readAllTest() async* {
    var result = await _odooClient.searchRead('mrp.workorder', [], ['id','name'], limit: 1);
    if (!result.hasError()) {
      var decoded = decodedResult(result);
      yield decoded;
    } else {
      print("Can't Streaming data from server.");
    }
  }

  Stream<dynamic> readAll() async* {
    var result = await _odooClient.searchRead(
        'mrp.workorder',
        [],
        ['id','name','active_move_line_ids','qty_produced','workcenter_id','product_id', 'state'],
    );
    MrpWorkOrderCollection workOrderIds = MrpWorkOrderCollection();
    if (!result.hasError()) {
      var decoded = decodedResult(result);
      yield decoded;
      for(var rec in decoded) {
        print(rec);
        MrpWorkOrder workOrder = MrpWorkOrder(
          id: rec['id'],
          name: rec['name'],
          productId: rec['product_id'],
          state: rec['state'],
        );
        workOrder.setStateColor = rec['state'];
        workOrderIds.add(workOrder);
      }
      yield workOrderIds;
    } else {
      yield workOrderIds;
    }
  }

  Future<dynamic> mapStockMoveLine(ids) async {
    var result = await _odooClient.searchRead(
        'stock.move.line',
        [['id', 'in', ids]],
        ['id','product_id','lot_ids','qty_done','qty_lot', 'uom_id']
    );
    if (!result.hasError()) {
      // TODO: Get Move Line ids
      var decoded = decodedResult(result);
      StockMoveLineCollection moveLines = StockMoveLineCollection();
      for(var rec in decoded) {
        StockMoveLine moveLine = StockMoveLine(
          id: rec['id'],
        );
        moveLine.product = await mapProduct(rec['product_id']);
        moveLine.lotIds = await mapLotId(rec['lot_ids']);
        moveLines.add(moveLine);
      }
      return moveLines;
    } else {
      return false;
    }
  }

  Future<dynamic> mapLotId(ids) async {
    // TODO: Get Lot data
    var result = await _odooClient.searchRead(
        'stock.move.line',
        [['id', 'in', ids]],
        ['id','name','product_id','product_qty','product_uom']
    );
    if (!result.hasError()) {
      var decoded = decodedResult(result);
      StockProductionLotCollection lotIds = StockProductionLotCollection();
      for(var rec in decoded) {
        StockProductionLot newLot = new StockProductionLot(
          id: rec['id'],
          name: rec['name'],
          productQty: rec['productQty'],
        );
        newLot.product = await mapProduct(rec['product_id'][0]);
        lotIds.add(newLot);
      }
      return lotIds;
    } else {
      return false;
    }
  }

  Future<dynamic> mapProduct(id) async {
    print('>>>>>> 1');
    print(id);
    var result = await _odooClient.searchRead(
        'product.product',
        [['id', '=', id]],
        ['id','name']
    );
    print(result);
    if (!result.hasError()) {
      var decoded = decodedResult(result);
      ProductProduct product = ProductProduct(
        id: decoded[0],
        name: decoded[1],
      );
      return product;
    } else {
      return false;
    }
  }

}

class FetchWorkOrderFailed extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Fetch Work Orders Data Failed ...';
}

// User
class FetchUserInit extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Begin Fetching User Data ...';
}

class FetchUserLoading extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loading User Data ...';
}

class FetchUserSuccess extends FetchDataState {
  final OdooUser _odooUser;

  FetchUserSuccess({
    @required OdooUser odooUser
  }): _odooUser = odooUser;

  @override
  List<Object> get props => [];

  Stream<dynamic> info() async* {
    var odooUserResponse = await _odooUser;
    yield {
      'uid': odooUserResponse.uid,
      'name': odooUserResponse.name,
      'sessionId': odooUserResponse.sessionId,
      'username': odooUserResponse.username,
      'companyId': odooUserResponse.companyId,
      'database': odooUserResponse.database,
    };
  }

  @override
  String toString() => 'Fetch User Data Success';
}

class FetchUserFailed extends FetchDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Fetch User Data Failed';
}