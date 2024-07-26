

class Bookmark {
  final String? uid;
  final String? bookmarkId;
  final String? author;
  final String? views;
  final String? genre;
  final String? publication_date;
  final String? frontal_page;
  final String? book_file;
  final String? title ;
  final String? description;
  final int?  page;
  final String? created_at;


  Bookmark(
      { this.uid, this.bookmarkId, this.title, this.description, this.page, this.created_at,this.author, this.views, this.genre, this.publication_date, this.frontal_page, this.book_file,

      });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      uid: json['uid'] ?? '',
      bookmarkId: json["bookmarkId"],
      page: json['page'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      created_at: json['created_at'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'bookmarkId': bookmarkId,
      'title':title,
      'description': description,
      'page': page,
      'created_at':created_at,

    };
  }

}