import 'package:bookapp/core/ColorHandler.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:bookapp/features/book/presentation/controllers/tab_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import '../../../../core/Tokens.dart';
import '../../domain/usecases/chat_usecase.dart';

class ChatTabController extends GetxController {
  late final types.User user;
  var messages = <types.Message>[].obs;
  var bookLoad = false.obs;
  var sourceID = ''.obs;
  var isLoading = true.obs;
  var bookUid = ''.obs;
  late String file;

  final ChatMessageUseCase chatMessageUseCase;
  final UploadPdfForChatUseCase uploadPdfForChatUseCase;
  final SendPdfForChatUseCase sendPdfForChatUseCase;
  final DeleteChatBookUseCase deleteChatBookUseCase;
  final TabSController tabSController = Get.find<TabSController>();

  //Backend API Setup
  final ChatRequestUseCase chatRequestUseCase;
  final SetUpBookForChatUseCase setUpBookForChatUseCase;

  ChatTabController({
    required this.chatMessageUseCase,
    required this.uploadPdfForChatUseCase,
    required this.sendPdfForChatUseCase,
    required this.deleteChatBookUseCase,

    //Backend API Setup
    required this.chatRequestUseCase,
    required this.setUpBookForChatUseCase,
  });

  void addMessage(types.Message message) {
    messages.add(message);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    user = types.User(id: await getToken());
    bookUid.value = tabSController.fileUID.value;

    var message = const types.TextMessage(
      author: types.User(firstName: "", id: '123'),
      createdAt: 0,
      id: "123",
      text: "Hello! How can I assist you today?",
    );

    if(tabSController.isFilePicked.value){
      //By Gemini
      print("make ready book for backend chat");
      await uploadBookForChatNetwork(); // Await the async method
    }
    else if(tabSController.isAccetFilePicked.value){
      //By API
      print("Through api");
      sendPdfForChat();
    }

    messages.add(message);
  }

  @override
  void onClose() {
    bookLoad.value = false;
    sourceID.value = '';
    isLoading.value = true;
    bookUid.value = '';
    super.onClose();
  }

  //for upload pdf file handle
  Future<void> sendPdfForChat() async{
    if(tabSController.isAccetFilePicked.value) {
      bookLoad(false);
      try {
        Get.snackbar(
            "Mr.Chat is loading",
            "you get notify when it ready for chat",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorHandler.normalFont,
            colorText: Colors.white
        );

        final data = await sendPdfForChatUseCase.execute(
           file: tabSController.file!
        );


        if (data == null) {
          bookLoad.value = true;
          return null;
        } else {
          bookLoad.value = true;
          sourceID.value = data;
          Get.snackbar(
            "Mr.Chat is ready!",
            "Now you can chat with Mr.Chat",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );

        }
      } catch (e) {
        bookLoad.value = false;
        rethrow;
      }

    }

  }



  Future<String?> uploadBookForChatNetwork() async {
    if (sourceID.value.isEmpty) {
      bookLoad(false);
      try {
        Get.snackbar(
            "Mr.Chat is loading",
            "you get notify when it ready for chat",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorHandler.normalFont,
            colorText: Colors.white
        );



        // final data = await uploadPdfForChatUseCase.execute(
        //     bookUid: bookUid.value
        // );

        await setBookForChat();


        // if (data == null) {
        //   bookLoad.value = true;
        //   return null;
        // } else {
        //   bookLoad.value = true;
        //   sourceID.value = data;
        //   Get.snackbar(
        //     "Mr.Chat is ready!",
        //     "Now you can chat with Mr.Chat",
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.green,
        //   );
        //   return data;
        // }
      } catch (e) {
        bookLoad.value = false;
        rethrow;
      }
    }
  }

  Future<void> handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime
          .now()
          .millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    addMessage(textMessage);


    //For Gemini
    if(tabSController.isFilePicked.value) {
      await requestBookForChatToGemini(message.text);
    }else if(tabSController.isAccetFilePicked.value) {
      await requestBookForChat(message.text);
    }
  }

  Future<void> requestBookForChat(String message) async {
    if (sourceID.value.isNotEmpty) {
      try {
        final response = await chatMessageUseCase.execute(
            message: message, sourceID: sourceID.value);
        final responseMessage = types.TextMessage(
          author: types.User(id: response.sourceID ?? sourceID.value),
          createdAt: DateTime
              .now()
              .millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: response.text ?? "Something went wrong! Try again.",
        );
        addMessage(responseMessage);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('Failed to load response');
    }
  }


  //Backend setup for API

  Future<void> requestBookForChatToGemini(String message) async {
    if (sourceID.value.isEmpty) {
      try {
        final response = await chatRequestUseCase.execute(
            message: message, sourceID: sourceID.value, bookUid: bookUid.value);
        final responseMessage = types.TextMessage(
          author: types.User(id: response.sourceID ?? sourceID.value),
          createdAt: DateTime
              .now()
              .millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: response.text ?? "Something went wrong! Try again.",
        );
        addMessage(responseMessage);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('Failed to load response');
    }
  }


  Future<void> setBookForChat() async {
    try {
      final response = await setUpBookForChatUseCase.execute(
          bookUid: bookUid.value);
      print(response);
      if (response as bool) {
        bookLoad.value = true;
        Get.snackbar(
          "Mr.Chat is ready!",
          "Now you can chat with Mr.Chat",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else {
        print(response);
      }
    } catch (e) {
      rethrow;
    }
  }
}
