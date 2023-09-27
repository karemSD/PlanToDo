// ignore_for_file: constant_identifier_names

import '../models/lang/lang.dart';

class AppConstants {
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
        imgUrl: null,
        languageName: "Arabic",
        languageCode: "ar",
        countryCode: "sy"),
    LanguageModel(
        imgUrl: null,
        languageCode: "en",
        countryCode: "US",
        languageName: "English"),
  ];

  static const String dir_key = "dir";

  static final Map<String, dynamic> dir = {
    "ar": {
      "big_picture_L": 100.0,
      "square_shape_L": 1.0,
      "medium_picture_L": 0.65,
      "small_picture_L": 80.0,
      "big_bubble_L": 295.0,
      "small_bubble_L": 180.0,
      "one_sticker_L": 0.0,
      "two_sticker_L": 0.14,
      "three_sticker_L": 0.0,
      "three_sticker_R": 0.6,
      "get_started_B": 20.0,
      "get_started_L": 30.0,
      "triangle_shape_L": -0.40,
      "triangle_shape_R": 0.83,
    },
    "en": {
      "big_picture_L": 110.0,
      "square_shape_L": 0.0,
      "medium_picture_L": 0.10,
      "small_picture_L": 220.0,
      "big_bubble_L": 50.0,
      "small_bubble_L": 130.0,
      "one_sticker_L": 0.45,
      "two_sticker_L": 0.22,
      "three_sticker_L": 0.6,
      "three_sticker_R": 0.0,
      "get_started_B": 60.0,
      "get_started_L": 40.0,
      "triangle_shape_L": 0.83,
      "triangle_shape_R": -0.40,
    }
  };

  static const String app_name_key = "app_name";
  static const String tasks_key = "tasks";
  static const String categories_key = "categories";
  static const String assign_task_key = "assign_task";
  static const String task_name_key = "task_name";
  static const String category_name_key = "category_name";
  static const String start_time_key = "start_time";
  static const String end_time_key = "end_time";
  static const String add_task_key = "add_task";
  static const String edit_task_key = "edit_task";
  static const String delete_task_key = "delete_task";
  static const String save_changes_key = "save_changes";
  static const String cancel_key = "cancel";
  static const String success_key = "success";
  static const String error_key = "error";
  static const String confirm_delete_key = "confirm_delete";
  static const String task_created_successfully_key =
      "task_created_successfully";
  static const String task_updated_successfully_key =
      "task_updated_successfully";
  static const String task_deleted_successfully_key =
      "task_deleted_successfully";
  static const String teams_key = "teams";
  static const String team_name_key = "team_name";
  static const String add_team_key = "add_team";
  static const String edit_team_key = "edit_team";
  static const String delete_team_key = "delete_team";
  static const String team_created_successfully_key =
      "team_created_successfully";
  static const String team_updated_successfully_key =
      "team_updated_successfully";
  static const String team_deleted_successfully_key =
      "team_deleted_successfully";
  static const String members_key = "members";
  static const String task_list_key = "task_list";
  static const String task_description_key = "task_description";
  static const String save_key = "save";
  static const String yes_key = "yes";
  static const String no_key = "no";
  static const String all_key = "all";
  static const String not_member_no_projects_error_ = "no";
  static const String The_provider_has_already_been_linked_to_the_user_key =
      "The_provider_has_already_been_linked_to_the_user";
  static const String The_providers_credential_is_not_valid_key =
      "The_providers_credential_is_not_valid";
  static const String
      The_account_corresponding_to_the_credential_already_exists_or_is_already_linked_to_a_Firebase_User_key =
      "The_account_corresponding_to_the_credential_already_exists_or_is_already_linked_to_a_Firebase_User";
  static const String
      Google_sign_in_was_canceled_or_no_account_was_selected_key =
      "Google_sign_in_was_canceled_or_no_account_was_selected";

  static const String
      Please_the_password_should_contain_at_least_8_characters_and_Big_letters_and_small_with_one_number_at_least_key =
      "please_the_password_should_contain_at_least_8_characters_and_big_letters_and_small_with_one_number_at_least";

  static const String there_is_no_user_logging_in_or_sign_up_key =
      "There_is_No_user_in_the_App";
  static const String there_is_no_user_in_the_app_key =
      "There_is_No_user_in_the_App";
  static const String the_email_in_its_way_to_you =
      "The_email_in_its_way_to_you";
  static const String There_is_No_User_Logging_in_Or_Sign_Up_key =
      "There_is_No_User_Logging_in_Or_Sign_Up";
  static const String
      please_the_password_should_contain_at_least_8_characters_and_big_letters_and_small_with_one_number_at_least_key =
      "Please_the_password_should_contain_at_least_8_characters_and_Big_letters_and_small_with_one_number_at_least";
  static const String please_enter_valid_email_key = "please_enter_valid_email";
  static const String confirm_delete_task_key = "confirm_delete_task";
  static const String welcome_message_key = "welcome_message";
  static const String team_list_key = "team_list";
  static const String team_description_key = "team_description";
  static const String team_members_key = "team_members";
  static const String invite_members_key = "invite_members";
  static const String project_list_key = "project_list";
  static const String project_main_tasks_key = "project_main_tasks";
  static const String project_sub_tasks_key = "project_sub_tasks";
  static const String project_members_key = "project_members";
  static const String project_manager_key = "project_manager";
  static const String project_start_time_key = "project_start_time";
  static const String updated_Date_key = "updated_date";
  static const String created_date_key = "created_date";
  static const String project_end_time_key = "project_end_time";
  static const String choose_team_first_for_project_key =
      "Choose_team_first_for_project";
  static const String team_leader_key = "team_leader";
  static const String Please_Enter_Valid_Email_key = "Please_Enter_Valid_Email";
  static const String completed_successfully_key = "completed_successfully";
  static const String project_description_key = "project_description";
  static const String project_team_key = "project_team";
  static const String please_use_another_project_name_key =
      "please_use_another_project_name";
  static const String updated_date_key = "updated_date";
  static const String no_projects_you_are_in_key = "No_Projects_you_Are_In";
  static const String by_team_key = "by_team";
  static const String status_key = "status";
  static const String projects_key = "projects";
  static const String task_assigned_successfully_key =
      "task_assigned_successfully";
  static const String due_date_validation_key = "due_date";
  static const String add_member_key = "add_member";
  static const String edit_member_key = "edit_member";
  static const String delete_member_key = "delete_member";
  static const String member_name_key = "member_name";
  static const String member_email_key = "member_email";
  static const String member_role_key = "member_role";
  static const String member_role_manager_key = "member_role_manager";
  static const String member_role_member_key = "member_role_member";
  static const String member_created_successfully_key =
      "member_created_successfully";
  static const String member_updated_successfully_key =
      "member_updated_successfully";
  static const String member_deleted_successfully_key =
      "member_deleted_successfully";
  static const String invite_user_key = "invite_user";
  static const String project_name_key = "project_name";
  static const String add_project_key = "add_project";
  static const String edit_project_key = "edit_project";
  static const String delete_project_key = "delete_project";
  static const String project_created_successfully_key =
      "project_created_successfully";
  static const String project_updated_successfully_key =
      "project_updated_successfully";
  static const String project_deleted_successfully_key =
      "project_deleted_successfully";
  static const String main_tasks_key = "main_tasks";
  static const String sub_tasks_key = "sub_tasks";
  static const String add_main_task_key = "add_main_task";
  static const String edit_main_task_key = "edit_main_task";
  static const String delete_main_task_key = "delete_main_task";
  static const String add_sub_task_key = "add_sub_task";
  static const String edit_sub_task_key = "edit_sub_task";
  static const String delete_sub_task_key = "delete_sub_task";
  static const String assign_main_task_key = "assign_main_task";
  static const String assign_sub_task_key = "assign_sub_task";
  static const String main_task_name_key = "main_task_name";
  static const String sub_task_name_key = "sub_task_name";
  static const String assignee_key = "assignee";
  static const String start_date_key = "start_date";
  static const String end_date_key = "end_date";
  static const String description_key = "description";
  static const String my_tasks_key = "my_tasks";
  static const String select_language_key = "select_language";
  static const String
      Sorry_but_there_is_Anthor_Category_with_the_same_name_key =
      "Sorry but there is Anthor Category with the same name";
  static const String Sorry_the_user_id_cannot_be_found_key =
      "Sorry the user id cannot be found";
  static const String category_already_been_added_key =
      "category_already_been_added";
  static const String task_time_error_key = "task_time_error";
  static const String there_is_key = "there_is";
  static const String task_start_prompt_key = "task_start_prompt";
  static const String sub_task_already_exist_in_main_task_key =
      "task already exist in main task";
  static const String task_key = "task";
  static const String added_successfully_key = "added successfully";
  static const String main_task_already_exist_in_project_key =
      "main_task_already_exist_in_project";
  static const String updated_successfully_key = "updated_successfully";
  static const String the_task_key = "the_task";
  static const String in_project_key = "in_project";
  static const String already_existing_project_key = "already_existing_project";
  static const String team_id_update_error_key = "team_id_update_error";
  static const String project_already_started_error_key =
      "project_already_started_error";
  static const String project_start_date_update_error_key =
      "project_start_date_update_error";
  static const String manager_not_found_error_key = "manager_not_found_error";
  static const String team_manager_error_key = "team_manager_error";
  static const String start_date_update_error_key = "start_date_update_error";
  static const String status_already_added_key = "status_already_added";
  static const String status_id_update_error_key = "status_id_update_error";
  static const String status_name_already_added_key =
      "status_name_already_added";
  static const String importance_min_value_error_key =
      "importance_min_value_error";
  static const String importance_max_value_error_key =
      "importance_max_value_error";
  static const String user_already_added_error_key = "user_already_added_error";
  static const String team_user_not_found_error_key =
      "team_user_not_found_error";
  static const String team_user_id_update_error_key =
      "team_user_id_update_error";
  static const String manager_id_update_error_key = "manager_id_update_error";
  static const String non_relational_id_update_error_key =
      "non_relational_id_update_error";
  static const String user_task_already_added_key = "user_task_already_added";
  static const String task_already_exists_category_key =
      "task_already_exists_category";
  static const String username_taken_key = "username_taken";
  static const String member_already_invited_key = "member_already_invited";
  static const String rejection_reason_key = "rejection_reason";
  static const String accepted_key = "accepted";
  static const String invite_got_key = "invite_got";
  static const String rejected_key = "rejected";
  static const String invite_to_team_key = "invite_to_team";
  static const String task_got_key = "task_got";
  static const String category_color_empty_key = "category_color_empty";
  static const String created_time_before_now_invalid_key =
      "created_time_before_now_invalid";
  static const String created_time_not_in_future_invalid_key =
      "created_time_not_in_future_invalid";
  static const String updating_time_before_creating_invalid_key =
      "updating_time_before_creating_invalid";
  static const String category_id_empty_key = "category_id_empty";
  static const String name_empty_key = "name_empty";
  static const String name_length_invalid_key = "name_length_invalid";
  static const String manager_creating_time_before_now_invalid_key =
      "manager_creating_time_before_now_invalid";
  static const String manager_creating_time_not_in_future_invalid_key =
      "manager_creating_time_not_in_future_invalid";
  static const String manager_id_empty_key = "manager_id_empty";
  static const String main_task_color_empty_key = "main_task_color_empty";
  static const String project_main_task_id_empty_key =
      "project_main_task_id_empty";
  static const String project_main_task_name_empty_key =
      "project_main_task_name_empty";
  static const String project_id_empty_key = "project_id_empty";
  static const String main_task_status_id_empty_key =
      "main_task_status_id_empty";
  static const String main_task_importance_min_invalid_key =
      "main_task_importance_min_invalid";
  static const String main_task_importance_max_invalid_key =
      "main_task_importance_max_invalid";
  static const String main_task_create_time_not_in_future_invalid_key =
      "main_task_create_time_not_in_future_invalid";
  static const String main_task_create_time_in_past_error_key =
      "main_task_create_time_in_past_error";
  static const String main_task_updating_time_not_in_future_invalid_key =
      "main_task_updating_time_not_in_future_invalid";
  static const String main_task_start_date_null_key =
      "main_task_start_date_null";
  static const String main_task_start_date_past_error_key =
      "main_task_start_date_past_error";
  static const String main_task_end_date_null_key = "main_task_end_date_null";
  static const String main_task_start_after_end_error_key =
      "main_task_start_after_end_error";
  static const String main_task_date_difference_error_key =
      "main_task_date_difference_error";
  static const String main_task_start_same_as_end_error_key =
      "main_task_start_same_as_end_error";
  static const String project_imageUrl_empty_error_key =
      "project_imageUrl_empty_error";
  static const String project_creating_time_future_error_key =
      "project_creating_time_future_error";
  static const String project_creating_time_past_error_key =
      "project_creating_time_past_error";
  static const String project_updating_before_creating_error_key =
      "project_updating_before_creating_error";
  static const String project_id_empty_error_key = "project_id_empty_error";
  static const String project_name_empty_error_key = "project_name_empty_error";
  static const String project_name_length_error_key =
      "project_name_length_error";
  static const String project_name_format_error_key =
      "project_name_format_error";
  static const String project_start_date_null_error_key =
      "project_start_date_null_error";
  static const String project_start_date_past_error_key =
      "project_start_date_past_error";
  static const String project_end_date_null_error_key =
      "project_end_date_null_error";
  static const String project_end_time_error_key = "project_end_time_error";
  static const String project_end_time_same_error_key =
      "project_end_time_same_error";
  static const String project_time_difference_error_key =
      "project_time_difference_error";
  static const String project_sub_task_color_empty_error_key =
      "project_sub_task_color_empty_error";
  static const String team_member_assigned_id_empty_error_key =
      "team_member_assigned_id_empty_error";
  static const String project_sub_task_id_empty_error_key =
      "project_sub_task_id_empty_error";
  static const String sub_task_project_id_empty_error_key =
      "sub_task_project_id_empty_error";
  static const String sub_task_main_task_id_empty_error_key =
      "sub_task_main_task_id_empty_error";
  static const String project_sub_task_name_null_error_key =
      "project_sub_task_name_null_error";
  static const String project_sub_task_name_empty_error_key =
      "project_sub_task_name_empty_error";
  static const String project_sub_task_status_id_empty_error_key =
      "project_sub_task_status_id_empty_error";
  static const String project_sub_task_importance_min_error_key =
      "project_sub_task_importance_min_error";
  static const String project_sub_task_importance_max_error_key =
      "project_sub_task_importance_max_error";
  static const String project_sub_task_create_time_future_error_key =
      "project_sub_task_create_time_future_error";
  static const String project_sub_task_create_time_past_error_key =
      "project_sub_task_create_time_past_error";
  static const String project_sub_task_update_time_before_creating_error_key =
      "project_sub_task_update_time_before_creating_error";
  static const String project_sub_task_start_date_null_error_key =
      "project_sub_task_start_date_null_error";
  static const String project_sub_task_start_date_past_error_key =
      "project_sub_task_start_date_past_error";
  static const String project_sub_task_end_date_null_error_key =
      "project_sub_task_end_date_null_error";
  static const String project_sub_task_start_after_end_error_key =
      "project_sub_task_start_after_end_error";
  static const String project_sub_task_start_same_as_end_error_key =
      "project_sub_task_start_same_as_end_error";
  static const String project_sub_task_time_difference_error_key =
      "project_sub_task_time_difference_error";
  static const String team_image_empty_error_key = "team_image_empty_error";
  static const String team_id_empty_error_key = "team_id_empty_error";
  static const String team_name_empty_error_key = "team_name_empty_error";
  static const String team_name_min_length_error_key =
      "team_name_min_length_error";
  static const String team_creating_time_future_error_key =
      "team_creating_time_future_error";
  static const String team_creating_time_past_error_key =
      "team_creating_time_past_error";
  static const String team_updating_time_before_creation_error_key =
      "team_updating_time_before_creation_error";
  static const String team_member_id_empty_error_key =
      "team_member_id_empty_error";
  static const String team_member_creating_time_future_error_key =
      "team_member_creating_time_future_error";
  static const String team_member_creating_time_past_error_key =
      "team_member_creating_time_past_error";
  static const String team_member_updating_time_before_create_error_key =
      "team_member_updating_time_before_create_error";
  static const String
      waiting_team_member_updating_time_before_create_error_key =
      "waiting_team_member_updating_time_before_create_error";
  static const String name_not_empty_key = "name_not_empty";
  static const String name_min_length_key = "name_min_length";
  static const String name_letters_only_key = "name_letters_only";
  static const String username_not_empty_key = "username_not_empty";
  static const String username_min_length_key = "username_min_length";
  static const String username_max_length_key = "username_max_length";
  static const String user_imageUrl_empty_key = "user_imageUrl_empty";
  static const String valid_email_error_key = "valid_email_error";
  static const String user_id_empty_error_key = "user_id_empty_error";
  static const String user_creating_time_future_error_key =
      "user_creating_time_future_error";
  static const String user_creating_time_past_error_key =
      "user_creating_time_past_error";
  static const String user_account_updating_time_before_creating_error_key =
      "user_account_updating_time_before_creating_error";
  static const String task_user_id_empty_error_key = "task_user_id_empty_error";
  static const String user_task_category_id_empty_error_key =
      "user_task_category_id_empty_error";
  static const String user_task_name_null_error_key =
      "user_task_name_null_error";
  static const String userId_update_error_key = "userId_update_error";
  static const String team_project_overlap_error_key =
      "team_project_overlap_error";
  static const String make_project_first_error_key = "make_project_first_error";
  static const String not_member_no_projects_error_key =
      "not_member_no_projects_error";
  static const String user_task_name_empty_error_key =
      "user_task_name_empty_error";
  static const String user_task_id_empty_error_key = "user_task_id_empty_error";
  static const String task_status_id_empty_error_key =
      "task_status_id_empty_error";
  static const String importance_less_than_zero_error_key =
      "importance_less_than_zero_error";
  static const String importance_greater_than_five_error_key =
      "importance_greater_than_five_error";
  static const String task_color_empty_error_key = "task_color_empty_error";
  static const String user_task_create_future_error_key =
      "user_task_create_future_error";
  static const String user_task_create_past_error_key =
      "user_task_create_past_error";
  static const String task_update_before_create_error_key =
      "task_update_before_create_error";
  static const String user_task_start_date_null_error_key =
      "user_task_start_date_null_error";
  static const String user_task_start_date_past_error_key =
      "user_task_start_date_past_error";
  static const String user_task_end_date_null_error_key =
      "user_task_end_date_null_error";
  static const String user_task_start_end_date_same_time_error_key =
      "user_task_start_end_date_same_time_error";
  static const String task_time_difference_error_key =
      "task_time_difference_error";
  static const String user_task_end_date_error_key = "user_task_end_date_error";
  static const String not_member_in_any_team_error_key =
      "not_member_in_any_team_error";
  static const String make_team_first_error_key = "make_team_first_error";
  static const String manager_cannot_be_member_error_key =
      "manager_cannot_be_member_error";
  static const String members_already_invited_error_key =
      "members_already_invited_error";
  static const String get_started_key = "get_started";
  static const String lets_create_a_space_for_your_workflows_key =
      "lets_create_a_space_for_your_workflows";
  static const String task_management_key = "task_management";

  static const String warning_key = "warning";
  static const String info_key = "info";
  static const String select_all_key = "select_all";
  static const String clear_all_key = "clear_all";
  static const String task_to_do_today_key = "task_to_do_today";
  static const String task_end_date_error_key = "task_end_date_error";
  static const String task_time_duration_error_key = "task_time_duration_error";
  static const String user_task_start_end_same_time_error_key =
      "user_task_start_end_same_time_error";
  static const String user_task_create_time_past_error_key =
      "user_task_create_time_past_error";
  static const String user_task_create_time_future_error_key =
      "user_task_create_time_future_error";
  static const String task_name_empty_error_key = "task_name_empty_error";
  static const String task_name_null_error_key = "task_name_null_error";
  static const String folder_id_empty_error_key = "folder_id_empty_error";
  static const String password_validation_error_key =
      "password_validation_error";
  static const String has_begun_deadline_key = "has_begun_deadline";
  static const String rocket_project_key = "project";
  static const String not_done_key = "not_done";
  static const String done_key = "done";
  static const String decline_key = "decline";
  static const String decline_invite_key = "decline_invite";
  static const String accept_key = "accept";
  static const String allow_key = "allow";
  static const String
      never_miss_an_important_task_or_deadline_again_enable_notifications_to_receive_timely_reminders_about_your_upcoming_tasks_projects_and_more_key =
      "never_miss_an_important_task_or_deadline_again_enable_notifications_to_receive_timely_reminders_about_your_upcoming_tasks_projects_and_more";
  static const String the_Manager_Of_Team_can_not_be_a_member_in_the_Team_key =
      "the_Manager_Of_Team_can_not_be_a_member_in_the_Team";
  static const String sorry_but_Team_Or_user_of_this_member_not_found_key =
      "sorry_but_Team_Or_user_of_this_member_not_found";
  static const String please_Try_Again_key = "please_Try_Again";
  static const String something_wrong_happen_key = "SomeThing_Wrong_happen";
  static const String start_conversation_key = "start_conversation";
  static const String no_conversations_found_key = "no_conversations_found";
  static const String there_is_no_conversation_to_read_yet_key =
      "there_is_no_conversation_to_read_yet";
  static const String
      sorry_but_make_a_team_then_get_startedsorry_but_make_a_team_then_get_startedsorry_but_make_a_team_then_get_started_key =
      "sorry_but_make_a_team_then_get_startedsorry_but_make_a_team_then_get_startedsorry_but_make_a_team_then_get_started";
  static const String sorry_you_are_not_a_member_in_any_team_key =
      "sorry_you_are_not_a_member_in_any_team";
  static const String
      sorry_you_are_not_a_member_in_any_team_click_here_to_join_or_create_team_key =
      "sorry_you_are_not_a_member_in_any_team_click_here_to_join_or_create_team";

  static const String go_to_project_key = "go_to_project";
  static const String sorry_you_do_not_have_any_notification_key =
      "sorry_you_do_not_have_any_notification";
  static const String mark_as_read_key = "mark_as_read";

  static const String no_member_found_key = "no_member_found";
  static const String search_members_key = "search_members";
  static const String no_search_found_key = "no_search_found";
  static const String to_be_a_member_in_team_key = "to_be_a_member_in_team";
  static const String do_something_when_your_item_deleted_key =
      "do_something_when_your_item_deleted";
  static const String you_are_not_member_of_any_team_yet_key =
      "you_are_not_member_of_any_team_yet";
  static const String created_by_key = "created_by";
  static const String member_since_key = "member_since";
  static const String invite_member_key = "invite_member";

  static const String add_category_key = "add_category";
  static const String you_have_to_member_in_team_to_have_tasks_key =
      "you_have_to_member_in_team_to_have_tasks";
  static const String there_is_no_task_yet_key = "there_is_no_task_yet";
  static const String no_tasks_found_key = "no_tasks_found";
  static const String create_new_task_key = "create_new_task";

  static const String update_task_key = "update_task";
  static const String delete_key = "delete";

  static const String update_project_key = "update_project";

  static const String edit_category_key = "edit_category";
  static const String delete_category_key = "delete_category";

  static const String category_color_key = "category_color";
  static const String category_icon_key = "category_icon";
  static const String update_category_key = "update_category";

  static const String project_key = "project";

  static const String team_key = "team";

  static const String invitation_key = "invitation";

  static const String file_key = "file";

  static const String conversation_key = "conversation";

  static const String notification_key = "notification";
  static const String notifications_key = "notifications";
  static const String settings_key = "settings";

  static const String language_key = "language";
  static const String theme_key = "theme";
  static const String dark_mode_key = "dark_mode";
  static const String light_mode_key = "light_mode";
  static const String system_default_key = "system_default";
  static const String sign_out_key = "sign_out";
  static const String tap_the_logo_to_upload_new_file_key =
      "tap_the_logo_to_upload_new_file";
  static const String enter_the_name_of_team_key = "enter_the_name_of_team";
  static const String select_members_key = "select_members";
  static const String create_new_team_key = "create_new_team";
  static const String upload_complete_key = "upload_complete";
  static const String image_upload_failed_key = "image_upload_failed";
  static const String please_use_another_categoryName_key =
      "please_use_another_categoryName";
  static const String category_key = "category";
  static const String choose_color_key = "choose_color";
  static const String close_key = "close";
  static const String oK_key = "oK";
  static const String choose_icon_key = "choose_icon";
  static const String total_task_key = "total_task";
  static const String to_do_today_key = "to_do_today";
  static const String working_on_key = "working_on";
  static const String completed_task_key = "completed_task";
  static const String total_categories_key = "total_categories";
  static const String total_projects_key = "total_projects";
  static const String total_teams_key = "total_teams";
  static const String is_completed_key = "is_completed";
  static const String daily_goal_key = "daily_goal";
  static const String you_marked_key = "you_marked";
  static const String are_done_key = "are_done 🎉";
  static const String all_task_key = "all_task";
  static const String completed_key = "completed";
  static const String in_the_last_7_days_key = "in_the_last_7_days";
  static const String dashboard_key = "dashboard";
  static const String hello_n_key = "hello_n";
  static const String overview_key = "overview";
  static const String productivity_key = "productivity";
  static const String sign_in_anonmouslly_key = "sign_in_anonmouslly";

  static const String view_profile_key = "view_profile";

  static const String make_an_account_by_key = "make_an_account_by";
  static const String make_an_account_by_signing_in =
      "make_an_account_by_signing_in";
  static const String google_key = "google";
  static const String email_key = "email";
  static const String profile_key = "profile";
  static const String sign_in_anonymously_key = "sign_in_anonymously";

  static const String please_enter_at_least_one_number_key =
      "please_enter_at_least_one_number";
  static const String please_enter_at_least_one_big_character_key =
      "please_enter_at_least_one_big_character";
  static const String confirm_assword_key = "confirm_assword";
  static const String please_use_another_userName_key =
      "please_use_another_userName";
  static const String the_name_can_not_contain_numbers_or_symbols_key =
      "the_name_can_not_contain_numbers_or_symbols";
  static const String the_name_can_not_be_empty_key =
      "the_name_can_not_be_empty";
  static const String
      check_your_an_email_messages_we_have_send_the_link_to_email_to_verify_key =
      "check_your_an_email_messages_we_have_send_the_link_to_email_to_verify";
  static const String the_mail_is_verifed_key = "the_mail_is_verifed";
  static const String send_verify_link_key = "send_verify_link";
  static const String verifed_key = "verifed";
  static const String sucess_baby_key = "sucess_baby";
  static const String plese_verify_your_email_before_continue_key =
      "plese_verify_your_email_before_continue";
  static const String continue_key = "continue";
  static const String create_task_key = "create_task";
  static const String create_project_key = "create_project";
  static const String create_team_key = "create_team";
  static const String create_category_key = "create_category";
  static const String object_key = "object";
  static const String importance_key = "importance";
  static const String please_use_another_taskName_key =
      "please_use_another_taskName";
  static const String description_cannot_be_empy_spaces_key =
      "description_cannot_be_empy_spaces";
  static const String choose_team_key = "choose_team";
  static const String name_can_not_be_empty_key = "name_can_not_be_empty";

  static const String description_cannot_be_empty_spaces_key =
      "description_cannot_be_empty_spaces";
  static const String today_key = "today";
  static const String start_date_cannot_be_after_end_date_key =
      "start date cannot be after end date";
  static const String edit_key = "edit";
  static const String log_out_key = "log_out";
  static const String arabic_key = "arabic";
  static const String english_key = "english";
  static const String receive_notification_key = "receive_notification";

  static const String task_calendar_chat_key = "task_calendar_chat";
  static const String work_anywhere_easily_key = "work_anywhere_easily";
  static const String manage_everything_on_Phone_key =
      "manage_everything_on_Phone";
  static const String continue_with_email_key = "continue_with_email";
  static const String
      by_continuing_you_agree_plans_to_dos_terms_of_services_privacy_policy_key =
      "by_continuing_you_agree_plans_to_do's_terms_of_services_&_privacy_policy";
  static const String login_key = "login";
  static const String nice_to_see_you_key = "nice_to_see_you!";
  static const String enter_alid_email_key = "enter_alid_email";
  static const String password_can_not_be_empty_key =
      "password_can_not_be_empty";
  static const String sign_in_successfully_key = "sign_in_uccessfully";
  static const String no_user_found_for_that_email_key =
      "no_user_found_for_that_email";
  static const String wrong_password_provided_for_that_user_key =
      "wrong_password_provided_for_that_user";
  static const String dont_have_an_account_key = "don't_have_an_account?";
  static const String make_one_key = "make_one!";
  static const String your_email_key = "your_email";
  static const String your_password_key = "your_password";
  static const String sign_in_key = "sign_in";
  static const String whats_your_email_address_key = "whats_your_email_address";

  static const String enter_valid_email_key = "enter_valid_email";
  static const String sign_up_key = "sign_up";

  static const String using_key = "using";
  static const String to_login_key = "to_login.";
  static const String name_key = "name";
  static const String user_name_key = "user_name";
  static const String password_key = "password";
  static const String confirm_key = "confirm";

  static const String welcome_in_our_team_Plans_to_do_team_happy_in_you_key =
      "welcome_in_our_team_Plans_to_do_team_happy_in_you";
  static const String choose_an_image_key = "choose_an_image";
  static const String camera_key = "camera";
  static const String gallery_key = "gallery";
  static const String your_name_key = "your_name";
  static const String your_username_key = "your_username";
  static const String confirm_password_key = "confirm_password";
  static const String the_password_did_not_match_key =
      "the_password_did_not_match";
  static const String the_password_should_be_more_then_7_character_key =
      "the_password_should_be_more_then_7_character";
  static const String please_enter_at_least_one_small_character_key =
      "please_enter_at_least_one_small_character";
// ignore_for_file: constant_identifier_names
}
