part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {}

//Update
class UpdateBorssaLoading extends CurrencyState {}

class UpdateBorssaError extends CurrencyState {}

class UpdateBorssaSuccess extends CurrencyState {}

//Chart
class ChartBorssaLoading extends CurrencyState {}

class ChartBorssaError extends CurrencyState {}

class ChartBorssaLoaded extends CurrencyState {
  late final List<DataChanges> dataChanges;
  ChartBorssaLoaded({
    required this.dataChanges,
  });
}

//Undo

class UndoUpdateLoading extends CurrencyState {}

class UndoUpdateError extends CurrencyState {}

class UndoUpdateLoaded extends CurrencyState {
  final String status;
  UndoUpdateLoaded({
    required this.status,
  });
}

//Close

class ClosePriceLoading extends CurrencyState {}

class ClosePriceError extends CurrencyState {}

class ClosePriceLoaded extends CurrencyState {}
