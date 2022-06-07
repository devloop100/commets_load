import 'dart:convert';
import 'dart:io';

import 'package:comments/app/models/comment_model.dart';
import 'package:comments/main.dart';
import 'package:http/http.dart' as http;

// class for remote api to fetch the comments from the server and return the list of comments
// ignore: avoid_classes_with_only_static_members
class RemoteApi {
  static Future<List<CommentModel>> getCommentsList(
          int offset, int limit) async =>
      http
          .get(
            _ApiUrlBuilder.commentsList(offset, limit),
          )
          .mapFromResponse<List<CommentModel>, List<dynamic>>(
            (jsonArray) => _parseItemListFromJsonArray(
              jsonArray,
              (jsonObject) => CommentModel.fromJson(jsonObject),
            ),
          );

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

// build the url to fetch the comments list from the api server with the given offset and limit
// ignore: avoid_classes_with_only_static_members
class _ApiUrlBuilder {
  static Uri commentsList(
    int offset,
    int limit,
  ) =>
      Uri.parse(
        '$baseUrl?'
        '_page=$offset'
        '&_limit=$limit',
      );
}

// map the response from the api server to a list of items or throw an exception if the response is not valid
extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}
