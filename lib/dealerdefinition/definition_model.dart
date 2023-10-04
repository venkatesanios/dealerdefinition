class DealerDefinition {
  final int dealerDefinitionId;
  final int categoryId;
  final int widgetTypeId;
  final String parameter;
  final String description;
  final String dropdownValues;
  final int iconCodePoint;
  final String iconFontFamily;
  String value;

  DealerDefinition(
      {required this.dealerDefinitionId,
      required this.categoryId,
      required this.widgetTypeId,
      required this.parameter,
      required this.description,
      required this.dropdownValues,
      required this.iconCodePoint,
      required this.iconFontFamily,
      required this.value});

  factory DealerDefinition.fromJson(Map<String, dynamic> json) {
    return DealerDefinition(
        dealerDefinitionId: json['dealerDefinitionId'],
        categoryId: json['categoryId'],
        widgetTypeId: json['widgetTypeId'],
        parameter: json['parameter'],
        description: json['description'],
        dropdownValues: json['dropdownValues'],
        iconCodePoint: json['iconCodePoint'],
        iconFontFamily: json['iconFontFamily'],
        value: json['value']);
  }

  DealerDefinition copyWith({
    int? dealerDefinitionId,
    int? categoryId,
    int? widgetTypeId,
    String? parameter,
    String? description,
    String? dropdownValues,
    int? iconCodePoint,
    String? iconFontFamily,
    String? value,
  }) {
    return DealerDefinition(
      dealerDefinitionId: dealerDefinitionId ?? this.dealerDefinitionId,
      categoryId: categoryId ?? this.categoryId,
      widgetTypeId: widgetTypeId ?? this.widgetTypeId,
      parameter: parameter ?? this.parameter,
      description: description ?? this.description,
      dropdownValues: dropdownValues ?? this.dropdownValues,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      value: value ?? this.value,
    );
  }
}
