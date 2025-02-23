import 'package:almuandes_billing_system/app/views/modules/home/screens/base_main_screen.dart';
import 'package:almuandes_billing_system/app/views/modules/others/no_data_view.dart';
import 'package:flutter/material.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseMainScreen(
      title: 'My vehicles',
      child: Column(
        children: <Widget>[Center(child: NoDataView())],
      ),
    );
  }
}
