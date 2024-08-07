import 'dart:convert';
import 'dart:io';
import 'package:bookapp/features/book/data/models/chat_message_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:bookapp/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../../../../../core/Tokens.dart';

class RemoteChatApiDataSource {
  final http.Client client;

  RemoteChatApiDataSource({required this.client});

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final String apiUrl = "https://api.chatpdf.com/v1/sources/add-file";
  final Map<String, String> headers = {'x-api-key': "sec_UF4cBRlukLSqvWOqbxIvLZs9pFPaKeGT"};

  Future<dynamic> fetchUrlfromNetwork({required String bookUid}) async {
    try {
      final response = await http.get(
        Uri.parse("${Constants.BASE_URL}/api/extractBooks/${bookUid}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        return await fetchPdfFromNetwork(body['book_file']);
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchPdfFromNetwork(String url) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        File file = File(join(tempDir.path, 'downloaded.pdf'));
        await file.writeAsBytes(bytes);  // Save the downloaded bytes to the file
        return await sendBookRequest(file.path);
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      rethrow;
    }
  }




  Future<String?> sendBookRequest(String file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('file', file));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print(jsonResponse);
        return jsonResponse['sourceId'].toString();
      } else {
        print('Status: ${response.statusCode}');
        print('Error: ${await response.stream.bytesToString()}');
        return null;
      }
    } catch (e) {
      print("Book send request failed. ${e.toString()}");
      return null;
    }
  }



  Future<ChatModel> sendMessage({required String message, required String sourceID}) async {
    final String apiUrl = 'https://api.chatpdf.com/v1/chats/message';
    final Map<String, String> headers = {
      'x-api-key': "sec_UF4cBRlukLSqvWOqbxIvLZs9pFPaKeGT",
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
        final body = jsonDecode(response.body);
        return ChatModel(
          sourceID: sourceID,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: body['content'],
        );
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteBook({required String sourceID}) async {
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
        return true;
      } else {
        print("Request failed with status code: ${response.statusCode}");
        return false;
      }
    }
    return false;
  }





  //Request for setup the backend environment for chat with book

  Future<bool?> setupBookForChat({required String bookUid}) async {
    try {

        final response = await http.get(
          Uri.parse('${Constants.BASE_URL}/chatapi/chatpdf/${bookUid}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ${await getToken()}',
          },
        );

        if (response.statusCode == 200) {
          return true;
        }
        return false;

    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> sendRequest({required String message, required String sourceID,required,required String bookUid}) async {

    final String apiUrl = '${Constants.BASE_URL}/chatapi/chatpdf/$bookUid';
    final Map<String, String> headers = {

      'Authorization': 'Token ${await getToken()}',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> data = {
      'content': message
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return ChatModel(
          sourceID: sourceID,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: body['content'],
        );
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      rethrow;
    }
  }

















}
