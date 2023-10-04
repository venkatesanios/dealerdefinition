import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropDown extends StatefulWidget {
  String? initialValue;
  String? purpose;
  List<String> itemList;
  final Function(String value)? setValue;

  MyDropDown({
    super.key,
    this.initialValue,
    required this.itemList,
    this.purpose,
    this.setValue,
  });

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    print(widget.initialValue);

    return Container(
      // width: double.infinity,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 247, 245, 245),
          //borderRadius: BorderRadius.circular(10),
          border: Border(
              bottom: BorderSide(
            color: Colors.grey,
            width: 2,
          ))),
      child: DropdownButton(
        underline: Container(),
        // Initial Value
        value: widget.initialValue ?? widget.itemList[0],

        isExpanded: true,
        // Down Arrow Icon
        icon: Padding(
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.keyboard_arrow_down),
        ),
        // Array list of items
        items: widget.itemList.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Container(padding: EdgeInsets.only(left: 10), child: Text(items)),
          );
        }).toList(),

        onChanged: (String? newValue) {
          setState(() {
            widget.initialValue = newValue!;
          });
        },
      ),
    );
  }
}
