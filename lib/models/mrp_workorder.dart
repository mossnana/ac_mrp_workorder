import 'package:meta/meta.dart';

import 'data_types.dart';

class StockMoveLine extends Document {

  StockMoveLine({
    @required productId,
    lotId,
    qtyDone,
    qtyLot,
    uomId,
  });
}

class MrpWorkOrder extends Document {
  String name;
  int productId;
  int workCenterId;

  MrpWorkOrder({
    @required id,
    @required name,
    @required productId,
    @required workCenterId,
  }) : super();


}

class MrpWorkOrderCollection extends Collection {
  String model = 'mrp.workorder';
  List<MrpWorkOrder> datas = [];
}