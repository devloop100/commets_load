/// Summarized information of a comment.
class CommentModel {
  CommentModel({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'],
        postId: json['postId'],
        name: json['name'],
        email: json['email'],
        body: json['body'],
      );
}
