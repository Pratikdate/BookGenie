import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import '../Screens/ReadBook.dart';
import '../core/SnapShotHandler.dart';
import 'ReadBookController.dart';

class ChatScreenController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final types.User user = types.User(id: auth.currentUser!.uid);
  List<types.Message>  messages = <types.Message>[].obs;
  var bookLoad = false.obs;
  late String sourceID = '';
  var isLoading = true.obs;
  Uint8List? bytes;
  static String bookUid='';
  late String file;


  DateTime date = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day);

  final String apiUrl = "https://api.chatpdf.com/v1/sources/add-file";
  final Map<String, String> headers = {'x-api-key': 'sec_UF4cBRlukLSqvWOqbxIvLZs9pFPaKeGT'};

  //final ReadBookController controller = Get.put(ReadBookController());


  void addMessage(types.Message message) {
    messages.add(message);
  }

  @override
  void onInit() {
    super.onInit();
    fetchUrlfromNetwork(bookUid);
    _loadMessages();

  }




  @override
  void onClose() {
    for (dynamic item in messages) {
      _addMessageToFirestore(item);
    }
    super.onClose();
  }


  Future<void> fetchUrlfromNetwork(String pk) async {

    try{
      final response = await
      http.get(Uri.parse("http://192.168.233.145:8000/api/extractBooks/"+pk));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print(body);
        fetchPdfFromNetwork(body['book_file']);

      } else {
        print("else condition");
        // Handle error
      }
    }catch(e){
      print(e);

    }
  }


  Future<void> fetchPdfFromNetwork(String url) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse("http://192.168.233.145:8000/"+url));
      if (response.statusCode == 200) {
        bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        file = join(tempDir.path, 'downloaded.pdf');
        isLoading.value = false;
        update();
        sendBookRequest(file);

      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      isLoading.value = false;
      print("In catch section");
      rethrow;
    }
  }


  void _loadMessages() async {

    try {
      // Load user messages
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Messages')
          .doc(user.id + basename(ReadBookController.fileUrl))
          .collection("messages")
          .doc(auth.currentUser?.uid)
          .collection(date.toString())
          .get();

      for (var doc in querySnapshot.docs) {
        var message = types.TextMessage(
          author: types.User.fromJson(doc['author'] as Map<String, dynamic>),
          createdAt: doc["createdAt"],
          id: doc["id"],
          text: doc["text"],
        );
        messages.add(message);
      }

      // Load response messages
      querySnapshot = await FirebaseFirestore.instance
          .collection('Messages')
          .doc(user.id + ReadBookController.PDFFileBasename)
          .collection("messages")
          .doc(sourceID)
          .collection(date.toString())
          .get();

      for (var doc in querySnapshot.docs) {
        var message = types.TextMessage(
          author: types.User.fromJson(doc['author'] as Map<String, dynamic>),
          createdAt: doc["createdAt"],
          id: doc["id"],
          text: doc["text"],
        );
        messages.add(message);
      }
    } catch (e) {
      // Handle errors
    }
  }

  void _addMessageToFirestore(types.TextMessage message) async {
    final messageData = {
      "author": message.author.toJson(),
      'text': message.text,
      'createdAt': message.createdAt,
      "id": message.id,
    };

    await SnapShotHandler.SetData(
      FirebaseFirestore.instance
          .collection('Messages')
          .doc(user.id + basename(ReadBookController.fileUrl))
          .collection("messages")
          .doc(message.author.id)
          .collection(date.toString())
          .doc(message.id),
      messageData,
    );
    addMessage(message);
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    sendMessage(message.text);
    addMessage(textMessage);
  }

  Future<void> sendBookRequest(String file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('file', file));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        sourceID = jsonResponse['sourceId'];

        bookLoad.value = true;
      } else {
        print('Status: ${response.statusCode}');
        print('Error: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print("Book send request failed. ${e.toString()}");
      if (e.toString() == "Bad state: Stream has already been listened to.") {
        bookLoad.value = true;
      }
    }
  }

  Future<void> sendMessage(String message) async {
    if (sourceID.isNotEmpty) {
      final String apiUrl = 'https://api.chatpdf.com/v1/chats/message';
      final Map<String, String> headers = {
        'x-api-key': 'sec_UF4cBRlukLSqvWOqbxIvLZs9pFPaKeGT',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> data = {
        'sourceId': sourceID,
        'messages': [
          {
            'role': 'user',
            'content': message,
          },
        ],
      };

      try {
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final botUser = types.User(id: sourceID);
          final textMessage = types.TextMessage(
            author: botUser,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: jsonDecode(response.body)['content'],
          );
          addMessage(textMessage);
        } else {
          print('Status: ${response.statusCode}');
          print('Error: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> deleteBook() async {
    if (sourceID.isNotEmpty) {
      var response = await http.post(
        Uri.parse("https://api.chatpdf.com/v1/sources/delete"),
        headers: {
          'x-api-key': 'sec_UF4cBRlukLSqvWOqbxIvLZs9pFPaKeGT',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'sources': sourceID}),
      );

      if (response.statusCode == 200) {
        print("Request successful!");
      } else {
        print("Request failed with status code: ${response.statusCode}");
      }
    }
  }
}


