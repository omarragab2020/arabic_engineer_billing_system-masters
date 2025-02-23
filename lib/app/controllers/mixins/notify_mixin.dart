import 'package:dart_extensions/dart_extensions.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:ready_extensions/ready_extensions.dart';
import '../../../core/services/super_notification_service.dart';
import '../../../core/utils/app_enums.dart';
import '../../../core/utils/app_helpers.dart';
import '../../models/user_model.dart';
import '../app_controller.dart';
import 'vars_mixin.dart';

mixin NotifyMixin on VarsMixin {
  Future<(bool, String)> sendSessionRemainderNotify(UserModel user) async {
    if (user.fcm_token.isNullOrEmptyOrWhiteSpace) return (false, 'Fcm isEmpty');
    return await SuperNotificationService.sendFCMNotification(
      to: [user.fcm_token!],
      title: "${AppHelpers.translate('You have a session with', true)} (${mUser!.first_name})",
      body: AppHelpers.translate('Check it now...', true),
      dismissLabel: AppHelpers.translate('Ok', true),
      addDismiss: false,
      payload: {
        'type': 'SessionRemainder',
      },
    );
  }
}
