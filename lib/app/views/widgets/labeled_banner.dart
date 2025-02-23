import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neuss_utils/image_utils/img_utils.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../core/utils/app_colors.dart';

class LabeledBanner extends StatelessWidget {
  const LabeledBanner(
      {super.key,
      this.label,
      this.txtColor,
      this.padding = 0,
      this.isBold = true,
      this.weight,
      this.bgColor,
      this.imgUrl,
      this.imgAssetPath,
      this.icon});
  final String? label;
  final String? imgUrl;
  final String? imgAssetPath;
  final Widget? icon;
  final FontWeight? weight;
  final Color? txtColor;
  final bool isBold;
  final Color? bgColor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SuperDecoratedContainer(
      // elevation: 4,
      borderRadius: 12,
      color: bgColor ?? const Color(0xFFF5F5F5),
      boxShadow: [
        BoxShadow(color: AppColors.appMainColor, blurRadius: 1, offset: Offset(.8, 0)),
        BoxShadow(color: AppColors.appMainColor, blurRadius: 2, offset: Offset(0, 2)),
      ],
      // color: Color(0xFF000000 | Random().nextInt(0xFFFFFF)),
      // color: Get.theme.colorScheme.background,
      padding: padding.allPadding,
      child: Stack(
        children: [
          Positioned.fill(
            child: SuperImageView(
              imgUrl: imgUrl,
              imgAssetPath: imgAssetPath,
              icon: icon,
              fit: BoxFit.fill,
              // width: 0.25.w,
              // height: 0.25.w,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SuperDecoratedContainer(
              width: 1.w,
              color: AppColors.selectedColor,
              padding: const EdgeInsets.all(8),
              child: Txt(
                label,
                color: txtColor,
                textAlign: TextAlign.center,
                fontWeight: weight ?? (isBold ? FontWeight.bold : FontWeight.normal),
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
