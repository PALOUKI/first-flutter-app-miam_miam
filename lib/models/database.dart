
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  //CREATE
  Future addFoodDetails(
      Map<String, dynamic> foodInfoMap, String id) async {

    return await FirebaseFirestore.instance
        .collection("Foods")
        .doc(id)
        .set(foodInfoMap);
}
  //READ
  Future<Stream<QuerySnapshot>> getFoodDetails() async {
    return await FirebaseFirestore.instance.collection("Foods").snapshots();
  }

  //UPDATE

  Future updateFoodDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Foods")
        .doc(id)
        .update(updateInfo);
  }

  //DELETE

  Future deleteFoodDetail(String id)async{
    return await FirebaseFirestore.instance.collection("Foods")
        .doc(id)
        .delete();
  }

}