import 'package:kds/styles/text_style.dart';

import '../../../styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressIndicatorDialog extends StatelessWidget {
  final String dialogText;
  final VoidCallback onCancel; // Callback for cancel action

  const ProgressIndicatorDialog({
    super.key,
    required this.dialogText,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${double.parse(dialogText).toStringAsFixed(0)} %',
              textAlign: TextAlign.center,
              style: mediumText.copyWith(color: goSmartBlue),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: onCancel, // Trigger the cancel callback
            ),
          ],
        ),
        content: Container(
          height: 40,
          width: MediaQuery.sizeOf(context).width * 0.6,
          padding: const EdgeInsets.all(15.0),
          child: LinearPercentIndicator(
            animateFromLastPercent: true,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 1500,
            percent: double.parse(dialogText) / 100,
            barRadius: Radius.circular(10.r),
            progressColor: goSmartBlue,
          ),
        ),
      ),
    );
  }
}
