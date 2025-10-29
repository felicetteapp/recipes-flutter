import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felicette_recipes/app/data/models/auth_models.dart';
import 'package:felicette_recipes/app/services/api/api_service.dart';

class AuthApiService extends ApiService {
  CollectionReference<FRUser> collection() {
    return db
        .collection('users')
        .withConverter<FRUser>(
          fromFirestore: FRUser.fromFirestore,
          toFirestore: FRUser.toFirestore,
        );
  }

  DocumentReference<FRUser> doc({required String userId}) {
    return collection().doc(userId);
  }

  Stream<DocumentSnapshot<FRUser>> listenUser({required String userId}) {
    return doc(userId: userId).snapshots();
  }
}
