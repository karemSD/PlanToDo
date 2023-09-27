import 'package:get/get.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';

class AddTeamToCreatProjectScreen extends GetxController {
  RxList<TeamModel> teams = <TeamModel>[].obs;

  void addUser(TeamModel user) {
    print("add team ");
    bool found = false;
    // for (var element in teams) {
    //   if (user.id == element.id) {
    //     print("add team2 ");

    //     found = true;
    //     break;
    //   }
    // }

    // if (found) {
    //   CustomSnackBar.showError("This User Already added");
    // } else {
    //   print("add team 3");

    //   teams.add(user);
    //   update();
    // }
    if (teams.isEmpty) {
      teams.add(user);
    } else {
      teams.first = user;
    }
    update();
    teams;
  }

  void removeUsers() {
    teams.clear();
    update();
  }

  @override
  void onClose() {
    removeUsers();
    super.onClose();
  }
}
