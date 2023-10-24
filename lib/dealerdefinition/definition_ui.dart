import 'dart:convert';
import 'dart:developer';

import 'package:dealer_definition/const/custom_switch.dart';
import 'package:dealer_definition/const/custom_text.dart';
import 'package:dealer_definition/dealerdefinition/dealer_Screen_Web.dart';
import 'package:dealer_definition/dealerdefinition/delear_definition_model.dart';
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
          if (constraints.maxWidth <= 600) {
            return MobileContent();
          } else {
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

  late DataModel data;
  int tabindex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Map<String, Object> body = {"userId": '1', "controllerId": '1'};
    final response =
        await HttpService().postRequest("getUserDealerDefinition", body);
    final jsonData = json.decode(response);
    try {
      setState(() {
        data = DataModel.fromJson(jsonData);
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
    print('------------$data');
  }

  @override
  Widget build(BuildContext context) {
    if (data.categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return DefaultTabController(
      length: data.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dealer Definition'),
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 175, 73, 73),
            isScrollable: true,
            tabs: [
              for (var i = 0; i < data.categories.length; i++)
                Tab(
                  text: data.categories[i].categoryName,
                ),
            ],
            onTap: (value) {
              print(value);

              setState(() {
                tabindex = value;
              });
              print(tabindex);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
          child: Form(
            key: _formKeydealer,
            child: TabBarView(
              children: [
                for (int i = 0; i < data.categories.length; i++)
                  data.categories.isEmpty
                      ? Container()
                      : buildTab1(
                          '${data.categories[i].categoryName}',
                          false,
                          data.dealerDefinition[
                              '${data.categories[i].categoryId}']),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final datadealerdef = data.dealerDefinition;
            final senddata = jsonEncode(datadealerdef);

            Map<String, Object> body = {
              "userId": '1',
              "controllerId": "1",
              "dealerDefinition": senddata,
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

  Widget buildTab1(String tabTitle, bool titlestatus,
      List<DealerDefinitionnew>? Listofvalue) {
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
                                Listofvalue?[index].value = value!;
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
