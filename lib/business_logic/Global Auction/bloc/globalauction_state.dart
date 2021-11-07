part of 'globalauction_bloc.dart';

abstract class GlobalauctionState extends Equatable {
  const GlobalauctionState();

  @override
  List<Object> get props => [];
}

class GlobalauctionInitial extends GlobalauctionState {}

// Global Auction
class GetGlobalauctionLoading extends GlobalauctionState {}

class GetGlobalauctionError extends GlobalauctionState {}

class GetGlobalauctionLoaded extends GlobalauctionState {
  final Rates rates;
  GetGlobalauctionLoaded({
    required this.rates,
  });
}
