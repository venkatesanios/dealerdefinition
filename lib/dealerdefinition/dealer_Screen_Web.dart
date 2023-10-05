import 'dart:convert';

import 'package:dealer_definition/const/custom_switch.dart';
import 'package:dealer_definition/const/custom_text.dart';
import 'package:dealer_definition/dealerdefinition/definition_model.dart';
import 'package:dealer_definition/dealerdefinition/definition_viewmodel.dart';
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
  final GetDatafromDefinition apiService = GetDatafromDefinition();
  DealerDefinition data = DealerDefinition();

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
        data = DealerDefinition.fromJson(jsonData);
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 300).floor();

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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10, // Spacing between rows
                crossAxisSpacing: 10,
                childAspectRatio: 0.5),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: buildTab('General', true, data.data?.general),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: buildTab('Fertilizer', true, data.data?.fertilization),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: Center(
                  child:
                      buildTab('Valve default', true, data.data?.valveDefaults),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: buildTab('Memory', true, data.data?.memoryAllocations),
                ),
              ),
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
          print('response---------------------------------$response');
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget buildTab(
      String tabTitle, bool titlestatus, List<Fertilization>? Listofvalue) {
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
          Flexible(
            child: ListView.builder(
              itemCount: Listofvalue?.length ?? 0,
              itemBuilder: (context, index) {
                final dropdownlist = StringToList().stringtolist(
                  '${Listofvalue?[index].dropdownValues}',
                  ',',
                );
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
                            // leading: const Icon(Icons.account_balance),
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
                        // color: index.isEven
                        //     ? const Color.fromARGB(255, 223, 239, 252)
                        //     : const Color.fromARGB(255, 192, 216, 252),
                        child: ListTile(
                          // leading: const Icon(Icons.sports_baseball),
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
                          // leading: const Icon(Icons.abc_rounded),
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

//  {
//   "message" : "Succès ",
//   "code" : 200,
//   "General" : [
// {"title" : "USA. unite","description" : "Details of use Use units","value" : "1234","valuetype" : "dropdown","dropdownlist" : []},{"title" : "USA. unite","description" : "Details of use Use units","value" : "1234","valuetype" : "dropdown","dropdownlist" : []}
//   ],
//     "Fertilizer" : [
// {"title" : "USA. unite","description" : "Details of use Use units","value" : "1234","valuetype" : "dropdown","dropdownlist" : []}

//   ],
//     "Valve" : [
// {"title" : "USA. unite","description" : "Details of use Use units","value" : "1234","valuetype" : "dropdown","dropdownlist" : []}

//   ],
//     "Memory" : [
// {"title" : "USA. unite","description" : "Details of use Use units","value" : "1234","valuetype" : "dropdown","dropdownlist" : []}

//   ]
// }
