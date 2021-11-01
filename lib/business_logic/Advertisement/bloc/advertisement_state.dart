part of 'advertisement_bloc.dart';

abstract class AdvertisementState extends Equatable {
  const AdvertisementState();

  @override
  List<Object> get props => [];
}

class AdvertisementInitial extends AdvertisementState {}

// get
class GetAdvertisementLoading extends AdvertisementState {}

class GetAdvertisementError extends AdvertisementState {}

class GetAdvertisementLoaded extends AdvertisementState {
   final List<Advertisements> allAdvertisements;
  GetAdvertisementLoaded({
    required this.allAdvertisements,
  });
}
