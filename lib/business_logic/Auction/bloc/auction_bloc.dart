import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Auction.dart';
import 'package:central_borssa/data/repositroy/AuctionRepository.dart';
import 'package:central_borssa/presentation/Auction/Auction.dart';
import 'package:equatable/equatable.dart';

part 'auction_event.dart';
part 'auction_state.dart';

class AuctionBloc extends Bloc<AuctionEvent, AuctionState> {
  AuctionRepository auctionrepository;
  AuctionBloc(AuctionState borssaState, this.auctionrepository)
      : super(AuctionInitial());

  @override
  Stream<AuctionState> mapEventToState(AuctionEvent event) async* {
    if (event is GetAuctionEvent) {
      yield GetAuctionLoading();

      final allCititesResponse = await auctionrepository.getAllAuctions();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        yield GetAuctionError();
        print('error');
      }, (r) async* {
        yield GetAuctionLoaded(auctions: r);
        print('get all');
      });
    }
  }
}
