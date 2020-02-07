import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'data_types.dart';

class ProductProduct extends Document {
  int id;
  String name;

  ProductProduct({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return "[$id] $name";
  }
}

class ProductUom extends Document {
  int id;
  String name;

  ProductUom({
    @required id,
    this.name
  });
}

class MrpWorkOrderLot extends Document {
  int id;
  String date;
  String userId;
  String lotId;

  MrpWorkOrderLot({
    @required this.id,
    this.date,
    this.userId,
    this.lotId,
  });
}

class MrpWorkOrderLotCollection extends Collection {
  String model = 'mrp.workorder.lot';
  List<MrpWorkOrderLot> datas = [];

  void add(MrpWorkOrderLot data) {
    datas.add(data);
  }
}

class StockProductionLot extends Document {
  int id;
  String name;
  ProductProduct product;
  dynamic productQty;
  dynamic productUom;

  StockProductionLot({
    @required this.id,
    this.name,
    this.productQty,
  });
}

class StockProductionLotCollection extends Collection {
  String model = 'stock.production.lot';
  List<StockProductionLot> datas = [];

  void add(StockProductionLot data) {
    datas.add(data);
  }

}

class StockMoveLine extends Document {
  int id;
  StockProductionLotCollection lotIds;
  ProductProduct product = new ProductProduct();
  dynamic qtyDone;

  StockMoveLine({
    @required this.id,
    this.qtyDone,
  });

  set setProduct(productList) {
    product.id = productList[0];
    product.name = productList[1];
  }

}

class StockMoveLineCollection extends Collection {
  String model = 'stock.move.line';
  List<StockMoveLine> datas = [];

  void add(StockMoveLine data) {
    datas.add(data);
  }

  int count() {
    return datas.length != 0 ? datas.length : 0;
  }
}

class MrpWorkOrder extends Document {
  int id;
  String name;
  String state;
  MaterialColor stateColor;
  int workCenterId;
  List<dynamic> productId;
  StockMoveLineCollection activeMoveLineIds;

  MrpWorkOrder({
    @required this.id,
    @required this.name,
    this.workCenterId,
    this.productId,
    this.state,
  });

  set setStateColor(state) {
    switch(state){
      case 'done': {
        stateColor = Colors.red;
        break;
      }
      case 'progress': {
        stateColor = Colors.deepOrange;
        break;
      }
      case 'done': {
        stateColor = Colors.green;
        break;
      }
      default: {
        stateColor = Colors.purple;
        break;
      }
    }
  }
}

class MrpWorkOrderCollection extends Collection {
  String model = 'mrp.workorder';
  List<MrpWorkOrder> datas = [];

  void add(MrpWorkOrder recentData) {
    datas.add(recentData);
  }

  @override
  String toString() {
    return "Work Order List";
  }
}