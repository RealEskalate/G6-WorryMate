import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/params/params.dart';
import 'chat_local_data_source.dart';

class NormalChatRemoteDataSource {
  final ChatLocalDataSource chatLocalDataSource;
  NormalChatRemoteDataSource({required this.chatLocalDataSource});

  Future<dynamic> getNormalChat(ChatParams params) async {
    final contextString = await chatLocalDataSource
        .getLastFiveUserMessagesConcatenated();
    final url = Uri.parse('https://g6-worrymate-8osd.onrender.com/chat/normal');

    try {
      print(
        "[NormalChatRemoteDataSource] User message before API call: ${params.content}",
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': params.content,
          'context': contextString,
        }),
      );
      print("what i sent to the backend :${params.content}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Api response: $data");
        final chat_response = data['ai_response'];
        print("Chat ai response: $chat_response");
        return chat_response;
      } else {
        print("Never got the response, nore hitted the end point");
        throw Exception('Failed to get chat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
