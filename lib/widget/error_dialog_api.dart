import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kds/helpers/application_dimentions.dart';
import 'package:kds/styles/text_style.dart';

class ApiErrorDialog extends StatefulWidget {
  final String message;
  final String errorDetails;
  final Function() onPressed;

  const ApiErrorDialog({
    super.key,
    required this.message,
    required this.errorDetails,
    required this.onPressed,
  });

  @override
  State<ApiErrorDialog> createState() => _ApiErrorDialogState();
}

class _ApiErrorDialogState extends State<ApiErrorDialog> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    return Directionality(
      textDirection: context.locale == const Locale('ar')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        content: SizedBox(
          width: AppDimentions().availableWidth * 0.4,
          height: AppDimentions().availableheightNoAppBar * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER
              Padding(
                padding: context.locale == const Locale('ar')
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'alert'.tr(),
                        style: mediumText.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // MAIN ERROR MESSAGE
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 45.sp,
                    ),

                    SizedBox(height: 15.h),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: mediumText.copyWith(fontSize: 18.sp),
                      ),
                    ),

                    // ERROR DETAILS
                    if (showDetails) ...[
                      SizedBox(height: 20.h),

                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxHeight: 120.h),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            widget.errorDetails,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.red.shade800,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showDetails = !showDetails;
                          });
                        },
                        child: Text('showDetails ? '),
                      ),
                    ),

                    SizedBox(width: 10.w),

                    // OK BUTTON
                    Expanded(
                      child: ElevatedButton(
                        child: Text('ok'.tr()),
                        onPressed: () {
                          widget.onPressed();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
