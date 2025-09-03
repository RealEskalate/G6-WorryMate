import 'dart:convert';

class ActionCardModel {
  final String title;
  final String description;
  final List<String> steps;
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
    final cardString = json['card'] as String;
    final cardJson = cardString
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    final Map<String, dynamic> cardMap = cardJson.isNotEmpty
        ? Map<String, dynamic>.from(
            (cardString.contains('{'))
                ? (cardString.contains('"'))
                      ? (cardString.contains('\\n'))
                            ? jsonDecode(
                                cardString
                                    .replaceAll('```json', '')
                                    .replaceAll('```', ''),
                              )
                            : jsonDecode(cardJson)
                      : {}
                : {},
          )
        : {};
    final cardData = cardMap.values.first as Map<String, dynamic>;
    return ActionCardModel(
      title: cardData['title'] ?? '',
      description: cardData['description'] ?? '',
      steps: List<String>.from(cardData['steps'] ?? []),
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
    'steps': steps,
    'miniTools': miniTools.map((e) => e.toJson()).toList(),
    'ifWorse': ifWorse,
    'disclaimer': disclaimer,
  };

  // Add toEntity() if needed
}

class ToolLinkModel {
  final String title;
  final String url;

  ToolLinkModel({required this.title, required this.url});

  factory ToolLinkModel.fromJson(Map<String, dynamic> json) {
    return ToolLinkModel(title: json['title'] ?? '', url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {'title': title, 'url': url};
}
