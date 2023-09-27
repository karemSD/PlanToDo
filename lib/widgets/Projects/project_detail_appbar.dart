import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/widgets/Projects/project_badge.dart';

import '../../Values/values.dart';

class ProjectDetailAppBar extends StatelessWidget {

  final String projectName;
  final VoidCallback? iconTapped;
  final String projeImagePath;

  const ProjectDetailAppBar(
      {Key? key,
      
      required this.projectName,
      required this.projeImagePath,
      this.iconTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ColouredProjectBadge(projeImagePath: projeImagePath),
              AppSpaces.horizontalSpace20,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(projectName,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(projeImagePath,
                    style: GoogleFonts.lato(color: HexColor.fromHex("626677"))),
              ])
            ],
          ),
          Row(children: [
            const Icon(FeatherIcons.star, color: Colors.white, size: 30),
            AppSpaces.horizontalSpace20,
            InkWell(
                onTap: iconTapped,
                child:
                    const Icon(Icons.more_horiz, color: Colors.white, size: 30))
          ])
        ]);
  }
}
