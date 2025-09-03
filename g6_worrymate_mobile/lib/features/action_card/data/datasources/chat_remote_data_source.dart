import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/params/params.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource();

  Future<String> getTopicKey(ChatParams params) async {
    final url = Uri.parse(
      'https://g6-worrymate-8osd.onrender.com/chat/intent_mapping',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': params.content}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("topic key endpoint hitted.");
      final topicKey = data['topic_key'];
      if (topicKey != null && topicKey is String) {
        print("got topic key successfully $topicKey");
        return topicKey;
      } else {
        print("didn't get topic key");
        throw Exception('topic_key missing or not a string in response');
      }
    } else {
      throw Exception('Failed to load chat intent mapping');
    }
  }

  Future<int> addChat(ChatParams params) async {
    try {
      final url = Uri.parse(
        'https://g6-worrymate-zt0r.onrender.com/chat/risk_check',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'content': params.content}),
      );
      print('[ChatRemoteDataSource] POST response: ' + response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final dynamic riskRaw = data['risk'];
        int? risk;
        if (riskRaw is int) {
          risk = riskRaw;
        } else if (riskRaw is String) {
          risk = int.tryParse(riskRaw);
        }
        if (risk != null) {
          print('[ChatRemoteDataSource] Parsed risk: ' + risk.toString());
          return risk;
        } else {
          print('[ChatRemoteDataSource] Error: Risk value is not a valid int');
          throw Exception('Risk value is not a valid int');
        }
      } else {
        print(
          '[ChatRemoteDataSource] Error: POST failed with status ${response.statusCode}',
        );
        throw Exception('Failed to get risk from API');
      }
    } catch (e, stack) {
      print('[ChatRemoteDataSource] Exception: ' + e.toString());
      print(stack);
      rethrow;
    }
  }
}
