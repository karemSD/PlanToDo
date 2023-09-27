import 'package:flutter/material.dart';

import '../../Values/values.dart';
import '../../widgets/Chat/add_chat_icon.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Navigation/app_header.dart';

class Projects extends StatelessWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          const Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskezAppHeader(
                        title: "Chat",
                        widget: AppAddIcon(),
                      ),
                      AppSpaces.verticalSpace20,
                    ]),
              ))
        ],
      ),
    );
  }
}
