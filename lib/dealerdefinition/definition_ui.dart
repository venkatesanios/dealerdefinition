import 'dart:convert';
import 'dart:developer';

import 'package:dealer_definition/const/custom_switch.dart';
import 'package:dealer_definition/const/custom_text.dart';
import 'package:dealer_definition/dealerdefinition/dealer_Screen_Web.dart';
import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/dealerdefinition/definition_viewmodel.dart';
import 'package:dealer_definition/const/drop_down_button.dart';
import 'package:dealer_definition/res/string_to_list.dart';
import 'package:dealer_definition/service/http_services.dart';
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
            return WebContent();
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Map<String, Object> body = {"userId": '1', "controllerId": '1'};
    print(body);
    final response =
        await HttpService().postRequest("getUserDealerDefinition", body);
    print('response-------mobile---------$response');
    final jsonData = json.decode(response);
    try {
      setState(() {
        data = DealerDefinition.fromJson(jsonData);
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
          child: Form(
            key: _formKeydealer,
            child: TabBarView(
              children: [
                buildTab1('General', false, data.data?.general),
                buildTab1('Fertilizer', false, data.data?.fertilization),
                buildTab1('Valve Defaults', false, data.data?.valveDefaults),
                buildTab1('Memory', false, data.data?.memoryAllocations),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final reqJson = data.toJson();
            final senddata = reqJson['data'];
            final datatest = jsonEncode(senddata);

            Map<String, Object> body = {
              "userId": '1',
              "controllerId": "1",
              "dealerDefinition": datatest,
              "createUser": "1"
            };
            final response = await HttpService()
                .postRequest("createUserDealerDefinition", body);
          },
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  Widget buildTab1(
      String tabTitle, bool titlestatus, List<Fertilization>? Listofvalue) {
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
              int iconcode = int.parse(Listofvalue?[index].iconCodePoint ?? "");
              String iconfontfamily =
                  Listofvalue?[index].iconFontFamily ?? "MaterialIcons";
              if (Listofvalue?[index].widgetTypeId == 3) {
                final dropdownlist = StringToList().stringtolist(
                  '${Listofvalue?[index].dropdownValues}',
                  ',',
                );

                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        // leading: Icon(IconData(
                        //     Listofvalue?[index].iconCodePoint ?? 0xee2a,
                        //     fontFamily:
                        //         '${Listofvalue?[index].iconFontFamily}')),

                        title: Text('${Listofvalue?[index].parameter}'),
                        subtitle: Text(
                          'Details: ${Listofvalue?[index].description}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        leading: Icon(
                            IconData(iconcode, fontFamily: iconfontfamily)),
                        trailing: Container(
                          color: Colors.white,
                          width: 140,
                          child: DropdownButton(
                            items: dropdownlist.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(items)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                Listofvalue?[index].value = value;
                              });
                            },
                            value: Listofvalue?[index].value == ''
                                ? dropdownlist[0].toString()
                                : Listofvalue?[index].value,
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
                        leading: Icon(
                            IconData(iconcode, fontFamily: iconfontfamily)),
                        trailing: SizedBox(
                            width: 50,
                            child: CustomTextField(
                              onChanged: (text) {
                                setState(() {
                                  Listofvalue?[index].value = text;
                                });
                              },
                              initialValue: Listofvalue?[index].value ?? '0',
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
                        leading: Icon(
                            IconData(iconcode, fontFamily: iconfontfamily)),
                        trailing: MySwitch(
                          value: Listofvalue?[index].value == '1',
                          onChanged: ((value) {
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
