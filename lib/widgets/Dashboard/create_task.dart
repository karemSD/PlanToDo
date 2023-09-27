import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/widgets/Dashboard/sheet_goto_calendar.dart';

import '../../BottomSheets/bottom_sheets.dart';
import '../../Screens/Task/set_assignees.dart';
import '../../Values/values.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Forms/form_input_unlabelled.dart';
import '../add_sub_icon.dart';
import '../dummy/profile_dummy.dart';
import 'dashboard_add_project_sheet.dart';

// ignore: must_be_immutable
class CreateTaskBottomSheet extends StatelessWidget {
  CreateTaskBottomSheet({Key? key}) : super(key: key);

  final TextEditingController _taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.contacts, color: Colors.white),
              AppSpaces.horizontalSpace10,
              Text("Unity Dashboard  ",
                  style: GoogleFonts.lato(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              const Icon(Icons.expand_more, color: Colors.white),
            ]),
            AppSpaces.verticalSpace20,
            Row(
              children: [
                Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          HexColor.fromHex("FD916E"),
                          HexColor.fromHex("FFE09B")
                        ]))),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: UnlabelledFormInput(
                    placeholder: "Task Name ....",
                    autofocus: true,
                    keyboardType: "text",
                    controller: _taskNameController,
                    obscureText: false,
                  ),
                ),
              ],
            ),
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                onTap: () {
                  Get.to(() => const SetAssigneesScreen());
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDummy(
                          imageType: ImageType.Assets,
                          color: HexColor.fromHex("94F0F1"),
                          dummyType: ProfileDummyType.Image,
                          scale: 1.5,
                          image: "assets/man-head.png"),
                      AppSpaces.horizontalSpace10,
                      const CircularCardLabel(
                        label: 'Assigned to',
                        value: 'Dereck Boyle',
                        color: Colors.white,
                      )
                    ]),
              ),
              SheetGoToCalendarWidget(
                cardBackgroundColor: HexColor.fromHex("7DBA67"),
                textAccentColor: HexColor.fromHex("A9F49C"),
                value: 'Today 3:00PM',
                label: 'Due Date',
              )
            ]),
            // Spacer(),
            AppSpaces.verticalSpace20,

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: Utils.screenWidth * 0.6,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BottomSheetIcon(icon: Icons.local_offer_outlined),
                      Transform.rotate(
                          angle: 195.2,
                          child:
                              const BottomSheetIcon(icon: Icons.attach_file)),
                      const BottomSheetIcon(icon: FeatherIcons.flag),
                      const BottomSheetIcon(icon: FeatherIcons.image)
                    ]),
              ),
              AddSubIcon(
                scale: 0.8,
                color: AppColors.primaryAccentColor,
                callback: _addProject,
              ),
            ])
          ]),
        ),
      ]),
    );
  }

  void _addProject() {
    showAppBottomSheet(
      const DashboardAddProjectSheet(),
      isScrollControlled: true,
      popAndShow: true,
    );
  }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;
  const BottomSheetIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      iconSize: 32,
      onPressed: null,
    );
  }
}
