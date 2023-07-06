import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String? messageId;
  String? userId;
  String? content;
  String? pathContent;
  int? contentAt;

  Message({
    this.messageId,
    this.userId,
    this.content,
    this.pathContent,
    this.contentAt,
  });

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String? messageId, Map<dynamic, dynamic> json) {
    return Message(
      messageId: messageId,
      userId: json['userId'],
      content: json['content'],
      pathContent: json['pathContent'],
      contentAt: json['contentAt'],
    );
  }

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'userId': userId,
      'content': content,
      'pathContent': pathContent,
      'contentAt': contentAt,
    };
  }

  factory Message.fromMap(String? messageId, Map<dynamic, dynamic> map) {
    return Message(
      messageId: messageId,
      userId: map['userId'],
      content: map['content'],
      pathContent: map['pathContent'],
      contentAt: map['contentAt'],
    );
  }

  @override
  String toString() {
    return 'Message(messageId: $messageId, userId: $userId, content: $content, pathContent: $pathContent, contentAt: $contentAt)';
  }

  String createAtString() {
    var res = "";
    if (contentAt != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(contentAt!);
      res = "${date.day}/${date.month}/${date.year}";
    }
    return res;
  }
}
