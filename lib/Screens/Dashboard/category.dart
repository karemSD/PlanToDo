import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Dashboard/search_bar_animation.dart';
import 'package:mytest/controllers/user_task_controller.dart';

import '../../BottomSheets/bottom_sheets.dart';
import '../../Values/values.dart';
import '../../controllers/categoryController.dart';
import '../../models/task/UserTaskCategory_model.dart';
import '../../pages/home.dart';
import '../../services/auth_service.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/User/categoryCardVertical.dart';
import '../../widgets/add_sub_icon.dart';

enum CategorySortOption {
  name,
  createDate,
  updatedDate,
  // Add more sorting options if needed
}

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key? key}) : super(key: key);
  static String id = "/NotificationScreen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TaskCategoryController taskCategoryController =
      Get.put(TaskCategoryController());
  TextEditingController editingController = TextEditingController();
  UserTaskController taskController = Get.put(UserTaskController());
  String search = "";
  CategorySortOption selectedSortOption = CategorySortOption.name;
  int crossAxisCount = 2; // Variable for crossAxisCount

  String _getSortOptionText(CategorySortOption option) {
    switch (option) {
      case CategorySortOption.name:
        return 'Name';
      case CategorySortOption.updatedDate:
        return 'Updated Date';
      case CategorySortOption.createDate:
        return 'Created Date';
      // Add cases for more sorting options if needed
      default:
        return '';
    }
  }

  bool sortAscending = true; // Variable for sort order
  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending; // Toggle the sort order
    });
  }

  void toggleCrossAxisCount() {
    setState(() {
      crossAxisCount =
          crossAxisCount == 2 ? 1 : 2; // Toggle the crossAxisCount value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: TaskezAppHeader(
            title: "Categories",
            widget: MySearchBarWidget(
              editingController: editingController,
              onChanged: (String value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20.0, left: 20.0),
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<CategorySortOption>(
                value: selectedSortOption,
                onChanged: (CategorySortOption? newValue) {
                  setState(() {
                    selectedSortOption = newValue!;
                    // Implement the sorting logic here
                  });
                },
                items:
                    CategorySortOption.values.map((CategorySortOption option) {
                  return DropdownMenuItem<CategorySortOption>(
                    value: option,
                    child: Text(
                      _getSortOptionText(option),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),

                // Add extra styling
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                ),
                underline: const SizedBox(),
              ),
            ),
            IconButton(
              icon: Icon(
                sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
              ),
              onPressed: toggleSortOrder, // Toggle the sort order
            ),
            IconButton(
              icon: Icon(
                Icons.grid_view,
                color: Colors.white,
              ),
              onPressed:
                  toggleCrossAxisCount, // Toggle the crossAxisCount value
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder(
              stream: taskCategoryController.getUserCategoriesStream(
                userId: AuthService.instance.firebaseAuth.currentUser!.uid,
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<UserTaskCategoryModel>>
                      snapshot) {
                if (snapshot.hasData) {
                  int taskCount = snapshot.data!.docs.length;
                  List<UserTaskCategoryModel> list = [];

                  if (taskCount > 0) {
                    if (search.isNotEmpty) {
                      print(search + "helli");
                      snapshot.data!.docs.forEach((element) {
                        UserTaskCategoryModel taskModel = element.data();
                        if (taskModel.name!.toLowerCase().contains(search)) {
                          list.add(taskModel);
                        }
                      });
                    } else {
                      snapshot.data!.docs.forEach((element) {
                        UserTaskCategoryModel taskCategoryModel =
                            element.data();

                        list.add(taskCategoryModel);
                      });
                    }
                    switch (selectedSortOption) {
                      case CategorySortOption.name:
                        list.sort((a, b) => a.name!.compareTo(b.name!));
                        break;
                      case CategorySortOption.createDate:
                        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                        break;
                      case CategorySortOption.updatedDate:
                        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                      // Add cases for more sorting options if needed
                    }
                    if (!sortAscending) {
                      list = list.reversed
                          .toList(); // Reverse the list for descending order
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            crossAxisCount, // Use the variable for crossAxisCount
                        mainAxisSpacing: 10,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (_, index) {
                        return CategoryCardVertical(
                          userTaskCategoryModel: list[index],
                        );
                      },
                      itemCount: list.length,
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lightMauveBackgroundColor,
                      backgroundColor: AppColors.primaryBackgroundColor,
                    ),
                  );
                }
                return Center(
                  child: Text(
                    "No categories found",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
