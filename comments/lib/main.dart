import 'package:comments/presentation/screens/comment_list_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const baseUrl = 'https://jsonplaceholder.typicode.com/comments/';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // key for refreshing the list
  GlobalKey _commentsListKey = GlobalKey();

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Infinite Scroll Pagination',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          leading: InkWell(
            onTap: () {
              setState(() {
                _commentsListKey = GlobalKey();
              });
            },
            child: const Icon(Icons.refresh),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: CommentsListView(
          key: _commentsListKey,
        ),
      ));
}
