import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/params/params.dart';
import '../models/chat_model.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource();

  Future<ChatModel> getChat(ChatParams params) async {
    final url = Uri.parse(
      'https://g6-worrymate-zt0r.onrender.com/chat/intent_mapping',
    );
    print('[ChatRemoteDataSource] Sending GET to /chat/intent_mapping');
    final response = await http.get(url);
    print('[ChatRemoteDataSource] GET response: ' + response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ChatModel.fromJson(data);
    } else {
      print(
        '[ChatRemoteDataSource] Error: GET failed with status ${response.statusCode}',
      );
      throw Exception('Failed to load chat intent mapping');
    }
  }

  Future<int> addChat(ChatParams params) async {
    try {
      final url = Uri.parse(
        'https://g6-worrymate-zt0r.onrender.com/chat/risk_check',
      );
      print(
        '[ChatRemoteDataSource] Sending POST to /chat/risk_check with content: ' +
            params.content,
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
