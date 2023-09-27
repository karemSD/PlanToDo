import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;
  final Color cursorColor;
  final Color iconColor;
  final Color editTextBackgroundColor;

  const RoundedInputField(
      {super.key,
      required this.hintText,
      this.icon = Icons.person,
      required this.onChanged,
      required this.textEditingController,
      required this.cursorColor,
      required this.iconColor,
      required this.editTextBackgroundColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: editTextBackgroundColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        controller: textEditingController,
        onChanged: onChanged,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: iconColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
