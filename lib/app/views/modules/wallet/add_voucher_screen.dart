import '../home/screens/base_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_edit_text.dart';
import 'package:neuss_utils/widgets/src/txt.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddVoucherScreen extends StatelessWidget {
  AddVoucherScreen({super.key});

  final TextEditingController codeTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseMainScreen(
      title: 'Add Voucher',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SuperEditText(
            codeTxtController,
            hint: 'Add Voucher Code',
            txtSize: 16,
            letterSpacing: 2,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.equalLength(16),
            ],
          ),
          vSpace64,
          FilledButton(
              style: FilledButton.styleFrom(fixedSize: Size(0.9.w, 50)),
              onPressed: () {
                mShowToast('Coming soon');
              },
              child: const Txt("Apply", fontSize: 16)),
          vSpace96,
        ],
      ),
    );
  }
}
