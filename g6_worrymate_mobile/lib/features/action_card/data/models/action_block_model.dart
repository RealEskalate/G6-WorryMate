class ActionBlockResponseModel {
  final ActionBlockModel actionBlock;

  ActionBlockResponseModel({required this.actionBlock});

  factory ActionBlockResponseModel.fromJson(Map<String, dynamic> json) {
    // Pass the whole JSON, not json['action-block']
    return ActionBlockResponseModel(
      actionBlock: ActionBlockModel.fromJson(json),
    );
  }
}

class ActionBlockModel {
  final String topicKey;
  final BlockModel block;
  final String language;

  ActionBlockModel({
    required this.topicKey,
    required this.block,
    required this.language,
  });

  factory ActionBlockModel.fromJson(Map<String, dynamic> json) {
    return ActionBlockModel(
      topicKey: json['topic_key'] ?? '',
      block: BlockModel.fromJson(json['block'] ?? {}),
      language: json['language'] ?? '',
    );
  }
}

class BlockModel {
  final List<String> empathyOpeners;
  final List<String> microSteps;
  final List<String> scripts;
  final List<ToolLinkModel> toolLinks;
  final List<String> ifWorse;
  final String disclaimer;

  BlockModel({
    required this.empathyOpeners,
    required this.microSteps,
    required this.scripts,
    required this.toolLinks,
    required this.ifWorse,
    required this.disclaimer,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      empathyOpeners: List<String>.from(json['empathy_openers'] ?? []),
      microSteps: List<String>.from(json['micro_steps'] ?? []),
      scripts: List<String>.from(json['scripts'] ?? []),
      toolLinks: (json['tool_links'] as List? ?? [])
          .map((e) => ToolLinkModel.fromJson(e))
          .toList(),
      ifWorse: List<String>.from(json['if_worse'] ?? []),
      disclaimer: json['disclaimer'] ?? '',
    );
  }
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
}