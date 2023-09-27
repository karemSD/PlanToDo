import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Values/values.dart';

import '../Onboarding/labelled_option.dart';
import 'bottom_sheet_holder.dart';

class ProjectDetailBottomSheet extends StatelessWidget {
  const ProjectDetailBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        ListTile(
          title: Text("PROJECT SETTINGS",
              style: GoogleFonts.lato(fontSize: 12, color: Colors.white30)),
        ),
        Expanded(
          child: ListView(
            children: [
              const LabelledOption(label: 'Share Project', icon: Icons.share),
              const LabelledOption(
                  label: 'Mark all completed', icon: Icons.check_circle),
              const LabelledOption(
                  label: 'Copy', icon: Icons.tag, link: "taskez.io/6734aw"),
              const LabelledOption(
                  label: 'Duplicate Project', icon: Icons.fiber_smart_record),
              const LabelledOption(
                label: 'Set Color',
                icon: Icons.color_lens,
                boxColor: "FFDE72",
              ),
              LabelledOption(
                  label: 'Archive Project',
                  icon: Icons.archive,
                  color: HexColor.fromHex("C55FFF")),
              LabelledOption(
                  label: 'Delect Project',
                  icon: FeatherIcons.trash,
                  color: HexColor.fromHex("FC958E")),
            ],
          ),
        ),
      ],
    );
  }
}
