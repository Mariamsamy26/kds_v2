import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/colors.dart';

class SuccessWidget extends StatelessWidget {
  final void Function() onPressed;
  final String dialogText;

  const SuccessWidget({super.key, required this.onPressed, required this.dialogText});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Image.asset('assets/images/success.png', width: 60, height: 60),
            SizedBox(height: 10.h),
            Center(child: Text(dialogText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),

            SizedBox(height: 5.h),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(goSmartBlue),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
              ),
              onPressed: onPressed,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text('Continue', textAlign: TextAlign.center, style: TextStyle(color: white)),
              ),
            ),

            // TextButton(
            //   style: ButtonStyle(
            //     overlayColor: MaterialStateProperty.all(mainBlue.withOpacity(0.1)),
            //     shape: MaterialStateProperty.all(
            //       RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(3.r),
            //       ),
            //     ),
            //   ),
            //   onPressed: onPressed,
            //   child: Ink(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [mainBlue.withOpacity(0.9), mainBlue.withOpacity(0.65)],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       ),
            //       borderRadius: BorderRadius.all(Radius.circular(3.r)),
            //     ),
            //     child: Container(
            //       width: 70.w,
            //       padding: const EdgeInsets.all(8.0),
            //       child: const Text(
            //         'OK',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold, color: white),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
