import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import '../../models/task/UserTaskCategory_model.dart';

class FocusedMenu extends StatelessWidget {
  final Widget widget;
  final double? menuWidth;
  final VoidCallback onClick;
  final List<FocusedMenuItem>? menuItems;
  final Function deleteButton;
  final Function editButton;
  const FocusedMenu(
      {Key? key,
      required this.widget,
      this.menuWidth,
      required this.onClick,
      this.menuItems,
      required this.deleteButton,
      required this.editButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: menuWidth ?? Get.width * 0.5,
      menuItems: menuItems ??
          [
            FocusedMenuItem(
              backgroundColor: Colors.grey,
              title: const Text("edit"),
              trailingIcon: const Icon(Icons.edit),
              onPressed: editButton,
            ),
            FocusedMenuItem(
              title: const Text(
                "delete",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              trailingIcon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: deleteButton,
            )
          ],
      onPressed: onClick,
      menuBoxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      menuOffset: 10,
      openWithTap: false,
      child: widget,
    );
  }
}
