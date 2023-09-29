class DealerDefinition {
  final int dealerDefinitionId;
  final int categoryId;
  final String categoryName;
  final int widgetTypeId;
  final String widgetType;
  final String widgetDescription;
  final String parameter;
  final String description;
  final String dropdownValues;
  final String active;

  DealerDefinition({
    required this.dealerDefinitionId,
    required this.categoryId,
    required this.categoryName,
    required this.widgetTypeId,
    required this.widgetType,
    required this.widgetDescription,
    required this.parameter,
    required this.description,
    required this.dropdownValues,
    required this.active,
  });

  factory DealerDefinition.fromJson(Map<String, dynamic> json) {
    return DealerDefinition(
      dealerDefinitionId: json['dealerDefinitionId'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      widgetTypeId: json['widgetTypeId'],
      widgetType: json['widgetType'],
      widgetDescription: json['widgetDescription'],
      parameter: json['parameter'],
      description: json['description'],
      dropdownValues: json['dropdownValues'],
      active: json['active'],
    );
  }
}
