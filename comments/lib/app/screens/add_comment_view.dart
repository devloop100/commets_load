import 'package:flutter/material.dart';

class AddCommentView extends StatelessWidget {
  const AddCommentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Comment'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(),
    );
  }
}
