part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class UpdateBorssaLoading extends CurrencyState {}

class UpdateBorssaError extends CurrencyState {}

class UpdateBorssaSuccess extends CurrencyState {}

class ChartBorssaLoading extends CurrencyState {}

class ChartBorssaError extends CurrencyState {}

class ChartBorssaLoaded extends CurrencyState {
  late final List<DataChanges> dataChanges;
  ChartBorssaLoaded({
    required this.dataChanges,
  });
}
