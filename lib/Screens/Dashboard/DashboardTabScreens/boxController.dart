import 'package:get/get.dart';

class BoxController extends GetxController {
  RxInt selectedTabIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
    update();
  }
}
