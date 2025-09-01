class ActionBlockEntity {
  final String topicKey;
  final String language;
  final List<String> empathyOpeners;
  final List<String> microSteps;
  final List<String> scripts;
  final List<ToolLinkEntity> toolLinks;
  final List<String> ifWorse;
  final String disclaimer;

  ActionBlockEntity({
    required this.topicKey,
    required this.language,
    required this.empathyOpeners,
    required this.microSteps,
    required this.scripts,
    required this.toolLinks,
    required this.ifWorse,
    required this.disclaimer,
  });
}

class ToolLinkEntity {
  final String title;
  final String url;

  ToolLinkEntity({required this.title, required this.url});
}