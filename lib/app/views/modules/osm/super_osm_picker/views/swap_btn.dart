import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../models/location_model.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({super.key, this.location1, this.location2, required this.onSwap});
  final LocationModel? location1, location2;
  final void Function() onSwap;

  @override
  Widget build(BuildContext context) {
    return location1 == null && location2 == null
        ? const SizedBox(width: 16)
        : InkWell(
            onTap: onSwap,
            child: Transform.rotate(
              angle: pi,
              child: FaIcon(FontAwesomeIcons.retweet, color: Get.theme.primaryColor),
            ));
  }
}
