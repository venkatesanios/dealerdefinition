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
  String? dropdowninitialValue;
  final GetDatafromDefinition apiService = GetDatafromDefinition();
  DealerDefinition data = DealerDefinition();

  final jsondata = {
    "code": 200,
    "message": "Dealer definition listed successfully",
    "data": {
      "General": [
        {"dealerDefinitionId": 1, "categoryId": 2, "widgetTypeId": 1, "parameter": "Use USA units", "description": "Use USA Localization Metrics (Gallons, Inches, Pounds, etc)", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "Galens, Inchecs, Pounds", "value": ""},
        {"dealerDefinitionId": 2, "categoryId": 2, "widgetTypeId": 1, "parameter": "Water accumulation unit", "description": "Water accumulation unit", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "m3", "value": ""},
        {"dealerDefinitionId": 3, "categoryId": 2, "widgetTypeId": 2, "parameter": "Cycles", "description": "Enable repeating cycles", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "Yes", "value": ""}
      ],
      "Fertilization": [
        {"dealerDefinitionId": 4, "categoryId": 4, "widgetTypeId": 2, "parameter": "Local Fert mode Litter/m3", "description": "Enable Local Fert mode  ", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "Yes", "value": ""},
        {"dealerDefinitionId": 9, "categoryId": 4, "widgetTypeId": 3, "parameter": "Default fert mode", "description": "Default Fertigation dosage mode", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "None,L/m3,mm:ss/m3,sec/min,L/min,L prop,time ,L bulk", "value": ""}
      ],
      "Valve defaults": [
        {"dealerDefinitionId": 5, "categoryId": 3, "widgetTypeId": 1, "parameter": "Default nomonal flow", "description": "Default nomonal flow for all valves", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "100", "value": ""},
        {"dealerDefinitionId": 6, "categoryId": 3, "widgetTypeId": 3, "parameter": "Default Dosage mode", "description": "Default Dosage mode for all valves in sytem", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "hh:mm:ss,m3", "value": ""},
        {"dealerDefinitionId": 10, "categoryId": 3, "widgetTypeId": 1, "parameter": "fill time", "description": "Fill time for all valves(in minutes)", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "15", "value": ""}
      ],
      "Memory allocations": [
        {"dealerDefinitionId": 7, "categoryId": 5, "widgetTypeId": 1, "parameter": "Programs", "description": "Total number of programs to allowed the system", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "100", "value": ""},
        {"dealerDefinitionId": 8, "categoryId": 5, "widgetTypeId": 1, "parameter": "Groups", "description": "Total number of valve in group allowed in the system", "iconCodePoint": 0, "iconFontFamily": "", "dropdownValues": "99", "value": ""}
      ]
    }
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    data = DealerDefinition.fromJson(jsondata);
    // try {
    //   final result = await apiService.fetchData();
    //   setState(() {
    //     // data = result;
    //   });
    // } catch (e) {
    //   // Handle error
    //   print('Error: $e');
    // }
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
          child: Form(
            key: _formKeydealer,
            child: TabBarView(
              children: [
                buildTab('General', false,data.data?.general),
                buildTab('Fertilizer', false,data.data?.fertilization),
                buildTab('Valve Defaults', false,data.data?.valveDefaults),
                buildTab('Memory', false,data.data?.memoryAllocations),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final reqJson = data.toJson();

            print(reqJson);
          },
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  Widget buildTab(String tabTitle, bool titlestatus,List<Fertilization>? Listofvalue) {
       
    print(Listofvalue?[0].value);

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
        Expanded(
          child: ListView.builder(
            itemCount: Listofvalue?.length ?? 0,
            itemBuilder: (context, index) {
              if (Listofvalue?[index].widgetTypeId == 3) {
                final dropdownlist = StringToList().stringtolist(
                  '${Listofvalue?[index].dropdownValues}',
                  ',',
                );
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
                            key: UniqueKey(),
                            itemList: dropdownlist,
                            initialValue: dropdowninitialValue ?? (Listofvalue?[index].value == '' ? dropdownlist[0].toString() : Listofvalue?[index].value),
                            setValue: (value) {
                              setState(() {
                                dropdowninitialValue = value;
                              });
                            },
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
              } else if (Listofvalue?[index].widgetTypeId == 1) {
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
                                  setState(() {
                                    Listofvalue?[index].value = value;
                                  });
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
                          value: Listofvalue?[index].value == '1',
                          onChanged: ((value) {
                            print(value);
                            setState(() {
                              Listofvalue?[index].value = !value ? '0' : '1';
                            });
                            // Listofvalue?[index].value = value;
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
      ],
    );
  }
}
