import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/widgets/Onboarding/gradient_color_ball.dart';

import '../../Values/values.dart';
import '../Buttons/primary_progress_button.dart';

class ColorSelectionDialog extends StatefulWidget {
  final Function(String) onSelectedColorChanged;
  final String initialColor;

  const ColorSelectionDialog(
      {super.key,
      required this.onSelectedColorChanged,
      required this.initialColor});

  @override
  _ColorSelectionDialogState createState() => _ColorSelectionDialogState();
}

class _ColorSelectionDialogState extends State<ColorSelectionDialog> {
  final ValueNotifier<int> selectedColorIndex = ValueNotifier<int>(0);
  // Define the color variable
  @override
  void initState() {
    super.initState();
    // Set the initial selected color index based on the initialColor value
    int initialIndex = AppColors.ballColors
        .indexWhere((colors) => colorToHex(colors[0]) == widget.initialColor);
    if (initialIndex != -1) {
      selectedColorIndex.value = initialIndex;
    }
  }

  String getSelectedColor() {
    Color color = AppColors.ballColors[selectedColorIndex.value][0];
    return colorToHex(color);
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HexColor.fromHex("#181a1f"),
      title: Text('Choose Color', style: AppTextStyles.header2),
      content: Wrap(
        alignment: WrapAlignment.start,
        children: List.generate(
          AppColors.ballColors.length,
          (index) => GradientColorBall(
            valueChanger: selectedColorIndex,
            selectIndex: index,
            gradientList: [
              ...AppColors.ballColors[index],
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Close',
                style: GoogleFonts.lato(
                  color: HexColor.fromHex("616575"),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PrimaryProgressButton(
              width: 120,
              label: 'OK',
              callback: () {
                // Do something with the selected color
                String selectedColor = getSelectedColor();
                print('Selected color index: ${selectedColorIndex.value}');
                print('Selected color: $selectedColor');
                widget.onSelectedColorChanged(getSelectedColor());
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      ],
    );
  }
}
