import 'dart:convert';
import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/service/http_services.dart';
import 'package:flutter/material.dart';

class GetDatafromDefinition extends ChangeNotifier {
  Future<Map<String, List<DealerDefinition>>> fetchData() async {
    // final response = await http.get(Uri.parse(apiUrl));
    Map<String, Object> body = {"userId": '1', "controllerId": '1'};
    final response =
        await HttpService().postRequest("getUserDealerDefinition", body);

    if (response.isNotEmpty) {
      final jsonData = json.decode(response);
      final data = jsonData['data'];

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
}
