part of 'auction_bloc.dart';

abstract class AuctionState extends Equatable {
  const AuctionState();

  @override
  List<Object> get props => [];
}

class AuctionInitial extends AuctionState {}

//Auction Get
class GetAuctionLoading extends AuctionState {}

class GetAuctionError extends AuctionState {}

class GetAuctionLoaded extends AuctionState {
  final List<Auctions> auctions;
  GetAuctionLoaded({
    required this.auctions,
  });
}
