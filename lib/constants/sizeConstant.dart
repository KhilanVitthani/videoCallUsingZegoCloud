import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'color_constant.dart';
import 'image_constants.dart';

class MySize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late bool isMini;
  static double? safeWidth;
  static double? safeHeight;

  static late double scaleFactorWidth;
  static late double scaleFactorHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)
        ? _mediaQueryData.size.width
        : 390;
    screenHeight = (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)
        ? _mediaQueryData.size.height
        : _mediaQueryData.size.height;
    isMini = _mediaQueryData.size.height < 400;
    double _safeAreaWidth =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    double _safeAreaHeight =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeWidth = (screenWidth - _safeAreaWidth);
    safeHeight = (screenHeight - _safeAreaHeight);

    safeWidth = (screenWidth - _safeAreaWidth);
    safeHeight = (screenHeight - _safeAreaHeight);

    scaleFactorHeight = (safeHeight! / 932);
    if (scaleFactorHeight < 1) {
      double diff = (1 - scaleFactorHeight) * (1 - scaleFactorHeight);
      scaleFactorHeight += diff;
    }

    scaleFactorWidth = (safeWidth! / 430);

    if (scaleFactorWidth < 1) {
      double diff = (1 - scaleFactorWidth) * (1 - scaleFactorWidth);
      scaleFactorWidth += diff;
    }
  }

  static double getWidth(double size) {
    return (size * scaleFactorWidth);
  }

  static double getHeight(double size) {
    return (size * scaleFactorHeight);
  }

  static double setScaleHeight(double size) {
    return (MySize.screenHeight * size);
  }

  static double setScaleWidth(double size) {
    return (MySize.screenWidth * size);
  }
}

class Spacing {
  static EdgeInsetsGeometry zero = EdgeInsets.zero;

  static EdgeInsetsGeometry only(
      {double top = 0, double right = 0, double bottom = 0, double left = 0}) {
    return EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);
  }

  static EdgeInsetsGeometry fromLTRB(
      double left, double top, double right, double bottom) {
    return Spacing.only(bottom: bottom, top: top, right: right, left: left);
  }

  static EdgeInsetsGeometry all(double spacing) {
    return Spacing.only(
        bottom: spacing, top: spacing, right: spacing, left: spacing);
  }

  static EdgeInsetsGeometry left(double spacing) {
    return Spacing.only(left: spacing);
  }

  static EdgeInsetsGeometry nLeft(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing, right: spacing);
  }

  static EdgeInsetsGeometry top(double spacing) {
    return Spacing.only(top: spacing);
  }

  static EdgeInsetsGeometry nTop(double spacing) {
    return Spacing.only(left: spacing, bottom: spacing, right: spacing);
  }

  static EdgeInsetsGeometry right(double spacing) {
    return Spacing.only(right: spacing);
  }

  static EdgeInsetsGeometry nRight(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing, left: spacing);
  }

  static EdgeInsetsGeometry bottom(double spacing) {
    return Spacing.only(bottom: spacing);
  }

  static EdgeInsetsGeometry nBottom(double spacing) {
    return Spacing.only(top: spacing, left: spacing, right: spacing);
  }

  static EdgeInsetsGeometry horizontal(double spacing) {
    return Spacing.only(left: spacing, right: spacing);
  }

  static x(double spacing) {
    return Spacing.only(left: spacing, right: spacing);
  }

  static xy(double xSpacing, double ySpacing) {
    return Spacing.only(
        left: xSpacing, right: xSpacing, top: ySpacing, bottom: ySpacing);
  }

  static y(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing);
  }

  static EdgeInsetsGeometry vertical(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing);
  }

  static EdgeInsetsGeometry symmetric(
      {double vertical = 0, double horizontal = 0}) {
    return Spacing.only(
        top: vertical, right: horizontal, left: horizontal, bottom: vertical);
  }

  static Widget height(double height) {
    return SizedBox(
      height: MySize.getHeight(height),
    );
  }

  static Widget width(double width) {
    return SizedBox(
      width: MySize.getWidth(width),
    );
  }
}

