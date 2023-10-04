// To parse this JSON data, do
//
//     final dealerDefinition = dealerDefinitionFromJson(jsonString);

import 'dart:convert';

DealerDefinition dealerDefinitionFromJson(String str) => DealerDefinition.fromJson(json.decode(str));

String dealerDefinitionToJson(DealerDefinition data) => json.encode(data.toJson());

class DealerDefinition {
    int? code;
    String? message;
    Data? data;

    DealerDefinition({
        this.code,
        this.message,
        this.data,
    });

    DealerDefinition copyWith({
        int? code,
        String? message,
        Data? data,
    }) => 
        DealerDefinition(
            code: code ?? this.code,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory DealerDefinition.fromJson(Map<String, dynamic> json) => DealerDefinition(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    List<Fertilization>? general;
    List<Fertilization>? fertilization;
    List<Fertilization>? valveDefaults;
    List<Fertilization>? memoryAllocations;

    Data({
        this.general,
        this.fertilization,
        this.valveDefaults,
        this.memoryAllocations,
    });

    Data copyWith({
        List<Fertilization>? general,
        List<Fertilization>? fertilization,
        List<Fertilization>? valveDefaults,
        List<Fertilization>? memoryAllocations,
    }) => 
        Data(
            general: general ?? this.general,
            fertilization: fertilization ?? this.fertilization,
            valveDefaults: valveDefaults ?? this.valveDefaults,
            memoryAllocations: memoryAllocations ?? this.memoryAllocations,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        general: json["General"] == null ? [] : List<Fertilization>.from(json["General"]!.map((x) => Fertilization.fromJson(x))),
        fertilization: json["Fertilization"] == null ? [] : List<Fertilization>.from(json["Fertilization"]!.map((x) => Fertilization.fromJson(x))),
        valveDefaults: json["Valve defaults"] == null ? [] : List<Fertilization>.from(json["Valve defaults"]!.map((x) => Fertilization.fromJson(x))),
        memoryAllocations: json["Memory allocations"] == null ? [] : List<Fertilization>.from(json["Memory allocations"]!.map((x) => Fertilization.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "General": general == null ? [] : List<dynamic>.from(general!.map((x) => x.toJson())),
        "Fertilization": fertilization == null ? [] : List<dynamic>.from(fertilization!.map((x) => x.toJson())),
        "Valve defaults": valveDefaults == null ? [] : List<dynamic>.from(valveDefaults!.map((x) => x.toJson())),
        "Memory allocations": memoryAllocations == null ? [] : List<dynamic>.from(memoryAllocations!.map((x) => x.toJson())),
    };
}

class Fertilization {
    int? dealerDefinitionId;
    int? categoryId;
    int? widgetTypeId;
    String? parameter;
    String? description;
    int? iconCodePoint;
    String? iconFontFamily;
    String? dropdownValues;
    String? value;

    Fertilization({
        this.dealerDefinitionId,
        this.categoryId,
        this.widgetTypeId,
        this.parameter,
        this.description,
        this.iconCodePoint,
        this.iconFontFamily,
        this.dropdownValues,
        this.value,
    });

    Fertilization copyWith({
        int? dealerDefinitionId,
        int? categoryId,
        int? widgetTypeId,
        String? parameter,
        String? description,
        int? iconCodePoint,
        String? iconFontFamily,
        String? dropdownValues,
        String? value,
    }) => 
        Fertilization(
            dealerDefinitionId: dealerDefinitionId ?? this.dealerDefinitionId,
            categoryId: categoryId ?? this.categoryId,
            widgetTypeId: widgetTypeId ?? this.widgetTypeId,
            parameter: parameter ?? this.parameter,
            description: description ?? this.description,
            iconCodePoint: iconCodePoint ?? this.iconCodePoint,
            iconFontFamily: iconFontFamily ?? this.iconFontFamily,
            dropdownValues: dropdownValues ?? this.dropdownValues,
            value: value ?? this.value,
        );

    factory Fertilization.fromJson(Map<String, dynamic> json) => Fertilization(
        dealerDefinitionId: json["dealerDefinitionId"],
        categoryId: json["categoryId"],
        widgetTypeId: json["widgetTypeId"],
        parameter: json["parameter"],
        description: json["description"],
        iconCodePoint: json["iconCodePoint"],
        iconFontFamily: json["iconFontFamily"],
        dropdownValues: json["dropdownValues"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "dealerDefinitionId": dealerDefinitionId,
        "categoryId": categoryId,
        "widgetTypeId": widgetTypeId,
        "parameter": parameter,
        "description": description,
        "iconCodePoint": iconCodePoint,
        "iconFontFamily": iconFontFamily,
        "dropdownValues": dropdownValues,
        "value": value,
    };
}
