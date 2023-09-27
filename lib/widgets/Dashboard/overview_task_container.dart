import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/widgets/Dashboard/task_container_image.dart';
import '../../Values/values.dart';

class OverviewTaskContainer extends StatelessWidget {
  final Color backgroundColor;
  final String imageUrl;
  final String numberOfItems;
  final String cardTitle;
  final VoidCallback? onButtonClick;
  OverviewTaskContainer(
      {Key? key,
      required this.imageUrl,
      required this.backgroundColor,
      required this.cardTitle,
      this.onButtonClick,
      required this.numberOfItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onButtonClick != null) {
          onButtonClick!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            height: 80,
            decoration: BoxDecoration(
                color: AppColors.primaryBackgroundColor,
                borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TaskContainerImage(
                      imageUrl: imageUrl,
                      backgroundColor: backgroundColor,
                    ),
                    AppSpaces.horizontalSpace20,
                    Text(cardTitle,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20))
                  ],
                ),
                Row(children: [
                  Text(numberOfItems,
                      style: GoogleFonts.lato(
                          color: backgroundColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                  AppSpaces.horizontalSpace20,
                  const Icon(Icons.chevron_right, color: Colors.white, size: 30)
                ])
              ],
            )),
      ),
    );
  }
}
