import 'dart:convert';
import 'package:get/get.dart';
import '../Auth/Tokens.dart';
import '../Controller/BookStoreController.dart';
import 'package:http/http.dart' as http;

class BookStoreModel {

  static Future<void> BookShelfModel({count=3})async{

    final BookStoreController controller = Get.put(BookStoreController());

    controller.isLoading.value = true;


    try{
      final response = await
      http.get(Uri.parse('${BookStoreController.BASE_URL}/api/shelfbooks/$count'),headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}' , // Pass token if needed
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Do something with the response data

        for(int Index=0;Index<3;Index++){
          if(count==3){
            controller.booksInShelf[Index]=Book(uid:body[Index]['uid'],name: body[Index]['title'], author:body[Index]['author'], progress: 0, image: "${BookStoreController.BASE_URL}/"+body[Index]['frontal_page'],fileUrl: body[Index]['book_file']);
          }
          else{
            controller.booksInShelf.add(Book(uid:body[Index]['uid'],name: body[Index]['title'], author:body[Index]['author'], progress: 0, image: "${BookStoreController.BASE_URL}/"+body[Index]['frontal_page'],fileUrl: body[Index]['book_file']));
          }

        }




      } else if(response.statusCode == 204){
        print("data not found");
        // Handle error
      }
    }catch(e){
      print(e);

    }

  }

  static Future<void> booksInPopularModel({count=3})async{
    final BookStoreController controller = Get.put(BookStoreController());
    controller.isLoading.value = true;


    try{
      final response = await
      http.get(Uri.parse('${BookStoreController.BASE_URL}/api/popularbooks/$count'),headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}' , // Pass token if needed
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Do something with the response data

        for(int Index=0;Index<3;Index++){
          if(count==3){
            controller.booksInPopular[Index]=Book(uid:body[Index]['uid'],name: body[Index]['title'], author:body[Index]['author'], progress: 0, image: "${BookStoreController.BASE_URL}/"+body[Index]['frontal_page'],fileUrl: body[Index]['book_file']);
          }
          else{
            controller.booksInPopular.add(Book(uid:body[Index]['uid'],name: body[Index]['title'], author:body[Index]['author'], progress: 0, image: "${BookStoreController.BASE_URL}/"+body[Index]['frontal_page'],fileUrl: body[Index]['book_file']));
          }
        }




      } else if(response.statusCode == 204){
        print("data not found");
        // Handle error
      }
    }catch(e){
      print(e);

    }

  }

}