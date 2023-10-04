import 'package:dealer_definition/const/custom_switch.dart';
import 'package:dealer_definition/const/custom_text.dart';
import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/dealerdefinition/definition_viewmodel.dart';
import 'package:dealer_definition/const/drop_down_button.dart';
import 'package:dealer_definition/res/string_to_list.dart';
import 'package:dealer_definition/service/http_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DealerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 800) {
            return MobileContent();
          } else {
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
  final _formKey = GlobalKey<FormState>();

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

  void updatevalue(String value, int index, String tabTitle) {
    // _value = value;
    data[tabTitle]?[index].value = value;
    // notifyListeners();
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
                text: 'Memory allocations',
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
              buildTab('Memory allocations', false),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Map<String, Object> body = {
              "userId": "1",
              "controllerId": "1",
              "dealerDefinition": data.toString(),
              "createUser": "1"
            };

            final response = await HttpService()
                .postRequest("createUserDealerDefinition", body);
            print('response:------------$body');
            print(data.keys);
            print('response:------------$response');
          },
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  Widget buildTab(String tabTitle, bool titlestatus) {
    int count = 0;

    List<DealerDefinition>? Listofvalue = [];
    Listofvalue.clear();
    if (tabTitle == "General") {
      count = data['General']!.length ?? 0;
      Listofvalue = data['General'];
    } else if (tabTitle == "Fertilizer") {
      count = data['Fertilization']!.length ?? 0;
      Listofvalue = data['Fertilization'];
    } else if (tabTitle == "Valve Defaults") {
      count = data['Valve defaults']!.length ?? 0;
      Listofvalue = data['Valve defaults'];
    } else if (tabTitle == "Memory allocations") {
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
            key: _formKey,
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                print('tab title is : - $tabTitle');
                for (var i = 0; i < Listofvalue!.length; i++) {
                  print('i $i');
                  print(Listofvalue[i].value);
                  print('data:${data[tabTitle]?[i].value}');
                }

                if (Listofvalue?[index].widgetTypeId == 1) {
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
                                onChanged: (text) {
                                  data[tabTitle]?[index].value = text;
                                  Listofvalue?[index].value = text;
                                },
                                initialValue: data[tabTitle]?[index].value == ''
                                    ? '0'
                                    : data[tabTitle]?[index].value.toString(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Warranty is required';
                                  } else {
                                    data[tabTitle]?[index].value = value ?? '0';
                                    Listofvalue?[index].value = value ?? '0';
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
                } else if (Listofvalue?[index].widgetTypeId == 3) {
                  List<String> dropdownlist = StringToList().stringtolist(
                      '${Listofvalue?[index].dropdownValues}', ',');
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
                            child: DropdownButton(
                              value: Listofvalue?[index].value == ''
                                  ? dropdownlist[0].toString()
                                  : Listofvalue?[index].value.toString(),
                              items: dropdownlist.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(items)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                data[tabTitle]?[index].value = newValue!;
                              },
                              isExpanded: true,
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
                            value:
                                Listofvalue?[index].value == '1' ? true : false,
                            onChanged: ((value) {
                              print(value);
                              // dealerviewmodel.updatevalue;
                              data[tabTitle]?[index].value = value.toString();
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
