import 'package:comments/common/api/remote_api.dart';
import 'package:comments/common/widgets/text_direction.dart';
import 'package:flutter/material.dart';

enum PostSendState {
  idle,
  sending,
  success,
  error,
}

class AddCommentView extends StatefulWidget {
  const AddCommentView({Key? key}) : super(key: key);

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  var postSendState = PostSendState.idle;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _textUpdated();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendComment() async {
    try {
      final text = _controller.text;
      if (text.isEmpty) {
        _showEnterCommentMessage();
        return;
      }

      setState(() {
        postSendState = PostSendState.sending;
      });

      var response = await RemoteApi.sendComment(text);
      _success();
    } catch (error) {
      _failure();
    }
  }

  void _success() {
    setState(() {
      postSendState = PostSendState.success;
      _controller.clear();
      _focusNode.unfocus();
    });
  }

  void _failure() {
    setState(() {
      postSendState = PostSendState.error;
    });
  }

  // update the state when text is change so the auto direction can be updated
  void _textUpdated() {
    setState(() {});
  }

  void _showEnterCommentMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("please enter your comment"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 2 - 100,
            right: 20,
            left: 20),
      ),
    );
  }

  void _onConfirm() {
    Navigator.of(context).pop();
  }

  void _tryAgain() {
    setState(() {
      postSendState = PostSendState.idle;
    });
  }

  Widget _buildBody() {
    switch (postSendState) {
      case PostSendState.idle:
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                padding: const EdgeInsets.all(16),
                child: AutoDirection(
                  text: _controller.text,
                  child: TextFormField(
                    focusNode: _focusNode,
                    autofocus: true,
                    controller: _controller,
                    maxLines: 12,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _sendComment,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Send Comment'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.send)
                  ],
                ),
              ),
            ],
          ),
        );
      case PostSendState.sending:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case PostSendState.success:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Comment sent successfully',
                  style: TextStyle(color: Colors.black, fontSize: 25)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _onConfirm,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Confirm'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.send)
                  ],
                ),
              ),
            ],
          ),
        );
      case PostSendState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Error sending comment',
                  style: TextStyle(color: Colors.black, fontSize: 25)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _tryAgain,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Try Again'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.refresh)
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Comment'),
      ),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
}
