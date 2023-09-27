import 'TopModel_model.dart';

//بعد ما تم إنشاء الواجهة توب موديل
//وجدنا أن هناك عدد لا بأس به من الصفوف لديهاعناصر مشتركة أخرى غير موجودة في بقية الصفوف
//لذا بما أنه لا يمكننا عمل وراثة من واجهة إلى واجهة أخرى كما في لغات البرمجة الأخرى
//تم عمل صف يقوم بتوريث هذه الصفات المشتركة إلى الكلاسات التي تحتاجها
//the classes that inherit from this class directly
//User class/task category class/teams class/status class
//الحقول هي الاسم ووقت الإنشاء ووقت التعديل
//name,created at,updated at
abstract class VarTopModel with TopModel {
  String? name;
  set setName(String name);
  @override
  set setCreatedAt(DateTime createdAt);
  @override
  set setUpdatedAt(DateTime updatedAt);
  @override
  set setId(String id);
}
