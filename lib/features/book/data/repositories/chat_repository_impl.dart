import '../../domain/ entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasouces/remote/chat_api_service.dart';



class ChatRepositoryImpl implements ChatRepository {
  final RemoteChatApiDataSource remoteChatApiDataSource;

  ChatRepositoryImpl(this.remoteChatApiDataSource);

  @override
  Future<ChatMessage> chatResponseMessage({required String message, required String sourceID}) async {
    final chatResponseData=await remoteChatApiDataSource.sendMessage(message: message, sourceID: sourceID);
    return ChatMessage(
      sourceID: chatResponseData.sourceID,
      createdAt: chatResponseData.createdAt,
      id: chatResponseData.id,
      text: chatResponseData.text
    );
  }

  @override
  Future<bool> deleteBookFromChat({required String bookUid}) async {
    return await remoteChatApiDataSource.deleteBook(sourceID: bookUid);

  }

  @override
  Future<String?> uploadBookForChat({required String bookUid}) async {
    return await remoteChatApiDataSource.fetchUrlfromNetwork(bookUid: bookUid);

  }

}