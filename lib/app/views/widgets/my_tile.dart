import 'package:flutter/material.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/utils.dart';

class MyTile extends StatelessWidget {
  const MyTile(
      {super.key,
      this.leading,
      this.trailing,
      this.title,
      this.onTap,
      this.subTitle,
      this.contentPadding =
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4)});

  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subTitle;
  final EdgeInsets contentPadding;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: onTap != null,
      parentBuilder: (child) => InkWell(onTap: onTap, child: child),
      child: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (leading != null) leading!,
            hSpace16,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) title!,
                  if (subTitle != null) subTitle!,
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
