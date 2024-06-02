import 'dart:convert';
import 'package:get/get.dart';
import '../Controller/BookStoreController.dart';
import 'package:http/http.dart' as http;

class BookStoreModel {


  static Future<void> BookShelfModel()async{
    final BookStoreController controller = Get.put(BookStoreController());

    controller.isLoading.value = true;

    try{
      final response = await
      http.get(Uri.parse('http://192.168.233.145:8000/api/shelfbooks/'));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Do something with the response data

        for(int Index=0;Index<5;Index++){
          controller.booksInShelf[Index]=Book(uid:body[Index]['uid'],name: body[Index]['title'], author:body[Index]['author'], progress: 0, image: 'http://192.168.233.145:8000/'+body[Index]['frontal_page'],fileUrl: body[Index]['book_file']);
        }




      } else {
        print("else condition");
        // Handle error
      }
    }catch(e){
      print(e);

    }

  }

  static Future<void> booksInPopularModel()async{
    final BookStoreController controller = Get.put(BookStoreController());
    controller.isLoading.value = true;


    try{
      final response = await
      http.get(Uri.parse('http://192.168.233.145:8000/api/popularbooks/'));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Do something with the response data

        for(int Index=0;Index<5;Index++){
          controller.booksInPopular[Index]=Book(uid:body[Index]['uid'],name: body[Index]['title'], author:body[Index]['author'], progress: 0, image: 'http://192.168.233.145:8000/'+body[Index]['frontal_page'],fileUrl: body[Index]['book_file']);
        }




      } else {
        print("else condition");
        // Handle error
      }
    }catch(e){
      print(e);

    }

  }

}