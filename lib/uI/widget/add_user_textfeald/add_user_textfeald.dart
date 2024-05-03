import 'package:flutter/material.dart';

import '../../../app_details/color.dart';

class AddUserTextFelid extends StatefulWidget {
  const AddUserTextFelid(
      {super.key,
      required this.controller,
      required this.hint,
      required this.icon,
      required this.type});
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType type;

  @override
  State<AddUserTextFelid> createState() => _AddUserTextFelidState();
}

class _AddUserTextFelidState extends State<AddUserTextFelid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        // height: h / 10,
        child: TextField(
          keyboardType: widget.type,
          controller: widget.controller,
          onChanged: (value) {
            setState(() {
              widget.controller;
            });
          },
          // maxLines: 5,
          // minLines: 1,
          decoration: InputDecoration(
              errorText: widget.controller.text.isEmpty
                  ? "Value Can't Be Empty"
                  : null,
              label: Text(
                widget.hint,
                style: TextStyle(color: black3),
              ),
              // labelText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.black12,
              prefixIcon: Icon(widget.icon),
              hintText: 'Type here'),
        ),
      ),
    );
  }
}
