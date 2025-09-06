import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/action_block_model.dart';

class ActionBlockRemoteDataSource {
  String _formatTopicKey(String topicKey) {
    return topicKey.trim().toLowerCase().replaceAll(' ', '_');
  }

  Future<ActionBlockResponseModel> getActionBlock(
    String topicKey,
    String lang,
  ) async {
    final formattedTopicKey = _formatTopicKey(topicKey);
    final url = Uri.parse(
      'https://g6-worrymate-8osd.onrender.com/chat/action_block/$formattedTopicKey/$lang',
    );

    final response = await http.get(url);
    print('[ActionBlockRemoteDataSource] Requested URL: $url');
    print('[ActionBlockRemoteDataSource] Status code: ${response.statusCode}');
    print('[ActionBlockRemoteDataSource] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[ActionBlockRemoteDataSource] Parsed data: $data');

      return ActionBlockResponseModel.fromJson(data);
    } else {
      print(
        '[ActionBlockRemoteDataSource] Error: Failed to load action block, status: ${response.statusCode}',
      );
      throw Exception('Failed to load action block: ${response.statusCode}');
    }
  }
}
