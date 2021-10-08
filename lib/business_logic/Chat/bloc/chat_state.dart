part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

//get all messages

class GetAllMessagesIsLoading extends ChatState {}

class GetAllMessagesError extends ChatState {}

class GetAllMessagesIsLoaded extends ChatState {
  final Data data;
  GetAllMessagesIsLoaded({
    required this.data,
  });
}
