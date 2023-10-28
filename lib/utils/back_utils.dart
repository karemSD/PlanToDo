import 'package:firebase_storage/firebase_storage.dart';

DateTime firebaseTime(DateTime dateTime) {
  //هنا حيث نستقبل الوقت الممدخل ونتأكد من سلامة البيانات وانها تتدخل بشكل صحيح ومن ثم نرجع تلك القيمة للكائن
  DateTime newDate = DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    0,
  );
  return newDate;
}

final firebaseStorage = FirebaseStorage.instance;
const String defaultGroupPathInStorage =
    "https://firebasestorage.googleapis.com/v0/b/email-password-64698.appspot.com/o/images%2FdefaultGroup.png?alt=media&token=3046451d-9834-4504-8e40-821effe7dfbf";
const String defaultUserImageProfile =
    "https://firebasestorage.googleapis.com/v0/b/email-password-64698.appspot.com/o/images%2Fdummy-profile.png?alt=media&token=c427fea0-7448-42db-ac00-ba93faa2ed3b";

const String defaultProjectImage =
    "https://firebasestorage.googleapis.com/v0/b/graduation-plans-to-do.appspot.com/o/projectImage.jpg?alt=media&token=f474772f-5100-4467-9e18-3fa756566099";

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
