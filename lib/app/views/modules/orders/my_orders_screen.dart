import 'package:almuandes_billing_system/app/views/modules/home/screens/base_main_screen.dart';
import 'package:flutter/material.dart';

import '../others/no_data_view.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseMainScreen(
      title: 'My orders',
      child: Column(
        children: <Widget>[Center(child: NoDataView())],
      ),
    );
  }
}
