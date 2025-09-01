class ActionBlockResponseModel {
  final ActionBlockModel actionBlock;

  ActionBlockResponseModel({required this.actionBlock});

  factory ActionBlockResponseModel.fromJson(Map<String, dynamic> json) {
    return ActionBlockResponseModel(
      actionBlock: ActionBlockModel.fromJson(json['action-block']),
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
      topicKey: json['TopicKey'],
      block: BlockModel.fromJson(json['Block']),
      language: json['Language'],
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
      empathyOpeners: List<String>.from(json['EmpathyOpeners']),
      microSteps: List<String>.from(json['MicroSteps']),
      scripts: List<String>.from(json['Scripts']),
      toolLinks: (json['ToolLinks'] as List)
          .map((e) => ToolLinkModel.fromJson(e))
          .toList(),
      ifWorse: List<String>.from(json['IfWorse']),
      disclaimer: json['Disclaimer'],
    );
  }
}

class ToolLinkModel {
  final String title;
  final String url;

  ToolLinkModel({required this.title, required this.url});

  factory ToolLinkModel.fromJson(Map<String, dynamic> json) {
    return ToolLinkModel(title: json['Title'], url: json['URL']);
  }
}
