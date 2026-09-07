import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kds/styles/colors.dart';
import 'package:kds/styles/text_style.dart';

class YesNoDialog extends StatelessWidget {
  final String dialogText;
  final void Function() onYesPressed;
  final void Function() onNoPressed;

  const YesNoDialog({
    super.key,
    required this.dialogText,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      title: Text(
        dialogText,
        textAlign: TextAlign.center,
        style: mediumText.copyWith(fontSize: 25.sp),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),

          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(goSmartBlue),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            onPressed: onYesPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                'yes'.tr(),
                textAlign: TextAlign.center,
                style: boldText.copyWith(color: white),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color.fromRGBO(230, 230, 244, 1),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            onPressed: onNoPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                'no'.tr(),
                textAlign: TextAlign.center,
                style: boldText.copyWith(
                  color: const Color.fromRGBO(161, 166, 193, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
