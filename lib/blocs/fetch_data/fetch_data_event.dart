import 'package:equatable/equatable.dart';

abstract class FetchDataEvent extends Equatable {
  const FetchDataEvent();

  @override
  List<Object> get props => [];
}

// Work Order
class FetchWorkOrderStarted extends FetchDataEvent {}

class FetchWorkOrderFinished extends FetchDataEvent {}

// User
class FetchUserStarted extends FetchDataEvent {}

class FetchUserFinished extends FetchDataEvent {}