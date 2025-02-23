import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/app_controller.dart';
import '../../../../models/user_model.dart';

class TeacherBanner extends GetView<AppController> {
  const TeacherBanner({required this.teacherModel, super.key});

  final UserModel teacherModel;

  @override
  Widget build(BuildContext context) {
    // mPrint('userModel (${userModel.first_name} - ${userModel.userInfo?.id} - ${userModel.userInfo?.status})');
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      surfaceTintColor: (controller.mUser!.id == teacherModel.id) ? Colors.blue : null,
      child: const Column(
        children: [
          ///TODO: User Banner
        ],
      ),
    );
  }
}
