





import 'dart:io';

import 'package:bookapp/features/book/domain/%20entities/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> chatResponseMessage({required String message,required String sourceID});
  Future<String?> uploadBookForChat({required String bookUid});
  Future<String?> sendBookRequest({required File file});
  Future<bool> deleteBookFromChat({required String bookUid});

  //Backend API
  Future<bool?> setUpBookForChat({required String bookUid});
  Future<ChatMessage> chatRequest({required String message,required String sourceID,required String bookUid});

}
