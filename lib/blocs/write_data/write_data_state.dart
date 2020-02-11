import 'package:equatable/equatable.dart';

abstract class WriteDataState extends Equatable {
  @override
  List<Object> get props => [];
}

// Work Stock Move Line
class WriteStockMoveLineInit extends WriteDataState {}

class WriteStockMoveLineLoading extends WriteDataState {}

class WriteStockMoveLineSuccess extends WriteDataState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return "Write Stock Move Line Finished";
  }

}

class WriteStockMoveLineFailed extends WriteDataState {}
