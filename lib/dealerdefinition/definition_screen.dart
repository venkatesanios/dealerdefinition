import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/dealerdefinition/definition_viewmodel.dart';
import 'package:flutter/material.dart';

class DealerDefinitionPage extends StatefulWidget {
  @override
  _DealerDefinitionPageState createState() => _DealerDefinitionPageState();
}

class _DealerDefinitionPageState extends State<DealerDefinitionPage> {
  final GetDatafromDefinition apiService = GetDatafromDefinition();
  Map<String, List<DealerDefinition>> data = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final result = await apiService.fetchData();
      setState(() {
        data = result;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dealer Definition Page'),
      ),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Container(
                    child: TextButton(
                      child: Text('click'),
                      onPressed: () {
                        print('general:${data['General']!.length}');
                        print('Memory');
                        print(data['Memory allocations']);
                      },
                    ),
                  ),
                  // Display the General settings data
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data['General']!.map((item) {
                      return Text('${item.parameter}: ${item.description}');
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
