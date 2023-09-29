import 'package:flutter/material.dart';

class MySwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  MySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<MySwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Switch(value: widget.value, onChanged: widget.onChanged),

      // Container(
      //   // width: 60.0,
      //   // height: 30.0,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15.0),
      //     color: widget.value ? Colors.green : Colors.grey,
      //   ),
      //   child: Align(
      //     alignment:
      //         widget.value ? Alignment.centerRight : Alignment.centerLeft,
      //     child: Container(
      //       width: 30.0,
      //       height: 30.0,
      //       decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
