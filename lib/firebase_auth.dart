import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user_dm.dart';

CollectionReference<UserDm> getUsersCollection (){
  return FirebaseFirestore.instance.collection('users')
      .withConverter<UserDm>(
      fromFirestore: (snapshot,_){
        Map json = snapshot.data() as Map;
        return UserDm(id: json['id'], userName: json['userName'], email: json['email']);
      },
      toFirestore: (users ,_){
        return {
          'id' : users.id,
          'userName' : users.userName,
          'email' : users.email
        };
      });
}

Future<void> registerUserInFirestore(UserDm userDm) {
  CollectionReference<UserDm> userCollection = getUsersCollection();
  return userCollection.doc(userDm.id).set(userDm);
}

Future<void> getUserFromFirestore(String id) async {
  UserDm userDm= (await getUsersCollection().doc(id).get()).data()!;
  UserDm.currentUser= userDm;
}