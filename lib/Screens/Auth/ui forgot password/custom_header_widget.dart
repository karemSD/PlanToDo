// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:flutter/material.dart';
import 'package:mytest/Screens/Auth/ui%20forgot%20password/size_config.dart';


class CustomHeaderWidget extends StatelessWidget {
  const CustomHeaderWidget({
    super.key,
    required this.height,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth!;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          ClipPath(
            clipper: ShapeClipper(
              [
                Offset(width / 5, height),
                Offset(width / 10 * 5, height - 60),
                Offset(width / 5 * 4, height + 30),
                Offset(width, height - 18)
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Colors.pink,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          ClipPath(
            clipper: ShapeClipper(
              [
                Offset(width / 3, height + 20),
                Offset(width / 10 * 8, height - 60),
                Offset(width / 5 * 4, height - 60),
                Offset(width, height - 20)
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Colors.pink,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          ClipPath(
            clipper: ShapeClipper(
              [
                Offset(width / 5, height),
                Offset(width / 2, height - 40),
                Offset(width / 5 * 4, height - 80),
                Offset(width, height - 0)
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade900,
                    Colors.pink,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [.3, .6, .9],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.pink,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, height),
              Offset(width / 2, height - 40),
              Offset(width / 5 * 4, height - 80),
              Offset(width, height - 20)
            ]),
          ),
          //   Visibility(
          //     visible: true,
          //     child: SizedBox(
          //       height: height - 40,
          //       child: Center(
          //         child: Container(
          //           margin: const EdgeInsets.all(20),
          //           padding: const EdgeInsets.only(
          //             left: 5.0,
          //             top: 20.0,
          //             right: 5.0,
          //             bottom: 20.0,
          //           ),
          //           decoration: BoxDecoration(
          //             borderRadius: const BorderRadius.only(
          //               topLeft: Radius.circular(100),
          //               topRight: Radius.circular(100),
          //               bottomLeft: Radius.circular(60),
          //               bottomRight: Radius.circular(60),
          //             ),
          //             border: Border.all(width: 5, color: Colors.white),
          //           ),
          //           child: SvgPicture.asset(
          //             "assets/icon/feather-svg.svg",
          //             colorFilter:
          //                 const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          //             width: SizeConfig.screenWidth!*.2,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
