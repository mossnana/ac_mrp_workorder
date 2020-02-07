import 'package:ac_mrp_workorder/models/data_models.dart';
import 'package:flutter/cupertino.dart';

class WorkOrderArgument {
  int id;
  String name;
  String qrCodeResult;
  StockMoveLineCollection activeMoveLineIds;

  WorkOrderArgument({
    this.id,
    this.name,
    this.qrCodeResult,
    this.activeMoveLineIds,
  });
}