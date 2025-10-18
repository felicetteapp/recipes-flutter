import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  final _db = FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;
}
