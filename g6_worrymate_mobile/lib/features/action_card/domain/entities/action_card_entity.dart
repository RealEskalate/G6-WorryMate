class ActionCardEntity {
  final String title;
  final String description;
  final List<String> steps;
  final List<ToolLinkEntity> miniTools;
  final List<String> uiTools;
  final String ifWorse;
  final String disclaimer;

  ActionCardEntity({
    required this.title,
    required this.description,
    required this.steps,
    required this.miniTools,
    required this.uiTools,
    required this.ifWorse,
    required this.disclaimer,
  });
}

class ToolLinkEntity {
  final String title;
  final String url;

  ToolLinkEntity({required this.title, required this.url});
}
