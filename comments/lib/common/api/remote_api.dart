import 'dart:io';

import 'package:comments/app/models/comment_model.dart';
import 'package:dio/dio.dart';

const baseUrlComments = 'https://jsonplaceholder.typicode.com/comments/';
const baseUrlPostComment = 'https://algoretail.co.il/test/testAssignComment';

// class for remote api calls
// ignore: avoid_classes_with_only_static_members
class RemoteApi {
  // to fetch the comments from the server and return the list of comments
  static Future<List<CommentModel>> getCommentsList(
      int offset, int limit) async {
    try {
      // build the url to fetch the comments list from the api server with the given offset and limit
      var response = await Dio().get(baseUrlComments,
          queryParameters: {'_page': offset, '_limit': limit});
      // map the response from the api server to a list of items or throw an exception if the response is not valid
      if (response.statusCode == HttpStatus.ok) {
        return _parseItemListFromJsonArray(
          response.data,
          (jsonObject) => CommentModel.fromJson(jsonObject),
        );
      } else {
        throw GenericHttpException;
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }

  // to send comment to the server and return the comment id
  static Future<int> sendComment(String comment) async {
    try {
      // build the url to send the comment to the api server with the given comment
      var response = await Dio().post(
        baseUrlPostComment,
        data: {'comment': comment},
      );
      // map the response from the api server to a comment id or throw an exception if the response is not valid
      if (response.statusCode == HttpStatus.ok) {
        return response.data as int;
      } else {
        throw GenericHttpException;
      }
      // uncomment to see a successful response
      // return Future.delayed(const Duration(seconds: 1), () => 1);
    } on SocketException {
      throw NoConnectionException();
    }
  }

  // helper method to parse the json array to a list of items
  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}
