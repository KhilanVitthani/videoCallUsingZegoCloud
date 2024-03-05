import 'package:flutter/material.dart';
import 'package:video_call/constants/sizeConstant.dart';

class BaseTheme {
  Color get primaryTheme => fromHex("#5FB822");
  Color get greyColor => fromHex("#E7E7E7");
  Color get lightGreyColor => fromHex("#BDBFC4");
  Color get buttonGreyColor => Color(0xFFEDEDED);
  Color get greyColorShare => fromHex("#A7A7A7");
  Color get textDarkGrey => fromHex("#878787");
  Color get borderColor => fromHex("#C2C2C2");
  Color get greenColor => fromHex("#47EB4E");
  Color get white => fromHex("#FFFFFF");
  Color get black => fromHex("#000000");
  Color get blue => Color(0xFF2D62E9);
  Color get shadowColor => Color(0x26000000);
  Color get darkShadowColor => Color(0xFF444150);
  Color get textGreyColor => Color(0xFF414141);
  Color get dividerColor => Color(0xFFD7D7D7);
  Color get profileImageContainerBorder => Color(0xffD9D9D9);
  Color get red => Colors.red;
  Color get lightGreenColor => Color(0xFFF1FFE8);
  Color get textFieldBorderColor => Color(0xFFDBDBDB);
  Color get lightBlackColor => fromHex("#4B4B4B");

  List<BoxShadow> get getShadow {
    return [
      BoxShadow(
        offset: Offset(2, 2),
        color: Colors.black26,
        blurRadius: MySize.getHeight(2),
        spreadRadius: MySize.getHeight(2),
      ),
      BoxShadow(
        offset: Offset(-1, -1),
        color: appTheme.white.withOpacity(0.8),
        blurRadius: MySize.getHeight(2),
        spreadRadius: MySize.getHeight(2),
      ),
    ];
  }

  List<BoxShadow> get getShadow3 {
    return [
      BoxShadow(
        offset: Offset(2, 2),
        color: Colors.black12,
        blurRadius: MySize.getHeight(0.5),
        spreadRadius: MySize.getHeight(0.5),
      ),
      BoxShadow(
        offset: Offset(-1, -1),
        color: appTheme.white.withOpacity(0.8),
        blurRadius: MySize.getHeight(0.5),
        spreadRadius: MySize.getHeight(0.5),
      ),
    ];
  }

  List<BoxShadow> get getShadow2 {
    return [
      BoxShadow(
          offset: Offset(MySize.getWidth(2.5), MySize.getHeight(2.5)),
          color: Color(0xffAEAEC0).withOpacity(0.4),
          blurRadius: MySize.getHeight(5),
          spreadRadius: MySize.getHeight(0.2)),
      BoxShadow(
          offset: Offset(MySize.getWidth(-2.5), MySize.getHeight(-2.5)),
          color: Color(0xffFFFFFF).withOpacity(0.4),
          blurRadius: MySize.getHeight(5),
          spreadRadius: MySize.getHeight(0.2)),
    ];
  }

  LinearGradient get getGradient1 {
    return LinearGradient(
      begin: Alignment(-0.6449, 0.9999),
      end: Alignment(0.1412, -0.4165),
      colors: [
        Color(0xFFFFD363),
        Color(0xFFFF621F),
      ],
      // stops: [0.4234, 0.9996],
      transform: GradientRotation(91.91 * 3.1415 / 180),
    );
  }

  LinearGradient get getGradient {
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        Color(0xffFF621F),
        Color(0xffFFD363),
      ],
    );
  }
}

BaseTheme get appTheme => BaseTheme();

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
