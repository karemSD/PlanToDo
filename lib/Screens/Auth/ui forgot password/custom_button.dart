import 'package:flutter/material.dart';
import 'package:mytest/Screens/Auth/ui%20forgot%20password/size_config.dart';


class CustomGeneralButton extends StatelessWidget {
  const CustomGeneralButton({
    super.key,
    required this.text,
    this.height,
    this.onTap,
    required this.radius,
    required this.listColors,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.sizeIcon,
    this.horizontalPadding,
  });
  final IconData? icon;
  final List<Color> listColors;
  final double radius;
  final String? text;
  final double? height;
  final VoidCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? sizeIcon;
  final EdgeInsets? horizontalPadding;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: horizontalPadding,
        height: SizeConfig.defaultSize! * 5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: listColors,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
