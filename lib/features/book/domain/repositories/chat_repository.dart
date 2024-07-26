





import 'package:bookapp/features/book/domain/%20entities/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> chatResponseMessage({required String message,required String sourceID});
  Future<String?> uploadBookForChat({required String bookUid});
  Future<bool> deleteBookFromChat({required String bookUid});

}
