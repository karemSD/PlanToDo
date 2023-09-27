import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Projects/searchForMemberController.dart';

import 'package:mytest/controllers/userController.dart';
import 'package:mytest/controllers/waitingMamberController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/models/team/waitingMamber.dart';
import 'package:mytest/services/collectionsrefrences.dart';

import 'package:mytest/widgets/Forms/search_box2.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';

import 'package:mytest/widgets/inactive_employee_card.dart';

import '../../Data/data_model.dart';
import '../../Values/values.dart';

import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';

import '../../widgets/Navigation/app_header.dart';

import '../../widgets/dummy/profile_dummy.dart';
import '../Profile/profile_overview.dart';
import 'addUserToTeamScreenController.dart';

class SearchForMembers extends StatefulWidget {
  final bool newTeam;
  final TeamModel? teamModel;
  const SearchForMembers(
      {Key? searchForMembersKey,
      this.teamModel,
      required List<UserModel?>? users,
      required this.newTeam})
      : super(key: searchForMembersKey);
  static String search = "";
  @override
  State<SearchForMembers> createState() => _SearchForMembersState();
}

class _SearchForMembersState extends State<SearchForMembers> {
  final searchController = TextEditingController();
  final GlobalKey<_SearchForMembersState> searchForMembersKey =
      GlobalKey<_SearchForMembersState>();
  final DashboardMeetingDetailsScreenController addWatingMemberController =
      Get.find<DashboardMeetingDetailsScreenController>();

