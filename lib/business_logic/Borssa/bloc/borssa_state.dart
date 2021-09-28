import 'package:central_borssa/data/model/Currency.dart';
import 'package:equatable/equatable.dart';

class BorssaState extends Equatable {
  const BorssaState();

  @override
  List<Object> get props => [];
}

class BorssaInitial extends BorssaState {}

class GetAllCityState extends BorssaState {
  late final List<CurrencyPrice> cities;

  GetAllCityState({
    required this.cities,
  });
}

class BorssaReloadingState extends BorssaState {}

class BorssaLoading extends BorssaState {}

class BorssaErrorLoading extends BorssaState {}

class UpdateBorssaLoading extends BorssaState {}

class UpdateBorssaError extends BorssaState {}

class UpdateBorssaSuccess extends BorssaState {}
