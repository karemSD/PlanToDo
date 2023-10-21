import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Values/values.dart';

class PrimaryProgressButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final VoidCallback? callback;
  const PrimaryProgressButton({
    Key? key,
    required this.label,
    this.callback,
    this.width,
    this.height,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          width ?? Utils.screenWidth * 0.15, // Adjust the percentage as needed
      height: height ?? Utils.screenHeight * 0.07,
      child: ElevatedButton(
        onPressed: callback,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor.fromHex("246CFE")),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(
                color: HexColor.fromHex("246CFE"),
              ),
            ),
          ),
        ),
        child: Text(
          label,
          style: textStyle ??
              GoogleFonts.lato(
                  fontSize: Utils.screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
        ),
      ),
    );
  }
}
