import 'package:flutter/material.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../core/utils/app_colors.dart';

class LabeledIconCard extends StatelessWidget {
  const LabeledIconCard(
      {super.key,
      this.label,
      this.txtColor,
      this.isBold = true,
      this.weight,
      this.width,
      this.bgColor,
      this.imgUrl,
      this.fontSize = 12,
      this.imgAssetPath,
      this.svgAssetPath,
      this.icon});
  final String? label;
  final String? imgUrl;
  final String? imgAssetPath;
  final String? svgAssetPath;
  final Widget? icon;
  final FontWeight? weight;
  final Color? txtColor;
  final bool isBold;
  final Color? bgColor;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SuperDecoratedContainer(
      width: width,
      // elevation: 4,
      borderRadius: 12,
      color: bgColor ?? const Color(0xFFF5F5F5),
      boxShadow: [
        BoxShadow(color: AppColors.appMainColor, blurRadius: 1, offset: Offset(.8, 0)),
        BoxShadow(color: AppColors.appMainColor, blurRadius: 2, offset: Offset(0, 2)),
      ],
      // color: Color(0xFF000000 | Random().nextInt(0xFFFFFF)),
      // color: Get.theme.colorScheme.background,
      padding: 8.allPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SuperImageView(
              imgUrl: imgUrl,
              imgAssetPath: imgAssetPath,
              svgAssetPath: svgAssetPath,
              icon: icon,
              fit: BoxFit.fill,
              // width: 0.25.w,
              // height: 0.25.w,
            ),
          ),
          Txt(
            label,
            color: txtColor,
            textAlign: TextAlign.center,
            fontWeight: weight ?? (isBold ? FontWeight.bold : FontWeight.normal),
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
