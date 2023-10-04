import 'dart:convert';
import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/service/http_services.dart';

class GetDatafromDefinition {
  Future<Map<String, List<DealerDefinition>>> fetchData() async {
    // final response = await http.get(Uri.parse(apiUrl));
    Map<String, Object> body = {
      "active": '1',
    };
    final response =
        await HttpService().postRequest("getDealerDefinitionByActive", body);

    // print("response $response");
    if (response.isNotEmpty) {
      final jsonData = json.decode(response);
      final data = jsonData['data'];
      // final data = data1.toJson();
      print(
          '-------------------------------------------------------------$data');

      final generalList = (data['General'] as List)
          .map((item) => DealerDefinition.fromJson(item))
          .toList();

      final fertilizationList = (data['Fertilization'] as List)
          .map((item) => DealerDefinition.fromJson(item))
          .toList();

      final valveDefaultsList = (data['Valve defaults'] as List)
          .map((item) => DealerDefinition.fromJson(item))
          .toList();

      final memoryAllocationsList = (data['Memory allocations'] as List)
          .map((item) => DealerDefinition.fromJson(item))
          .toList();

      return {
        'General': generalList,
        'Fertilization': fertilizationList,
        'Valve defaults': valveDefaultsList,
        'Memory allocations': memoryAllocationsList,
      };
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ... Existing code ...

  Future<void> updateParameterValues(
      String categoryName, String parameter, String newValue) async {
    Map<String, Object> body = {
      "active": '1',
    };
    final response =
        await HttpService().postRequest("getDealerDefinitionByActive", body);

    if (response.isNotEmpty) {
      final jsonData = json.decode(response);
      final data = jsonData['data'];

      if (data.containsKey(categoryName)) {
        final categoryList = (data[categoryName] as List).map((item) {
          var definition = DealerDefinition.fromJson(item);
          if (definition.parameter == parameter) {
            // Update the parameter value
            definition = definition.copyWith(dropdownValues: newValue);
          }
          return definition;
        }).toList();

        // Update the data in the JSON
        data[categoryName] = categoryList;

        // Now you can send the updated data back to your server if needed
        final updatedResponse = await HttpService()
            .postRequest("updateDealerDefinition", {'data': data});

        if (updatedResponse.isNotEmpty) {
          // Data updated successfully
        } else {
          throw Exception('Failed to update data');
        }
      } else {
        throw Exception('Category not found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}












/*

{
    "code": 200,
    "message": "Dealer definition listed successfully",
    "data": {
        "General": [
            {
                "dealerDefinitionId": 1,
                "categoryId": 2,
                "widgetTypeId": 1,
                "parameter": "Use USA units",
                "description": "Use USA Localization Metrics (Gallons, Inches, Pounds, etc)",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "Galens, Inchecs, Pounds",
                "value": ""
            },
            {
                "dealerDefinitionId": 2,
                "categoryId": 2,
                "widgetTypeId": 1,
                "parameter": "Water accumulation unit",
                "description": "Water accumulation unit",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "m3",
                "value": ""
            },
            {
                "dealerDefinitionId": 3,
                "categoryId": 2,
                "widgetTypeId": 2,
                "parameter": "Cycles",
                "description": "Enable repeating cycles",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "Yes",
                "value": ""
            }
        ],
        "Fertilization": [
            {
                "dealerDefinitionId": 4,
                "categoryId": 4,
                "widgetTypeId": 2,
                "parameter": "Local Fert mode Litter/m3",
                "description": "Enable Local Fert mode  ",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "Yes",
                "value": ""
            },
            {
                "dealerDefinitionId": 9,
                "categoryId": 4,
                "widgetTypeId": 3,
                "parameter": "Default fert mode",
                "description": "Default Fertigation dosage mode",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "None,L/m3,mm:ss/m3,sec/min,L/min,L prop,time ,L bulk",
                "value": ""
            }
        ],
        "Valve defaults": [
            {
                "dealerDefinitionId": 5,
                "categoryId": 3,
                "widgetTypeId": 1,
                "parameter": "Default nomonal flow",
                "description": "Default nomonal flow for all valves",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "100",
                "value": ""
            },
            {
                "dealerDefinitionId": 6,
                "categoryId": 3,
                "widgetTypeId": 3,
                "parameter": "Default Dosage mode",
                "description": "Default Dosage mode for all valves in sytem",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "hh:mm:ss,m3",
                "value": ""
            },
            {
                "dealerDefinitionId": 10,
                "categoryId": 3,
                "widgetTypeId": 1,
                "parameter": "fill time",
                "description": "Fill time for all valves(in minutes)",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "15",
                "value": ""
            }
        ],
        "Memory allocations": [
            {
                "dealerDefinitionId": 7,
                "categoryId": 5,
                "widgetTypeId": 1,
                "parameter": "Programs",
                "description": "Total number of programs to allowed the system",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "100",
                "value": ""
            },
            {
                "dealerDefinitionId": 8,
                "categoryId": 5,
                "widgetTypeId": 1,
                "parameter": "Groups",
                "description": "Total number of valve in group allowed in the system",
                "iconCodePoint": 0,
                "iconFontFamily": "",
                "dropdownValues": "99",
                "value": ""
            }
        ]
    }
}*/