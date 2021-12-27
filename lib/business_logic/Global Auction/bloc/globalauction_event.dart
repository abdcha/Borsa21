part of 'globalauction_bloc.dart';

abstract class GlobalauctionEvent extends Equatable {
  const GlobalauctionEvent();

  @override
  List<Object> get props => [];
}

class GetGlobalauctionEvent extends GlobalauctionEvent {}

class ProductGlobalauctionEvent extends GlobalauctionEvent {
  final double prodcut;
  ProductGlobalauctionEvent({
    required this.prodcut,
  });
}
