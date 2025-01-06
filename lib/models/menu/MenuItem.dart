class MenuItem {
  final String label;
  final String action;

  MenuItem({
    required this.label,
    required this.action
  });

  // Converte um Map<String, dynamic> (JSON) em uma instância de User
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      label: json['label'] ?? '',
      action: json['action'] ?? '',
    );
  }

  // Converte uma instância de User para um Map<String, dynamic> (JSON)
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'action': action,
    };
  }
}