class Space {
  Space();

  static Widget height(double space) {
    return SizedBox(
      height: MySize.getHeight(space),
    );
  }

  static Widget width(double space) {
    return SizedBox(
      width: MySize.getHeight(space),
    );
  }
}

enum ShapeTypeFor { container, button }

class Shape {
  static dynamic circular(double radius,
      {ShapeTypeFor shapeTypeFor = ShapeTypeFor.container}) {
    BorderRadius borderRadius =
        BorderRadius.all(Radius.circular(MySize.getHeight(radius)));

    switch (shapeTypeFor) {
      case ShapeTypeFor.container:
        return borderRadius;
      case ShapeTypeFor.button:
        return RoundedRectangleBorder(borderRadius: borderRadius);
    }
  }

  static dynamic circularTop(double radius,
      {ShapeTypeFor shapeTypeFor = ShapeTypeFor.container}) {
    BorderRadius borderRadius = BorderRadius.only(
        topLeft: Radius.circular(MySize.getHeight(radius)),
        topRight: Radius.circular(MySize.getHeight(radius)));
    switch (shapeTypeFor) {
      case ShapeTypeFor.container:
        return borderRadius;

      case ShapeTypeFor.button:
        return RoundedRectangleBorder(borderRadius: borderRadius);
    }
  }
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}

getSnackBar(
    {required BuildContext context,
    String text = "",
    double size = 16,
    int duration = 500}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: TextStyle(fontSize: MySize.getHeight(size))),
      duration: Duration(milliseconds: duration),
    ),
  );
}

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else
    return null;
}

Widget getButton({
  double? height,
  double? width,
  required String text,
  required Function() onTap,
  Color? color,
  Color? shadowColor,
  Color? textColor,
  double? fontSize,
  FontWeight? fontWeight,
  double? radius,
  Color? borderColor,
  Widget? widget,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: MySize.getHeight(width ?? 268),
      height: MySize.getHeight(height ?? 46),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: color ?? appTheme.primaryTheme,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
          side: BorderSide(
            color: borderColor ?? appTheme.primaryTheme,
            width: 1,
          ),
        ),
        shadows: [
          BoxShadow(
            color: shadowColor ?? Color(0x3F5FB822),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isNullEmptyOrFalse(widget)) ...[
            // Spacing.width(8),
            widget!,
            Spacing.width(8),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? appTheme.white,
              fontSize: MySize.getHeight(fontSize ?? 17),
              fontFamily: 'Urbanist',
              fontWeight: fontWeight ?? FontWeight.w700,
              height: 0,
            ),
          ),
        ],
      ),
    ),
  );
}

String timeAgoSinceDate({bool numericDates = true, required String dateTime}) {
  DateTime date = DateTime.parse(dateTime).toLocal();
  final date2 = DateTime.now().toLocal();
  final difference = date2.difference(date);

  if (difference.inSeconds < 5) {
    return 'Just now';
  } else if (difference.inSeconds <= 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes <= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inMinutes <= 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours <= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inHours <= 60) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays <= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inDays <= 6) {
    return '${difference.inDays} days ago';
  } else if ((difference.inDays / 7).ceil() <= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if ((difference.inDays / 7).ceil() <= 4) {
    return '${(difference.inDays / 7).ceil()} weeks ago';
  } else if ((difference.inDays / 30).ceil() <= 1) {
    return (numericDates) ? '1 month ago' : 'Last month';
  } else if ((difference.inDays / 30).ceil() <= 30) {
    return '${(difference.inDays / 30).ceil()} months ago';
  } else if ((difference.inDays / 365).ceil() <= 1) {
    return (numericDates) ? '1 year ago' : 'Last year';
  }
  return '${(difference.inDays / 365).floor()} years ago';
}
