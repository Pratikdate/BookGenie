


import 'package:bookapp/features/book/domain/%20entities/chat_message.dart';
import 'package:bookapp/features/book/domain/repositories/chat_repository.dart';

class ChatMessageUseCase {
  final ChatRepository chatRepository;

  ChatMessageUseCase(this.chatRepository);

  Future<ChatMessage> execute({required String message,required String sourceID}) async {
    return await chatRepository.chatResponseMessage(message: message, sourceID: sourceID);
  }
}

class UploadPdfForChatUseCase {
  final ChatRepository chatRepository;

  UploadPdfForChatUseCase(this.chatRepository);

  Future<String?> execute({required String bookUid}) async {
    return await chatRepository.uploadBookForChat(bookUid: bookUid);
  }
}

class DeleteChatBookUseCase {
  final ChatRepository chatRepository;

  DeleteChatBookUseCase(this.chatRepository);

  Future<bool> execute({required String bookUid}) async {
    return await chatRepository.deleteBookFromChat(bookUid: bookUid);
  }
}
