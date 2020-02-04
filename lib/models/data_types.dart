import 'package:equatable/equatable.dart';

abstract class Document extends Equatable {
  int id;
  String model;

  @override
  List<Object> get props => [model, id];
}

abstract class Collection extends Equatable {
  String model;

  @override
  List<Object> get props => [model];
}