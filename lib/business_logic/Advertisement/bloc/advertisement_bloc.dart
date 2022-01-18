import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Advertisement.dart';
import 'package:central_borssa/data/repositroy/AdvertisementRepository.dart';
import 'package:equatable/equatable.dart';

part 'advertisement_event.dart';
part 'advertisement_state.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  AdvertisementRepository advertisementRepository;
  AdvertisementBloc(
      AdvertisementState advertisementState, this.advertisementRepository)
      : super(AdvertisementInitial());

  @override
  Stream<AdvertisementState> mapEventToState(AdvertisementEvent event) async*{
      if (event is GetAdvertisementEvent) {
      yield GetAdvertisementLoading();
      final allCititesResponse = await advertisementRepository.getAdvertisement();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        yield GetAdvertisementError();
      }, (r) async* {
        yield GetAdvertisementLoaded(allAdvertisements: r);
      });
    }
  }
}
