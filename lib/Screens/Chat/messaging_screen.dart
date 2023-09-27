import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Values/values.dart';
import '../../widgets/Chat/online_user.dart';
import '../../widgets/Chat/post_bottom_widget.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Navigation/app_header.dart';

class MessagingScreen extends StatelessWidget {
  final String userName;
  final String color;
  final String image;
  const MessagingScreen(
      {Key? key,
      required this.userName,
      required this.color,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> sentImage = [
      "assets/slider-background-1.png",
      "assets/slider-background-2.png",
      "assets/slider-background-3.png"
    ];

    List<SentImage> imageCards = List.generate(
        sentImage.length, (index) => SentImage(image: sentImage[index]));
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TaskezAppHeader(
                  title: userName,
                  messagingPage: true,
                  widget: Row(children: [
                    const Icon(Icons.phone, color: Colors.white),
                    AppSpaces.horizontalSpace20,
                    Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                width: 3, color: HexColor.fromHex("31333D"))),
                        child: const Center(
                            child: Icon(Icons.more_vert, color: Colors.white))),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
      //Chat
      Positioned(
          top: 80,
          child: SizedBox(
              width: Utils.screenWidth,
              height: Utils.screenHeight * 2,
              child: ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MessengerDetails(
                        image: image, color: color, userName: userName),
                    Padding(
                      padding: const EdgeInsets.only(left: 70.0),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: 250,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text("Hi man, how are you doing?",
                              style: GoogleFonts.lato(color: Colors.white))),
                    )
                  ],
                ),
                AppSpaces.verticalSpace20,
                const SenderMessage(message: "Doing well, thanks! 👋"),
                AppSpaces.verticalSpace20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MessengerDetails(
                        image: image, color: color, userName: userName),
                    Padding(
                      padding: const EdgeInsets.only(left: 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 250,
                              //height: 50,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50)),
                              ),
                              child: Text("Just one question 😂",
                                  style:
                                      GoogleFonts.lato(color: Colors.white))),
                          AppSpaces.verticalSpace10,
                          Container(
                              alignment: Alignment.centerLeft,
                              width: 250,
                              //height: 50,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50)),
                              ),
                              child: Text(
                                  "Can you please send me your latest mockup? ",
                                  style:
                                      GoogleFonts.lato(color: Colors.white))),
                          AppSpaces.verticalSpace10,
                          SizedBox(
                            height: 120,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [...imageCards]),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                AppSpaces.verticalSpace20,
                const SenderMessage(message: "Sure, wait for a minute."),
                AppSpaces.verticalSpace20,
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBackgroundColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.more_horiz,
                                color: HexColor.fromHex("7F8088"), size: 40)),
                      ],
                    ))
              ]))),
      const PostBottomWidget(label: "Write a message")
    ]));
  }
}

class SentImage extends StatelessWidget {
  final String image;
  const SentImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
              width: 200, fit: BoxFit.fitWidth, image: AssetImage(image))),
    );
  }
}

class SenderMessage extends StatelessWidget {
  final String message;
  const SenderMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              width: 200,
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryAccentColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child:
                  Text(message, style: GoogleFonts.lato(color: Colors.white))),
        ],
      ),
    );
  }
}

class MessengerDetails extends StatelessWidget {
  const MessengerDetails({
    Key? key,
    required this.image,
    required this.color,
    required this.userName,
  }) : super(key: key);

  final String image;
  final String color;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          OnlineUser(
            image: image,
            imageBackground: color,
            userName: userName,
          ),
          AppSpaces.horizontalSpace10,
          const TimeReceipt(time: "12:11 PM")
        ],
      ),
    );
  }
}

class TimeReceipt extends StatelessWidget {
  final String time;
  const TimeReceipt({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(time, style: GoogleFonts.lato(color: Colors.white));
  }
}
