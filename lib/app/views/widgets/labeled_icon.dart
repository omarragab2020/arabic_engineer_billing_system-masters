import 'package:flutter/material.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

class LabeledIcon extends StatelessWidget {
  const LabeledIcon(
      {super.key,
      this.label,
      this.txtColor,
      this.txtSize = 14,
      this.space = 4,
      this.isBold = true,
      this.reversed = false,
      this.weight,
      this.imgUrl,
      this.imgAssetPath,
      this.icon});
  final String? label;
  final String? imgUrl;
  final String? imgAssetPath;
  final Widget? icon;
  final FontWeight? weight;
  final Color? txtColor;
  final double? txtSize, space;
  final bool isBold, reversed;

  List<Widget> get children => [
        SuperImageView(
          imgUrl: imgUrl,
          imgAssetPath: imgAssetPath,
          icon: icon,
          fit: BoxFit.fill,
          // width: 0.25.w,
          // height: 0.25.w,
        ),
        hSpace(space),
        Flexible(
          child: Txt(
            label,
            color: txtColor,
            textAlign: TextAlign.center,
            fontWeight: weight ?? (isBold ? FontWeight.bold : FontWeight.normal),
            overflow: TextOverflow.ellipsis,
            fontSize: txtSize,
            maxLines: 1,
          ),
        ),
      ];
  List<Widget> get getChildren => reversed ? children.reversed.toList() : children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      // textBaseline: TextBaseline.alphabetic,
      children: getChildren,
    );
  }
}
