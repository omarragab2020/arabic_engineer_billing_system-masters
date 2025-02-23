import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../../core/utils/app_constants.dart';
import '../../../../controllers/app_controller.dart';

class BaseMainScreen extends GetView<AppController> {
  const BaseMainScreen({required this.title, this.padding = 16, this.appBar, required this.child, super.key});

  final String title;
  final Widget child;
  final double padding;
  final PreferredSizeWidget? appBar;

  static String newStatus = AppConstants.statusUnAvailable;

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      onWillPop: controller.onWillPop,
      appBar: appBar ?? AppBar(title: Txt(title, fontSize: 24, fontWeight: FontWeight.bold)),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
