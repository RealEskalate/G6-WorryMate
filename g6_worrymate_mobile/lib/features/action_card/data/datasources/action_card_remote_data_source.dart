import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/action_card_model.dart';

class ActionCardRemoteDataSource {
  Future<ActionCardModel> composeActionCard({
    required String topicKey,
    required Map<String, dynamic> block,
    required String language,
  }) async {
    final url = Uri.parse(
      'https://g6-worrymate-zt0r.onrender.com/chat/compose',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'topic_key': topicKey,
        'block': block,
        'language': language,
      }),
    );
    print(
      '[ActionCardRemoteDataSource] Status: ${response.statusCode}, Body: ${response.body}',
    );
    if (response.statusCode == 200) {
      print('i have reached the action card endpoint: ${response.body}');
      return ActionCardModel.fromJson(json.decode(response.body));
    } else {
      print("am not able to fetch the action card");
      throw Exception('Failed to compose action card');
    }
  }
}
