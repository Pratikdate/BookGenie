
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../Auth/Tokens.dart';
import '../../../../../core/utils/constants.dart';
import '../../models/bookmark_model.dart';




class RemoteBookmarkDataSource {
  final http.Client client;

  RemoteBookmarkDataSource({required this.client});



  Future<List<BookmarkModel>> fetchListBookmarksDataSource() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/api/bookmarks/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        print(body[0][0]);
        return body.map((book)=>BookmarkModel(
          uid: book[0][0],
          title: book[0][1],
          author: book[0][2],
          views: book[0][3].toString(),
          genre: book[0][4],
          publication_date: book[0][5],
          frontal_page: book[0][6],
          book_file: book[0][7],
          description: book[0][8],
        )).toList();

      }
      else {
        return <BookmarkModel>[].toList();
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      rethrow;
    }
  }



  Future<List<dynamic>> FetchBookmarksDataSource({required String fileUID}) async {
    try {
      final response = await http.get(Uri.parse('${Constants.BASE_URL}/api/bookmarks/${fileUID}'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}', // Pass token if needed
      });
      if (response.statusCode == 200) {
        final  body = json.decode(response.body);

        return List<dynamic>.from(body);

      } else {
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> SetBookmarksDataSource(String fileUID,String name,int page ,[String? description]) async {

    try {
      final response = await http.post(Uri.parse('${Constants.BASE_URL}/api/bookmarks/$fileUID'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}', // Pass token if needed
      }, body: json.encode({
        "title": name,
        "description": description,
        'page': page,
      }));
      if (response.statusCode == 201) {
        return true;

      } else {
        throw Exception('Failed to set bookmark');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> DeleteBookmarkDataSource(String uid) async {

    try {
      final response = await http.delete(Uri.parse('${Constants.BASE_URL}/api/bookmarks/$uid'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}', // Pass token if needed
      });

      if (response.statusCode == 200) {
        return true;

      } else {
        throw Exception('Failed to delete bookmark');
      }
    } catch (e) {
      rethrow;
    }

  }



}