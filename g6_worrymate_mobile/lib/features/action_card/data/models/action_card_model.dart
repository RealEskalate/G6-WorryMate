import 'dart:convert';

class ActionCardModel {
  final String title;
  final String description;
  final List<ActionStepModel> steps;
  final List<ToolLinkModel> miniTools;
  final String ifWorse;
  final String disclaimer;

  ActionCardModel({
    required this.title,
    required this.description,
    required this.steps,
    required this.miniTools,
    required this.ifWorse,
    required this.disclaimer,
  });

  factory ActionCardModel.fromJson(Map<String, dynamic> json) {
    // The 'card' field is a JSON string containing another JSON object
    String cardString = json['card'] ?? '';
    cardString = cardString
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final Map<String, dynamic> cardMap = jsonDecode(cardString);
    final cardData = cardMap.values.first as Map<String, dynamic>;

    return ActionCardModel(
      title: cardData['title'] ?? '',
      description: cardData['description'] ?? '',
      steps: (cardData['steps'] as List? ?? [])
          .map((e) => ActionStepModel.fromJson(e))
          .toList(),
      miniTools: (cardData['miniTools'] as List? ?? [])
          .map((e) => ToolLinkModel.fromJson(e))
          .toList(),
      ifWorse: cardData['ifWorse'] ?? '',
      disclaimer: cardData['disclaimer'] ?? '',
    );
  }

   Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'steps': steps.map((e) => e.toJson()).toList(),
    'miniTools': miniTools.map((e) => e.toJson()).toList(),
    'ifWorse': ifWorse,
    'disclaimer': disclaimer,
  };

}

class ActionStepModel {
  final String title;
  final String description;

  ActionStepModel({required this.title, required this.description});

  factory ActionStepModel.fromJson(Map<String, dynamic> json) {
    return ActionStepModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}

class ToolLinkModel {
  final String title;
  final String url;

  ToolLinkModel({required this.title, required this.url});

  factory ToolLinkModel.fromJson(Map<String, dynamic> json) {
    return ToolLinkModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
      };
}