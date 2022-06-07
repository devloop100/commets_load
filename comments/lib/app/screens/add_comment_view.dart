import 'package:comments/common/widgets/text_direction.dart';
import 'package:flutter/material.dart';

class AddCommentView extends StatefulWidget {
  const AddCommentView({Key? key}) : super(key: key);

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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

  // update the state when text is change so the auto direction can be updated
  void _textUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Comment'),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
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
            onPressed: () {
              setState(() {
                // _futureAlbum = createAlbum(_controller.text);
              });
            },
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
  }
}
