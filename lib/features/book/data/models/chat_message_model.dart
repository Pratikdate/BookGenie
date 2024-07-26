




class ChatModel {
  final String? sourceID;
  final int? createdAt;
  final String? id ;
  final String? text;



  ChatModel(
      { this.sourceID, this.createdAt, this.id, this.text,

      });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      sourceID: json['sourceID'],
      createdAt: json['createdAt'],
      id: json['id'],
      text: json['text'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceID': sourceID,
      'bookmarkId': createdAt,
      'id':id,
      'text': text,

    };
  }
}
