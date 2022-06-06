import 'dart:convert';
import 'dart:io';

import 'package:comments/main.dart';
import 'package:comments/presentation/models/comment_model.dart';
import 'package:http/http.dart' as http;

// ignore: avoid_classes_with_only_static_members
class RemoteApi {
  static Future<List<CommentModel>> getCharacterList(
          int offset, int limit) async =>
      http
          .get(
            _ApiUrlBuilder.characterList(offset, limit),
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

// ignore: avoid_classes_with_only_static_members
class _ApiUrlBuilder {
  static Uri characterList(
    int offset,
    int limit,
  ) =>
      Uri.parse(
        '$baseUrl?'
        '_page=$offset'
        '&_limit=$limit',
      );
}

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
