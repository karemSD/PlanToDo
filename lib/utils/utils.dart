part of values;

class Utils {
  static final double screenWidth = Get.width;
  static final double screenHeight = Get.width;
}

class SineCurve extends Curve {
  final double count;

  const SineCurve({this.count = 3});

  // t = x
  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;
    return val; //f(x)
  }
}

Widget buildStackedImagesOfTeams(
    {List<TeamModel?>? teams,
    TextDirection direction = TextDirection.rtl,
    String? numberOfMembers,
    bool addMore = true,
    required VoidCallback? onTap}) {
  const double size = 50;
  const double xShift = 20;

  Container lastContainer = Container(
      width: 40,
      height: 40,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Center(
        child: Text(numberOfMembers!,
            style: GoogleFonts.lato(
                color: HexColor.fromHex("226AFD"),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ));

  GestureDetector iconContainer = GestureDetector(
    onTap: onTap,
    child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.primaryAccentColor, shape: BoxShape.circle),
        child: const Icon(FontAwesomeIcons.plusMinus, color: Colors.white)),
  );

  final items = List.generate(
      teams!.length > 5 ? 5 : teams.length,
      (index) => ProfileDummy(
          imageType: ImageType.Network,
          color: Colors.white,
          dummyType: ProfileDummyType.Image,
          image: teams[index]!.imageUrl,
          scale: 1.0));

  return StackedWidgets(
    direction: direction,
    items: [
      ...items,
      //  lastContainer,
      addMore ? iconContainer : const SizedBox(),
    ],
    size: size,
    xShift: xShift,
  );
}

Widget buildStackedImages(
    {List<UserModel?>? users,
    TextDirection direction = TextDirection.rtl,
    String? numberOfMembers,
    bool? addMore,
    required VoidCallback? onTap}) {
  const double size = 50;
  const double xShift = 20;

  Container lastContainer = Container(
      width: 40,
      height: 40,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Center(
        child: Text(numberOfMembers!,
            style: GoogleFonts.lato(
                color: HexColor.fromHex("226AFD"),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ));

  GestureDetector iconContainer = GestureDetector(
    onTap: onTap,
    child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.primaryAccentColor, shape: BoxShape.circle),
        child: const Icon(FontAwesomeIcons.plusMinus, color: Colors.white)),
  );

  final items = List.generate(
      users!.length > 5 ? 5 : users.length,
      (index) => ProfileDummy(
          imageType: ImageType.Network,
          color: Colors.white,
          dummyType: ProfileDummyType.Image,
          image: users[index]!.imageUrl,
          scale: 1.0));

  return StackedWidgets(
    direction: direction,
    items: [
      ...items,
      lastContainer,
      (addMore != null) ? iconContainer : const SizedBox(),
    ],
    size: size,
    xShift: xShift,
  );
}

final DashboardMeetingDetailsScreenController userController =
    Get.find<DashboardMeetingDetailsScreenController>();
Widget buildStackedImagesKaremEdit(
    {TextDirection direction = TextDirection.rtl, bool? addMore}) {
  const double size = 50;
  const double xShift = 20;

  Container lastContainer = Container(
    width: 40,
    height: 40,
    decoration:
        const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Center(
      child: Text(userController.users.length.toString(),
          style: GoogleFonts.lato(
              color: HexColor.fromHex("226AFD"),
              fontSize: 20,
              fontWeight: FontWeight.bold)),
    ),
  );

  Container iconContainer = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: AppColors.primaryAccentColor, shape: BoxShape.circle),
      child: const Icon(Icons.add, color: Colors.white));

  final items = List.generate(
      userController.users.length,
      (index) => ProfileDummy(
          imageType: ImageType.Network,
          color: Colors.white,
          dummyType: ProfileDummyType.Image,
          image: userController.users[index].imageUrl,
          scale: 1.0));

  return StackedWidgets(
    direction: direction,
    items: [
      ...items,
      lastContainer,
      (addMore != null) ? iconContainer : const SizedBox()
    ],
    size: size,
    xShift: xShift,
  );
}

final AddTeamToCreatProjectScreen addTeamToCreatProjectScreen =
    Get.find<AddTeamToCreatProjectScreen>();
Widget buildStackedImagesTeamEdit(
    {TextDirection direction = TextDirection.rtl, bool? addMore}) {
  const double size = 50;
  const double xShift = 20;

  Container lastContainer = Container(
    width: 40,
    height: 40,
    decoration:
        const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Center(
      child: Text(addTeamToCreatProjectScreen.teams.length.toString(),
          style: GoogleFonts.lato(
              color: HexColor.fromHex("226AFD"),
              fontSize: 20,
              fontWeight: FontWeight.bold)),
    ),
  );

  Container iconContainer = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: AppColors.primaryAccentColor, shape: BoxShape.circle),
      child: const Icon(Icons.add, color: Colors.white));

  final items = List.generate(
    addTeamToCreatProjectScreen.teams.length,
    (index) => ProfileDummy(
        imageType: ImageType.Network,
        color: Colors.white,
        dummyType: ProfileDummyType.Image,
        image: addTeamToCreatProjectScreen.teams[index].imageUrl,
        scale: 1.0),
  );

  return StackedWidgets(
    direction: direction,
    items: [
      ...items,
      lastContainer,
      addMore! ? iconContainer : const SizedBox()
    ],
    size: size,
    xShift: xShift,
  );
}

showDialogMethod(BuildContext buildContext) {
  showDialog(
      context: buildContext,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });
}
