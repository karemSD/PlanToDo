// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Projects/searchForMembers.dart';
import '../../Values/values.dart';

class SearchBox2 extends StatelessWidget {
  final String placeholder;
  final void Function()? onClear; // Add the onClear callback
  //final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  const SearchBox2(
      {Key? key,
      // required this.suffixIcon,
      required this.onClear,
      required this.placeholder,
      this.controller,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(FeatherIcons.search, color: Colors.white),
        ),
        suffixIcon: controller!.text.isEmpty
            ? null
            : InkWell(
                onTap: onClear,
                child: const Icon(FontAwesomeIcons.solidTimesCircle,
                    color: Colors.white70, size: 20),
              ),
        hintText: placeholder,
        hintStyle: GoogleFonts.lato(
            //fontWeight: FontWeight.bold,
            fontSize: 18,
            color: HexColor.fromHex("3C3E49")),
        filled: true,
        fillColor: AppColors.primaryBackgroundColor,
        // enabledBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        //   borderSide: BorderSide(color: HexColor.fromHex("3C3E49")),
        // ),
        // focusedBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        //   borderSide: BorderSide(color: HexColor.fromHex("BEF0B2")),
        // ),
      ),
    );
  }
}
