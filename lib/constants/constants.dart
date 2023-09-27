import 'package:flutter/material.dart';

import '../Data/data_model.dart';
import '../Screens/Dashboard/category.dart';
import '../Screens/Dashboard/dashboard.dart';
import '../Screens/Dashboard/invitions.dart';
import '../Screens/Dashboard/notifications.dart';
import '../Screens/Dashboard/projects.dart';

import '../Values/values.dart';
import '../widgets/Chat/online_user.dart';

String tabSpace = "\t\t\t";

final List<Widget> dashBoardScreens = [
  Dashboard(),
  ProjectScreen(),
  CategoryScreen(),
  Invitions()
];

List<Color> progressCardGradientList = [
  //grenn
  HexColor.fromHex("87EFB5"),
  //blue
  HexColor.fromHex("8ABFFC"),
  //pink
  HexColor.fromHex("EEB2E8"),
];

// final onlineUsers = List.generate(
//     AppData.onlineUsers.length,
//     (index) => OnlineUser(
//           image: AppData.onlineUsers[index]['profileImage'],
//           imageBackground: AppData.onlineUsers[index]['color'],
//           userName: AppData.onlineUsers[index]['name'],
//         ));
