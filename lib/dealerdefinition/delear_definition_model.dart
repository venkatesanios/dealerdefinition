import 'dart:convert';

class Category {
  final int categoryId;
  final String categoryName;
  final String categoryDescription;
  final String active;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.active,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryDescription: json['categoryDescription'],
      active: json['active'],
    );
  }
}

class DealerDefinitionnew {
  final int dealerDefinitionId;
  final String categoryName;
  final int widgetTypeId;
  final String parameter;
  final String description;
  final String iconCodePoint;
  final String iconFontFamily;
  final String dropdownValues;
  String value;

  DealerDefinitionnew({
    required this.dealerDefinitionId,
    required this.categoryName,
    required this.widgetTypeId,
    required this.parameter,
    required this.description,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.dropdownValues,
    required this.value,
  });

  factory DealerDefinitionnew.fromJson(Map<String, dynamic> json) {
    return DealerDefinitionnew(
      dealerDefinitionId: json['dealerDefinitionId'],
      categoryName: json['categoryName'],
      widgetTypeId: json['widgetTypeId'],
      parameter: json['parameter'],
      description: json['description'],
      iconCodePoint: json['iconCodePoint'],
      iconFontFamily: json['iconFontFamily'],
      dropdownValues: json['dropdownValues'],
      value: json['value'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dealerDefinitionId': dealerDefinitionId,
      'categoryName': categoryName,
      'widgetTypeId': widgetTypeId,
      'parameter': parameter,
      'description': description,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'dropdownValues': dropdownValues,
      'value': value,
    };
  }
}

class DataModel {
  final List<Category> categories;
  final Map<String, List<DealerDefinitionnew>> dealerDefinition;

  DataModel({
    required this.categories,
    required this.dealerDefinition,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var categoryList = json['data']['category'] as List;
    List<Category> categories =
        categoryList.map((category) => Category.fromJson(category)).toList();

    Map<String, List<DealerDefinitionnew>> dealerDefinition = {};
    var dealerDefinitionData = json['data']['dealerDefinition'];
    dealerDefinitionData.forEach((key, value) {
      var list = value
          .map<DealerDefinitionnew>(
              (item) => DealerDefinitionnew.fromJson(item))
          .toList();
      dealerDefinition[key] = list;
    });

    return DataModel(
      categories: categories,
      dealerDefinition: dealerDefinition,
    );
  }
}
