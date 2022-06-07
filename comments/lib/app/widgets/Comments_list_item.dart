import 'package:comments/app/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

/// List item representing a single comment.
class CommentsListItem extends StatelessWidget {
  const CommentsListItem({
    required this.model,
    Key? key,
  }) : super(key: key);

  final CommentModel model;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 20,
              child: randomAvatar(
                model.id.toString(),
                height: 35,
                width: 35,
              ),
            ),
            Text(model.id.toString()),
          ],
        ),
        title: Text.rich(
          TextSpan(text: model.name, children: [
            TextSpan(
              text: "\n${model.email}",
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 206, 206, 206)),
            )
          ]),
        ),
        subtitle: Text(
          model.body,
          style: const TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 235, 235, 235)),
        ),
      );
}
