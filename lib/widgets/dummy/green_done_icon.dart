import 'package:flutter/material.dart';
import '../../Values/values.dart';

class GreenDoneIcon extends StatelessWidget {
  const GreenDoneIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: HexColor.fromHex("78B462")),
          child: const Icon(Icons.done, color: Colors.white)),
    );
  }
}
// the Developer karem saad (KaremSD)