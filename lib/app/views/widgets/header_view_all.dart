import 'package:flutter/material.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../core/utils/app_colors.dart';

class HeaderViewAll extends StatelessWidget {
  const HeaderViewAll({super.key, required this.title, this.onPressed, this.showAll = true, this.leadingWidget, this.trailingWidget});
  final String title;
  final bool showAll;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leadingWidget != null) ...[leadingWidget!, hSpace4],
        Txt(title, fontWeight: FontWeight.bold, fontSize: 18),
        if (trailingWidget != null) ...[hSpace4, trailingWidget!],
        const Spacer(),
        if (showAll)
          TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: onPressed,
              child:  Txt('View All', fontWeight: FontWeight.bold, underlined: true, fontSize: 14, color: AppColors.appMainColor)),
      ],
    );
  }
}
