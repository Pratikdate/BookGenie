import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../../../../../core/Tokens.dart';
import '../../../../../core/utils/constants.dart';

class RemoteBookDataSource {
  final http.Client client;

  RemoteBookDataSource({required this.client});

  Future<List<Map<String, dynamic>>> bookShelfDataSource({int count = 3}) async {
    try {
      final response = await http.get(Uri.parse('${Constants.BASE_URL}/api/shelfbooks/$count'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}',
      });

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);

        return List<Map<String, dynamic>>.from(body);
      } else {
        throw Exception('Failed to load bookshelf data');
      }
    } catch (e) {
      print("Data not found");
      return List<Map<String, dynamic>>.from({});
    }

  }

  Future<List<Map<String, dynamic>>> booksInPopularDataSource({int count = 3}) async {
    try {
      final response = await http.get(Uri.parse('${Constants.BASE_URL}/api/popularbooks/$count'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}',
      });

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return List<Map<String, dynamic>>.from(body);
      } else {
        throw Exception('Failed to load popular books data');
      }
    } catch (e) {
      print("Data not found");
      return List<Map<String, dynamic>>.from({});
    }
  }

  Future<File> fetchPdfFromNetwork({required String fileUrl}) async {
    try {
      final response = await http.get(Uri.parse(fileUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}',
      });

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File(join(tempDir.path, 'downloaded.pdf'));
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      rethrow;
    }
  }
}
