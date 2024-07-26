import '../../../../core/utils/constants.dart';

class Book {
  final String uid;
  final String name;
  final String author;
  final String image;
  final String fileUrl;
  final String? description;
  final String? published;

  Book({
    required this.uid,
    required this.name,
    required this.author,
    required this.image,
    required this.fileUrl,
    this.description,
    this.published,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      uid: json['uid'] ?? '',
      name: json['title'] ?? '',
      author: json['author'] ?? '',
      image: "${Constants.BASE_URL}/${json['frontal_page']}" ?? '',
      fileUrl: "${Constants.BASE_URL}/${json['book_file']}" ?? '',
      description: json['description'] ?? '',
      published: json['publication_date'] ?? '',
    );
  }


}
