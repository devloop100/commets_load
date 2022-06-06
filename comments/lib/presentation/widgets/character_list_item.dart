import 'package:comments/presentation/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

/// List item representing a single Character with its photo and name.
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
            randomAvatar(
              model.id.toString(),
              height: 35,
              width: 35,
            ),
            Text(model.id.toString()),
          ],
        ),
        title: Text.rich(
          TextSpan(text: model.name, children: [
            TextSpan(
                text: "\n${model.email}", style: const TextStyle(fontSize: 10))
          ]),
        ),
        subtitle: Text(model.body),
      );
}
