import 'package:flutter/material.dart';
import 'package:mytest/Values/values.dart';

class SquareButtonIcon extends StatelessWidget {
  SquareButtonIcon({super.key, required this.imagePath, required this.onTap});
  String imagePath;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Utils.screenWidth * 0.16,
            vertical: Utils.screenHeight * 0.025),
        decoration: BoxDecoration(
            color: null,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            )),
        child: Image.asset(
          imagePath,
          height: Utils.screenHeight * 0.08,
        ),
      ),
    );
  }
}
