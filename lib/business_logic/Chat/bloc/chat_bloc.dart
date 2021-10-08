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
      var getAllCompanyInformationsResponse =
          await chatRepository.allMessages(event.page, event.pageSize);
      yield* getAllCompanyInformationsResponse.fold((l) async* {
        yield GetAllMessagesError();
      }, (r) async* {
        print('we are in message');
        print(r);
        yield GetAllMessagesIsLoading();
        yield GetAllMessagesIsLoaded(data: r);
      });
    }
  }
}
