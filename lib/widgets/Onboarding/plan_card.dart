import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Values/values.dart';
import '../../constants/constants.dart';
import '../dummy/green_done_icon.dart';

class PlanCard extends StatelessWidget {
  final int selectedIndex;
  final ValueNotifier<int> notifierValue;

  final String header;
  final String subHeader;
  const PlanCard(
      {Key? key,
      required this.selectedIndex,
      required this.notifierValue,
      required this.header,
      required this.subHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          onTap: () {
            notifierValue.value = selectedIndex;
            print(notifierValue.value);
          },
          child: ValueListenableBuilder(
              valueListenable: notifierValue,
              builder: (BuildContext context, _, __) {
                return Container(
                    width: 180,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: RadialGradient(
                        colors: [
                          ...progressCardGradientList,
                        ],
                        center: const Alignment(1, 1),
                        focal: const Alignment(0.3, -0.1),
                        focalRadius: 1.0,
                      ),
                    ),
                    child: notifierValue.value != selectedIndex
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DecoratedBox(
                                decoration:
                                    BoxDecorationStyles.fadingInnerDecor,
                                child: Center(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      const SizedBox(height: 40),
                                      Text(header,
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24)),
                                      AppSpaces.verticalSpace10,
                                      Text(subHeader,
                                          style: GoogleFonts.lato(
                                              color:
                                                  HexColor.fromHex("F7A3F9")))
                                    ]))),
                          )
                        : Stack(children: [
                            Positioned(
                              top: 5,
                              left: 5,
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor.fromHex("181a1f")),
                                  child: const GreenDoneIcon()),
                            ),
                            Center(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  const SizedBox(height: 45),
                                  const Text("🎉", style: TextStyle(fontSize: 40)),
                                  AppSpaces.verticalSpace20,
                                  Text(header,
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                  AppSpaces.verticalSpace10,
                                  Text(subHeader, style: GoogleFonts.lato())
                                ]))
                          ]));
              })),
    );
  }
}
