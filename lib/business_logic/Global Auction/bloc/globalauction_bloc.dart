import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/GlobalAuction.dart';
import 'package:central_borssa/data/repositroy/GlobalAuctionRepository.dart';
import 'package:equatable/equatable.dart';

part 'globalauction_event.dart';
part 'globalauction_state.dart';

class GlobalauctionBloc extends Bloc<GlobalauctionEvent, GlobalauctionState> {
  GlobalAuctionRepository globalAuctionRepository;
  late Rates rates;
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
        rates = r;
        yield GetGlobalauctionLoaded(rates: r);
      });
    } else if (event is ProductGlobalauctionEvent) {
      yield GetProductGlobalauctionLoading();
      late Rates temprate = rates;
      print('product');
      print(rates.eUR.rateForAmount);
      //1
      temprate.aED.rateForAmount =
          (event.prodcut * (double.parse(temprate.aED.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.aZN.rateForAmount =
          (event.prodcut * (double.parse(temprate.aZN.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //2
      temprate.bHD.rateForAmount =
          (event.prodcut * (double.parse(temprate.bHD.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.cAD.rateForAmount =
          (event.prodcut * (double.parse(temprate.cAD.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //3
      temprate.cNY.rateForAmount =
          (event.prodcut * (double.parse(temprate.cNY.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.dKK.rateForAmount =
          (event.prodcut * (double.parse(temprate.dKK.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //4
      temprate.eGP.rateForAmount =
          (event.prodcut * (double.parse(temprate.eGP.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.eUR.rateForAmount =
          (event.prodcut * (double.parse(temprate.eUR.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //5
      temprate.gBP.rateForAmount =
          (event.prodcut * (double.parse(temprate.gBP.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.iRR.rateForAmount =
          (event.prodcut * (double.parse(temprate.iRR.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //6
      temprate.jOD.rateForAmount =
          (event.prodcut * (double.parse(temprate.jOD.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.jPY.rateForAmount =
          (event.prodcut * (double.parse(temprate.jPY.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //7
      temprate.kWD.rateForAmount =
          (event.prodcut * (double.parse(temprate.kWD.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.lBP.rateForAmount =
          (event.prodcut * (double.parse(temprate.lBP.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //8
      temprate.nOK.rateForAmount =
          (event.prodcut * (double.parse(temprate.nOK.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.qAR.rateForAmount =
          (event.prodcut * (double.parse(temprate.qAR.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //9
      temprate.sAR.rateForAmount =
          (event.prodcut * (double.parse(temprate.sAR.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.sEK.rateForAmount =
          (event.prodcut * (double.parse(temprate.sEK.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      //10
      temprate.sYP.rateForAmount =
          (event.prodcut * (double.parse(temprate.sYP.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      temprate.tRY.rateForAmount =
          (event.prodcut * (double.parse(temprate.tRY.rateForAmount)))
              .toStringAsFixed(2)
              .toString();
      final allCititesResponse =
          await globalAuctionRepository.getGlobalAuction();
      rates = rates;
      yield* allCititesResponse.fold((l) async* {
        print(l);
        yield GetProductGlobalauctionError();
      }, (r) async* {
        rates = r;
        yield GetProductGlobalauctionLoaded(rates: temprate);
      });
    }
  }
}
