





class ExtractedBookModel {
  final String? uid;
  final String? book;
  final String? title ;



  ExtractedBookModel(
      { this.uid, this.book, this.title,
      });

  factory ExtractedBookModel.fromJson(Map<String, dynamic> json) {
    return ExtractedBookModel(
      uid: json['uid'],
      book: json['book'],
      title: json['title'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'book': book,
      'title':title,

    };
  }
}
