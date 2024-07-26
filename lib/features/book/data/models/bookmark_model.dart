



class BookmarkModel {
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


  BookmarkModel(
      { this.uid, this.bookmarkId, this.title, this.description, this.page, this.created_at,this.author, this.views, this.genre, this.publication_date, this.frontal_page, this.book_file,

      });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      uid: json['uid'],
      bookmarkId: json['bookmarkId'],
      title: json['title'],
      description: json['description'],
      page: json['page'],
      created_at: json['reated_at'],
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