  void clearSearch() {
    setState(() {
      SearchForMembers.search = "";
      searchController.clear();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TaskezAppHeader(
                    title: "Search for Members",
                    widget: GestureDetector(
                      onTap: () async {
                        bool fcmStutas =
                            await FcmNotifications.getNotificationStatus();
                        Get.to(() => ProfileOverview(
                              isSelected: fcmStutas,
                            ));
                      },
                      child: StreamBuilder<DocumentSnapshot<UserModel>>(
                          stream: UserController().getUserByIdStream(
                              id: AuthService
                                  .instance.firebaseAuth.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return ProfileDummy(
                              imageType: ImageType.Network,
                              color: Colors.white,
                              dummyType: ProfileDummyType.Image,
                              image: snapshot.data!.data()!.imageUrl,
                              scale: 1.2,
                            );
                          }),
                    ),
                  ),
                ),
                AppSpaces.verticalSpace40,
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecorationStyles.fadingGlory,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: DecoratedBox(
                        decoration: BoxDecorationStyles.fadingInnerDecor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GetBuilder<SearchForMembersController>(
                            init: SearchForMembersController(),
                            builder: (controller) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchBox2(
                                  onClear: () {
                                    controller.clearSearch();
                                    // setState(() {
                                    //   searchController.clear();
                                    //   SearchForMembers.search = "";
                                    // });
                                  },
                                  controller: controller.searchController,
                                  placeholder: "Search ....",
                                  onChanged: (value) {
                                    controller.searchQuery.value = value;
                                    controller.update();
                                    // setState(() {
                                    //   SearchForMembers.search = value;
                                    // });
                                  },
                                ),
                                AppSpaces.verticalSpace20,
                                Expanded(
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child:
                                        StreamBuilder<QuerySnapshot<UserModel>>(
                                      stream:
                                          UserController().getAllUsersStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              snapshot.error.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  //   Icons.heart_broken_outlined,
                                                  color: Colors.lightBlue,
                                                  size: 120,
                                                ),
                                                AppSpaces.verticalSpace10,
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              ]);
                                        }

                                        List<UserModel> users = [];
                                        for (var element
                                            in snapshot.data!.docs) {
                                          users.add(element.data());
                                        }
                                        if (controller
                                                .searchQuery.value.isEmpty ||
                                            controller.searchController.text
                                                .isEmpty) {
                                          return const Center(
                                            child: Text(
                                              "Please Enter Any Username To Search for",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                        final filteredUsers =
                                            users.where((user) {
                                          final userName =
                                              user.userName?.toLowerCase() ??
                                                  '';

                                          return userName.contains(
                                                  controller.searchQuery
                                                      //   searchController.text
                                                      .toLowerCase()) &&
                                              user.id !=
                                                  AuthService
                                                      .instance
                                                      .firebaseAuth
                                                      .currentUser!
                                                      .uid;
                                        }).toList();
                                        if (filteredUsers.isEmpty) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //
                                                const Icon(
                                                  Icons.search_off,
                                                  //   Icons.heart_broken_outlined,
                                                  color: Colors.red,
                                                  size: 120,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 50,
                                                      vertical: 40),
                                                  child: Center(
                                                    child: Text(
                                                      "No User Found Wit UserName ",
                                                      style:
                                                          GoogleFonts.fjallaOne(
                                                        color: Colors.white,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          itemCount: filteredUsers.length,
                                          itemBuilder: (context, index) {
                                            final user = filteredUsers[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InactiveEmployeeCard(
                                                onTap: () async {
                                                  try {
                                                    if (!widget.newTeam) {
                                                      WaitingMemberModel
                                                          waitingMemberModel =
                                                          WaitingMemberModel(
                                                              teamIdParameter:
                                                                  widget
                                                                      .teamModel!
                                                                      .id,
                                                              idParameter:
                                                                  watingMamberRef
                                                                      .doc()
                                                                      .id,
                                                              userIdParameter:
                                                                  user.id,
                                                              createdAtParameter:
                                                                  DateTime
                                                                      .now(),
                                                              updatedAtParameter:
                                                                  DateTime
                                                                      .now());
                                                      await WaitingMamberController()
                                                          .addWaitingMamber(
                                                              waitingMemberModel:
                                                                  waitingMemberModel);
                                                    }
                                                    if (widget.newTeam) {
                                                      addWatingMemberController
                                                          .addUser(user);
                                                      addWatingMemberController
                                                          .update();
                                                    }
                                                    // CustomSnackBar.showSuccess(
                                                    //     "the user Invited Successfully");
                                                    addWatingMemberController
                                                        .update();
                                                    Get.close(1);
                                                    addWatingMemberController
                                                        .update();
                                                  } on Exception catch (e) {
                                                    CustomSnackBar.showError(
                                                        e.toString());
                                                  }
                                                },
                                                user: user,
                                                color: Colors.white,
                                                userImage: user.imageUrl,
                                                userName: user.name!,
                                                bio: user.bio ?? "",
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AppSpaces.verticalSpace20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}











// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:mytest/controllers/userController.dart';
// import 'package:mytest/models/User/User_model.dart';
// import 'package:mytest/widgets/Forms/search_box2.dart';
// import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
// import 'package:mytest/widgets/inactive_employee_card.dart';

// import '../../Values/values.dart';
// import '../../models/team/Team_model.dart';
// import '../../services/auth_service.dart';
// import '../../services/notification_service.dart';
// import '../../widgets/DarkBackground/darkRadialBackground.dart';
// import '../../widgets/Navigation/app_header.dart';
// import '../../widgets/dummy/profile_dummy.dart';
// import '../Profile/profile_overview.dart';

// class SearchForMembersController extends GetxController {
//   final searchController = TextEditingController();
//   RxString searchQuery = ''.obs;
//   RxList<UserModel> users = <UserModel>[].obs;
//   RxList<UserModel> filteredUsers = <UserModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     searchQuery.listen((query) {
//       filterUsers(query);
//     });
//     fetchUsers();
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     super.onClose();
//   }

//   void fetchUsers() {
//     final userStream = UserController().getAllUsersStream();
//     users.bindStream(userStream
//         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()));
//   }

//   void filterUsers(String query) {
//     if (users.isEmpty) return;

//     filteredUsers.value = users
//         .where((user) =>
//             user.userName?.toLowerCase().contains(query.toLowerCase()) ?? false)
//         .toList();
//   }

//   void clearSearch() {
//     searchController.clear();
//     searchQuery.value = '';
//     update();
//   }
// }

// class SearchForMembers extends StatelessWidget {
//   final bool newTeam;
//   final TeamModel? teamModel;

//   const SearchForMembers({
//     Key? key,
//     required List<UserModel?>? users,
//     required this.newTeam,
//     this.teamModel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final searchController = Get.put(SearchForMembersController());

//     return Scaffold(
//       body: Stack(
//         children: [
//           DarkRadialBackground(
//             color: HexColor.fromHex("#181a1f"),
//             position: "topLeft",
//           ),
//           // Background widgets
//           // ...

//           Padding(
//             padding: const EdgeInsets.only(top: 60.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20, left: 20),
//                   child: TaskezAppHeader(
//                     title: "Search for Members",
//                     widget: GestureDetector(
//                       onTap: () async {
//                         bool fcmStutas =
//                             await FcmNotifications.getNotificationStatus();
//                         Get.to(() => ProfileOverview(
//                               isSelected: fcmStutas,
//                             ));
//                       },
//                       child: StreamBuilder<DocumentSnapshot<UserModel>>(
//                           stream: UserController().getUserByIdStream(
//                               id: AuthService
//                                   .instance.firebaseAuth.currentUser!.uid),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             }
//                             return ProfileDummy(
//                               imageType: ImageType.Network,
//                               color: Colors.white,
//                               dummyType: ProfileDummyType.Image,
//                               image: snapshot.data!.data()!.imageUrl,
//                               scale: 1.2,
//                             );
//                           }),
//                     ),
//                   ),
//                 ),
//                 // Header widget
//                 // ...

//                 AppSpaces.verticalSpace40,
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     // Container decoration
//                     // ...

//                     child: Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: DecoratedBox(
//                         decoration: BoxDecorationStyles.fadingInnerDecor,
//                         // Decorated box decoration
//                         // ...

//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SearchBox2(
//                                 onClear: () {
//                                   searchController.clearSearch();
//                                 },
//                                 controller: searchController.searchController,
//                                 placeholder: "Search ....",
//                                 onChanged: (value) {
//                                   searchController.searchQuery.value = value;
//                                 },
//                               ),
//                               AppSpaces.verticalSpace20,
//                               Expanded(
//                                 child: MediaQuery.removePadding(
//                                   context: context,
//                                   removeTop: true,
//                                   child: Obx(() {
//                                     if (searchController.users.isEmpty) {
//                                       return const Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     }

//                                     if (searchController
//                                         .filteredUsers.isEmpty) {
//                                       return const Center(
//                                         child: Text(
//                                           "Please Enter Any Username To Search for",
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       );
//                                     }

//                                     return ListView.builder(
//                                       itemCount:
//                                           searchController.filteredUsers.length,
//                                       itemBuilder: (context, index) {
//                                         final user = searchController
//                                             .filteredUsers[index];
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: InactiveEmployeeCard(
//                                             onTap: () async {
//                                               try {
//                                                 // Handle user selection
//                                                 // ...

//                                                 CustomSnackBar.showSuccess(
//                                                     "the user Invited Successfully");
//                                               } on Exception catch (e) {
//                                                 CustomSnackBar.showError(
//                                                     e.toString());
//                                               }
//                                             },
//                                             user: user,
//                                             color: Colors.white,
//                                             userImage: user.imageUrl,
//                                             userName: user.name!,
//                                             bio: user.bio ?? "",
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 AppSpaces.verticalSpace20,
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
