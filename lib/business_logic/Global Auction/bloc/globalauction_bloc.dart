import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/GlobalAuction.dart';
import 'package:central_borssa/data/repositroy/GlobalAuctionRepository.dart';
import 'package:equatable/equatable.dart';

part 'globalauction_event.dart';
part 'globalauction_state.dart';

class GlobalauctionBloc extends Bloc<GlobalauctionEvent, GlobalauctionState> {
  GlobalAuctionRepository globalAuctionRepository;

  GlobalauctionBloc(
    GlobalauctionState currencyEvent,
    this.globalAuctionRepository,
  ) : super(GlobalauctionInitial());

  @override
  Stream<GlobalauctionState> mapEventToState(GlobalauctionEvent event) async* {
    if (event is GetGlobalauctionEvent) {
      yield GetGlobalauctionLoading();
      final allCititesResponse =
          await globalAuctionRepository.getGlobalAuction();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        yield GetGlobalauctionError();
      }, (r) async* {
        yield GetGlobalauctionLoaded(rates: r);
      });
    }
  }
}