import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:video_call/constants/sizeConstant.dart';

import 'color_constant.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              appTheme.white,
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) Get.back();
    isProgressVisible = false;
  }
}

class CustomDialogs {
  void showCircularDialog(BuildContext context) {
    CircularDialog.showLoadingDialog(context);
  }

  void hideCircularDialog(BuildContext context) {
    Get.back();
  }

  // showCupertinoWarningDialog(
  //   BuildContext context, {
  //   required String title,
  //   required String warningText,
  //   required String buttonText,
  //   VoidCallback? onPressed,
  // }) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         title: Column(
  //           children: <Widget>[
  //             Text(
  //               title,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  showConformationDialog({
    required BuildContext context,
    String title = "Delete",
    String desc = "Are you sure?",
    VoidCallback? yesTap,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: appTheme.white,
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(desc),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "No",
                      style: TextStyle(color: appTheme.red),
                    ),
                  ),
                  TextButton(
                    onPressed: yesTap,
                    child: Text(
                      "Yes",
                      style: TextStyle(color: appTheme.primaryTheme),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

/*  showCupertinoWarningDialog(
    BuildContext context, {
    required String info_text,
    required bool isSuccessful,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        var isDark = context.watch<ModelTheme>().isDark;
        return AlertDialog(
          backgroundColor:
              (isDark) ? Colors.black.withOpacity(1) : Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Spacing.height(20),
              Image.asset(
                isSuccessful
                    ? "assets/image/done.png"
                    : "assets/image/wrong.png",
                height: MySize.getHeight(80),
                width: MySize.getWidth(80),
              ),
              Spacing.height(20),
              Text(
                info_text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MySize.getHeight(14),
                  color: (isDark) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacing.height(20),
              getButton(
                text: isSuccessful ? "Done" : "Try Again",
                onTap: onPressed ??
                    () {
                      Get.back();
                    },
              ),
            ],
          ),
        );
      },
    );
  }*/

  showCupertinoDialog(
      {required BuildContext context,
      required String title,
      required String warningText,
      required List<CupertinoDialogAction> actions}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title),
            ],
          ),
          content: new Text(warningText),
          actions: actions,
        );
      },
    );
  }

  getDialog(
      {String title = "Error",
      String desc = "Some Thing went wrong....",
      bool isBarrierDismissible = false,
      Callback? onTap}) {
    return Get.defaultDialog(
        barrierDismissible: isBarrierDismissible,
        title: title,
        content: Center(
          child: Text(desc, textAlign: TextAlign.center),
        ),
        buttonColor: appTheme.primaryTheme,
        textConfirm: "Ok",
        confirmTextColor: appTheme.white,
        onConfirm: (isNullEmptyOrFalse(onTap))
            ? () {
                Get.back();
              }
            : onTap);
  }
}

class CircularDialog {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Center(
              child: CircularProgressIndicator(color: appTheme.primaryTheme),
            ),
            onWillPop: () async {
              return false;
            });
      },
      barrierDismissible: false,
    );
  }
}
