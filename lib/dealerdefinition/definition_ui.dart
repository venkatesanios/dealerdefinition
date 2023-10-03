import 'package:dealer_definition/const/custom_switch.dart';
import 'package:dealer_definition/const/custom_text.dart';
import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/dealerdefinition/definition_viewmodel.dart';
import 'package:dealer_definition/const/drop_down_button.dart';
import 'package:dealer_definition/res/string_to_list.dart';
import 'package:flutter/material.dart';

class DealerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 800) {
            // Render mobile content
            return MobileContent();
          } else {
            // Render web content
            return MobileContent();
          }
        },
      ),
    );
  }
}

class MobileContent extends StatefulWidget {
  @override
  State<MobileContent> createState() => _MobileContentState();
}

class _MobileContentState extends State<MobileContent> {
  final _formKeydealer = GlobalKey<FormState>();

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dealer Definition'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'General',
                icon: Icon(Icons.settings_applications),
              ),
              Tab(
                text: 'Fertilizer',
                icon: Icon(Icons.filter_alt),
              ),
              Tab(
                text: 'Valve default',
                icon: Icon(Icons.schema),
              ),
              Tab(
                text: 'Memory',
                icon: Icon(Icons.sd_storage),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
          child: TabBarView(
            children: [
              buildTab('General', false),
              buildTab('Fertilizer', false),
              buildTab('Valve Defaults', false),
              buildTab('Memory', false),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  Widget buildTab(String tabTitle, bool titlestatus) {
    int count = 0;

    List<DealerDefinition>? Listofvalue = [];
    if (tabTitle == "General") {
      count = data['General']!.length ?? 0;
      Listofvalue = data['General'];
    } else if (tabTitle == "Fertilizer") {
      count = data['Fertilization']!.length ?? 0;
      Listofvalue = data['Fertilization'];
    } else if (tabTitle == "Valve Defaults") {
      count = data['Valve defaults']!.length ?? 0;
      Listofvalue = data['Valve defaults'];
    } else if (tabTitle == "Memory") {
      count = data['Memory allocations']!.length ?? 0;
      Listofvalue = data['Memory allocations'];
    }
    return Column(
      children: [
        titlestatus
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  tabTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
        Flexible(
          child: Form(
            key: _formKeydealer,
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                if (Listofvalue?[index].widgetType == 'DROPDOWN') {
                  String selectedDropdownValue = 'hh:mm:ss';
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text('${Listofvalue?[index].parameter}'),
                          subtitle: Text(
                            'Details: ${Listofvalue?[index].description}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: Container(
                            color: Colors.white,
                            width: 140,
                            child: MyDropDown(
                              itemList: StringToList().stringtolist(
                                '${Listofvalue?[index].dropdownValues}',
                                ',',
                              ),
                              // setValue: Listofvalue?[index].description = '',
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 70,
                        ),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                } else if (Listofvalue?[index].widgetType == 'TEXT') {
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text('${Listofvalue?[index].parameter}'),
                          subtitle: Text(
                            'Details: ${Listofvalue?[index].description}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: SizedBox(
                              width: 50,
                              child: CustomTextField(
                                onChanged: (text) {},
                                initialValue: '0',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Warranty is required';
                                  } else {
                                    // Listofvalue?[index].parameter = value;
                                  }
                                  return null;
                                },
                              )),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 70,
                        ),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text('${Listofvalue?[index].parameter}'),
                          subtitle: Text(
                            'Details: ${Listofvalue?[index].description}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: MySwitch(
                            value: false,
                            onChanged: ((value) {
                              print(value);
                              // dealerviewmodel.updatevalue;
                            }),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 70,
                        ),
                        child: Divider(
                          height: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
