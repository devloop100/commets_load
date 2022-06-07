import 'dart:io';

import 'package:comments/app/models/comment_model.dart';
import 'package:comments/main.dart';
import 'package:dio/dio.dart';

// class for remote api to fetch the comments from the server and return the list of comments
// ignore: avoid_classes_with_only_static_members
class RemoteApi {
  static Future<List<CommentModel>> getCommentsList(
      int offset, int limit) async {
    try {
      // map the response from the api server to a list of items or throw an exception if the response is not valid
      var response = await Dio().get(
        commentsListUrl(offset, limit),
      );
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

  // helper method to parse the json array to a list of items
  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();

  // build the url to fetch the comments list from the api server with the given offset and limit
  static String commentsListUrl(
    int offset,
    int limit,
  ) =>
      '$baseUrl?'
      '_page=$offset'
      '&_limit=$limit';
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}
