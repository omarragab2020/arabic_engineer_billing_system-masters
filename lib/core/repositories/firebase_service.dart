import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/my_extensions.dart';

import '../../app/controllers/app_controller.dart';

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();
  static AppController appController = AppController.to;

  ///************************************************************************************************
  static const String refCallsDoc = 'Calls';

  ///************************************************************************************************
  static FirebaseFirestore storeInstance = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> callsCollection = storeInstance.collection(refCallsDoc);

  ///region Calls
  ///************************************************************************************************


  ///endregion Calls
}
