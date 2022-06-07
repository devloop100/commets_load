import 'package:comments/app/screens/add_comment_view.dart';
import 'package:flutter/material.dart';

import 'app/screens/comment_list_view.dart';

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

  // navigate to add comment page
  void _onAddButtonPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const AddCommentView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Infinite Scroll Pagination',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          subtitle1: TextStyle(),
          subtitle2: TextStyle(),
          headline1: TextStyle(),
          headline2: TextStyle(),
          headline3: TextStyle(),
          headline4: TextStyle(),
          headline5: TextStyle(),
          headline6: TextStyle(),
          caption: TextStyle(),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
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
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: (() => _onAddButtonPressed(context)),
            tooltip: 'Add Comment',
            child: const Icon(Icons.add),
          );
        }),
        body: CommentsListView(
          key: _commentsListKey,
        ),
      ));
}
