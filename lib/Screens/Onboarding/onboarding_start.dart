import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Data/data_model.dart';
import 'package:mytest/constants/app_constans.dart';

import 'dart:math' as math;

import '../../Values/values.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Onboarding/background_image.dart';
import '../../widgets/Onboarding/bubble.dart';
import '../../widgets/Onboarding/loading_stickers.dart';
import '../../widgets/Shapes/background_hexagon.dart';
import 'onboarding_carousel.dart';

class OnboardingStart extends StatelessWidget {
  const OnboardingStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //لون خلفية الشاشة
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "Lefttop",
          ),
          //الشكر المربع
          Positioned(
            top: Utils.screenHeight,
            left: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["square_shape_L"],
            child: Transform.rotate(
              angle: -math.pi / 2,
              child: CustomPaint(painter: BackgroundHexagon()),
            ),
          ),
          //صورة ابو الطاقية الكبيرة
          Positioned(
            top: Utils.screenHeight * 0.7,
            left: AppConstants.dir[AppConstants.dir_key.tr]["big_picture_L"],
            child: BackgroundImage(
              scale: 1.0,
              image: AppConstants.dir_key.tr == 'ar'
                  ? "assets/man-head-R.png"
                  : "assets/man-head.png",
              gradient: [
                HexColor.fromHex("92ECEC"),
                HexColor.fromHex("92ECEC"),
              ],
            ),
          ),
          //صورة البنت يلي بالنص يلي لونها  برتقالي
          Positioned(
            top: Utils.screenHeight * 0.50,
            left: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["medium_picture_L"],
            child: BackgroundImage(
              scale: 0.5,
              image: AppConstants.dir_key.tr == 'ar'
                  ? "assets/head_cut-R.png"
                  : "assets/head_cut.png",
              gradient: [
                HexColor.fromHex("FD9871"),
                HexColor.fromHex("F7D092"),
              ],
            ),
          ),
          //صورة البنت يلي لونها  موف يلي هيي اول صورة  بالسكرين
          Positioned(
            top: Utils.screenHeight * 0.30,
            left: AppConstants.dir[AppConstants.dir_key.tr]["small_picture_L"],
            child: BackgroundImage(
              scale: 0.4,
              image: AppConstants.dir_key.tr == 'ar'
                  ? "assets/girl_smile-R.png"
                  : "assets/girl_smile.png",
              gradient: [
                HexColor.fromHex("#a7b2fd"),
                HexColor.fromHex("#c1a0fd"),
              ],
            ),
          ),

          //end of images

          //Bubble
          //الفقاعة الموف الكبيرة
          Positioned(
            top: 80,
            left: AppConstants.dir[AppConstants.dir_key.tr]["big_bubble_L"],
            child: Bubble(1.0, HexColor.fromHex("A06AF9")),
          ),
          //الفقاعة الوردية الصغيررة
          Positioned(
            top: 130,
            left: AppConstants.dir[AppConstants.dir_key.tr]["small_bubble_L"],
            child: Bubble(0.6, HexColor.fromHex("FDA5FF")),
          ),
          //end bubble
          //الستكر الاول من فوق
          Positioned(
            top: Utils.screenHeight * 0.12,
            left: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["one_sticker_L"],
            child: LoadingSticker(
              gradients: [
                HexColor.fromHex("#F3EEAE"),
                HexColor.fromHex("F3EFAB"),
                HexColor.fromHex("#4A88FE"),
              ],
            ),
          ),
          //الستكر يلي بنص  الثاني من  فوق
          Positioned(
            top: Utils.screenHeight * 0.50,
            left: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["two_sticker_L"],
            child: LoadingSticker(
              gradients: [
                HexColor.fromHex("#a7b2fd"),
                HexColor.fromHex("#c1a0fd"),
              ],
            ),
          ),
          //الستكر الاخيرة  يعني اول  وحدة من  تحت
          Positioned(
            top: Utils.screenHeight * 0.7,
            left: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["three_sticker_L"],
            right: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["three_sticker_R"],
            child: LoadingSticker(
              gradients: [
                HexColor.fromHex("#a7b2fd"),
                HexColor.fromHex("#c1a0fd"),
              ],
            ),
          ),
          Positioned(
            top: Utils.screenHeight * 1.3,
            right: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["triangle_shape_R"],
            left: Utils.screenWidth *
                AppConstants.dir[AppConstants.dir_key.tr]["triangle_shape_L"],
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: InkWell(
                onTap: () {
                  Get.to(() => const OnboardingCarousel());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: HexColor.fromHex("B6FFE5"),
                  ),
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      alignment: AppConstants.dir_key.tr == 'ar'
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      padding: const EdgeInsets.only(
                        top: 85,
                      ),
                      child: Icon(
                        AppConstants.dir_key.tr == 'ar'
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                        size: 40,
                      ),
                      // child: Icon(
                      //   Localizations.localeOf(context).languageCode == 'ar'
                      //       ? Icons.arrow_back
                      //       : Icons.arrow_forward,
                      //   size: 40,
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: AppConstants.dir[AppConstants.dir_key.tr]["get_started_B"],
            left: AppConstants.dir[AppConstants.dir_key.tr]["get_started_L"],
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppConstants.task_management_key.tr,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: HexColor.fromHex("FDA5FF"),
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: '🙌',
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppConstants.lets_create_a_space_for_your_workflows_key.tr,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpaces.verticalSpace20,
                  SizedBox(
                    width: 180,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const OnboardingCarousel());
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          HexColor.fromHex("246CFE"),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                              color: HexColor.fromHex("246CFE"),
                            ),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppConstants.get_started_key.tr,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
