import 'package:equatable/equatable.dart';

abstract class WriteDataEvent extends Equatable {
  const WriteDataEvent();

  @override
  List<Object> get props => [];
}

// Write Stock Move Line Event
class WriteStockMoveLineStarted extends WriteDataEvent {
  final int id;
  final String lot_name;
  final int product_id;

  const WriteStockMoveLineStarted({this.id, this.lot_name, this.product_id});
}

class WriteStockMoveLineFinished extends WriteDataEvent {}

