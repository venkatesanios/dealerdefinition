import 'dart:convert';

import 'package:dealer_definition/const/custom_switch.dart';
import 'package:dealer_definition/const/custom_text.dart';
import 'package:dealer_definition/dealerdefinition/delear_definition_model.dart';
import 'package:dealer_definition/res/string_to_list.dart';
import 'package:dealer_definition/service/http_services.dart';
import 'package:flutter/material.dart';

class WebContent extends StatefulWidget {
  @override
  State<WebContent> createState() => _WebContentState();
}

class _WebContentState extends State<WebContent> {
  final _formKeydealer = GlobalKey<FormState>();
  String? dropdowninitialValue;
  DataModel data = DataModel(categories: [], dealerDefinition: Map());

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
  }

  @override
  Widget build(BuildContext context) {
    if (data.categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 350).floor();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 239, 252),
      appBar: AppBar(
        title: Text('Dealer defination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKeydealer,
          child: GridView(
  physics: data.categories.length == crossAxisCount
      ? const NeverScrollableScrollPhysics()
      : ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10, // Spacing between rows
                crossAxisSpacing: 10,
                childAspectRatio: 0.5),
                
            children: <Widget>[
              for (int i = 0; i < data.categories.length; i++)
                data.categories.isEmpty
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(5),
                        child: Center(
                          child: buildTab(
                              '${data.categories[i].categoryName}',
                              true,
                              data.dealerDefinition[
                                  '${data.categories[i].categoryId}']),
                        ),
                      ),
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
          final jsonData = json.decode(response);

          showAlertDialog(BuildContext context) {
            // set up the button
            Widget okButton = TextButton(
              child: Text("OK"),
              onPressed: () {},
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("$jsonData.code"),
              content: Text("$jsonData.message"),
              actions: [
                okButton,
              ],
            );

            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget buildTab(String tabTitle, bool titlestatus,
      List<DealerDefinitionnew>? Listofvalue) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
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
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: Listofvalue?.length ?? 0,
              itemBuilder: (context, index) {
                final dropdownlist = StringToList().stringtolist(
                  '${Listofvalue?[index].dropdownValues}',
                  ',',
                );
                int iconcode = int.parse(Listofvalue?[index].iconCodePoint ?? "");
                String iconfontfamily =
                    Listofvalue?[index].iconFontFamily ?? "MaterialIcons";

                if (Listofvalue?[index].widgetTypeId == 3) {
                  return Column(
                    children: [
                      Container(
                        // color: index.isEven
                        //     ? const Color.fromARGB(255, 223, 239, 252)
                        //     : const Color.fromARGB(255, 192, 216, 252),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(
                                IconData(iconcode, fontFamily: iconfontfamily)),
                            title: Text('${Listofvalue?[index].parameter}'),
                            subtitle: Text(
                              '${Listofvalue?[index].description}',
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: DropdownButton(
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
                          leading: Icon(
                              IconData(iconcode, fontFamily: iconfontfamily)),
                          title: Text('${Listofvalue?[index].parameter}'),
                          subtitle: Text(
                            '${Listofvalue?[index].description}',
                            style: const TextStyle(fontSize: 11),
                          ),
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
                          leading: Icon(
                              IconData(iconcode, fontFamily: iconfontfamily)),
                          title: Text('${Listofvalue?[index].parameter}'),
                          subtitle: Text(
                            '${Listofvalue?[index].description}',
                            style: const TextStyle(fontSize: 11),
                          ),
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
      ),
    );
  }
}
