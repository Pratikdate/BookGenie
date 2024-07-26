


class BookModel {
  final String? uid;
  final String? name;
  final String? author;
  final String? description;
  final String? image;
  final String? fileUrl;
  final String? price;
  final double? rating;
  final String? published;

  BookModel(
      {required this.name,
      required this.author,
      required this.image,
      this.description,
      this.price,
      this.published,
      this.uid,
      this.rating ,
      this.fileUrl });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      uid: json['uid'],
      name: json['name'],
      author: json['author'],
      description: json['description'],
      image: json['image'],
      fileUrl: json['fileUrl'],
      price: json['price'],
      rating: json['rating'],
      published: json['published'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'author': author,
      'description': description,
      'image': image,
      'fileUrl':fileUrl,
      'price':price,
      'rating':rating,
      'published': published,
    };
  }
}
