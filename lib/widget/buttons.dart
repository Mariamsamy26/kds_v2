import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import '../styles/text_style.dart';

class OrangeButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const OrangeButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(goSmartBlue),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
        ),
        onPressed: onPressed,
        child: Text(label, style: mediumText.copyWith(fontSize: 18.sp, color: white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class GreyButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const GreyButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
        ),
        onPressed: onPressed,
        child: Text(label, style: mediumText.copyWith(fontSize: 18.sp, color: Colors.grey[800])),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const CancelButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
          backgroundColor: const WidgetStatePropertyAll(Color.fromRGBO(251, 170, 171, 1)),
        ),
        onPressed: onPressed,
        child: Text(label, style: boldText.copyWith(color: Colors.red)),
      ),
    );
  }
}

class DisabledButton extends StatelessWidget {
  final String label;

  const DisabledButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
          backgroundColor: const WidgetStatePropertyAll(Colors.grey),
        ),
        onPressed: null,
        child: Text(label, style: boldText.copyWith(color: Colors.white)),
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const BorderButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: const BorderSide(color: goSmartBlue, width: 2),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: mediumText.copyWith(fontSize: 18.sp, color: goSmartBlue)),
      ),
    );
  }
}
