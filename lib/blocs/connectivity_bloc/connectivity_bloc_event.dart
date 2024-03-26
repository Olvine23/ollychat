import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityResult connectivity;

  const ConnectivityChanged(this.connectivity);

  @override
  List<Object> get props => [connectivity];
}