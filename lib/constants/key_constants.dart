import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const googleApiKey = "AIzaSyBhCef5WuAuPKRVoPuWQASD6avTs16x7uE";

double maxHeight = 773;
double maxWidth = 390;

var constrainsForWeb = !isWeb
    ? null
    : BoxConstraints(
        // minHeight: maxHeight,
        // maxHeight: maxHeight,
        minWidth: maxWidth,
        maxWidth: maxWidth,
      );

bool isWeb = (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)
    ? false
    : true;
