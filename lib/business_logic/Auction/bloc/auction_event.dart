part of 'auction_bloc.dart';

abstract class AuctionEvent extends Equatable {
  const AuctionEvent();

  @override
  List<Object> get props => [];
}

class GetAuctionEvent extends AuctionEvent {}


