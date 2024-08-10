
import 'package:bookapp/features/book/domain/usecases/chat_usecase.dart';
import 'package:bookapp/features/book/presentation/controllers/chat_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';


class ChatTabViewScreen extends StatefulWidget {
  const ChatTabViewScreen({super.key});

  @override
  State<ChatTabViewScreen> createState() => _ChatTabViewScreenState();
}

class _ChatTabViewScreenState extends State<ChatTabViewScreen> {

  late final ChatTabController controller;
  @override
  void initState() {
    super.initState();
   controller = Get.find<ChatTabController>();
    //controller.uploadBookForChatNetwork();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() {
        if (controller.bookLoad.value) {
          return Chat(
            messages: controller.messages.reversed.toList(),
            onSendPressed: controller.handleSendPressed,
            bubbleBuilder: _bubbleBuilder,
            showUserAvatars: false,
            showUserNames: false,
            user: controller.user,
            theme: const DefaultChatTheme(
              seenIcon: Text(
                'read',
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,));
        }
      }),
    );
  }

  Widget _bubbleBuilder(
      Widget child, {
        required types.Message message,
        required bool nextMessageInGroup,
      }) {
    final ChatTabController controller = Get.find();

    return Bubble(
      color: controller.user.id != message.author.id ||
          message.type == types.MessageType.image
          ? const Color(0xffa29ae1) // Color for other user's messages
          : const Color(0xff6f61e8), // Color for current user's messages
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : controller.user.id != message.author.id
          ? BubbleNip.leftTop
          : BubbleNip.rightTop,
      alignment: controller.user.id != message.author.id
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      padding: const BubbleEdges.all(8), // Padding for the bubble
      radius: const Radius.circular(20), // Border radius for the bubble
      nipWidth: 8, // Width of the arrow
      nipHeight: 16, // Height of the arrow
      nipRadius: 2, // Radius of the arrow
      elevation: 3,
      nipOffset: 0,
      borderUp: true,
      child: child,
    );
  }
}
