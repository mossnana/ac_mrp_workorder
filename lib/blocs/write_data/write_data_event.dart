

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WriteDataEvent extends Equatable {
  const WriteDataEvent();

  @override
  List<Object> get props => [];
}

// Write Stock Move Line Event
class WriteStockMoveLineStarted extends WriteDataEvent {
  final int id;
  final int lot_id;

  const WriteStockMoveLineStarted({this.id, this.lot_id});
}

class WriteStockMoveLineFinished extends WriteDataEvent {}

