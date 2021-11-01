part of 'gloableauction_bloc.dart';

abstract class GlobalauctionEvent extends Equatable {
  const GlobalauctionEvent();

  @override
  List<Object> get props => [];
}


class GetGlobalauctionEvent extends GlobalauctionEvent {}
