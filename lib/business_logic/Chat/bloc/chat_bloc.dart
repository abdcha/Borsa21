import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Chat.dart';
import 'package:equatable/equatable.dart';
import 'package:central_borssa/data/repositroy/ChatRepository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepository chatRepository;
  ChatBloc(ChatInitial chatInitial, this.chatRepository) : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is InitialChatEvent) {
      yield ChatInitial();
    } else if (event is GetAllMessagesEvent) {
      yield GetAllMessagesIsLoading();
      var getAllCompanyInformationsResponse =
          await chatRepository.allMessages(event.page, event.pageSize);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield GetAllMessagesError();
      }, (r) async* {
        print('we are in message');
        print(r);
        yield GetAllMessagesIsLoaded(data: r);
      });
    } else if (event is SendMessageEvent) {
      yield SendMessageIsLoading();
      var getAllCompanyInformationsResponse =
          await chatRepository.sendMessages(event.message);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield SendMessageError();
      }, (r) async* {
        print('we are in message');
        print(r);
        yield SendMessageIsLoaded(status: r);
      });
    }
  }
}
