//الصف توب موديل تم إنشاؤه للتغلب على مشكلة تكرار البيانات في الصفوف الموجودة في الداتا بيس
//بحيث توجد الكثير من الصفوف التي تحتوي على بيانات مشتركة
//فارتأينا أن يكون هناك واجهة تحتوي على العناصر المشتركة بين هذه الصفوف
//بما أن هذه الصفوف لا تشترك بالصفة الأساسية لذا تم وضع الصف ك ميكسين
mixin TopModel {
  late String id;
  set setId(String id);
  /*ملاحظة هامة الميكسين مابتساويلك get افتراضية من عندها لهيك منعمل وحدة نحنا
  بينما الكلاس ابستركت هو بيساويها افتراضية بولادو وبيطلع الحقلل تلقائي عند الولاد
  */
  //get getId => id;
  late DateTime createdAt;
  set setCreatedAt(DateTime createdAt);
  //DateTime get getCreatedAt => createdAt;
  late DateTime updatedAt;
  set setUpdatedAt(DateTime updatedAt);
  // DateTime get getUpdatedAt => updatedAt;
  Map<String, dynamic> toFirestore();
}
