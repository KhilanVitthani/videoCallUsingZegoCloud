// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdService {
//   BannerAd? bannerAd;
//   RxBool isBannerLoaded = false.obs;
//
//   initBannerAds() {
//     bannerAd = BannerAd(
//         size: AdSize.banner,
//         adUnitId: Platform.isAndroid?"ca-app-pub-3940256099942544/6300978111":"ca-app-pub-3940256099942544/2934735716",
//         listener: BannerAdListener(
//           onAdLoaded: (ad) {
//             isBannerLoaded.value = true;
//           },
//           onAdFailedToLoad: (ad, error) {
//             ad.dispose();
//           },
//         ),
//         request: AdRequest())
//       ..load();
//   }
//
//   Widget getBannerAds() {
//     return SizedBox(
//       width: bannerAd!.size.width.toDouble(),
//       height: bannerAd!.size.height.toDouble(),
//       child: AdWidget(ad: bannerAd!),
//     );
//   }
//
//   dispose() {
//     bannerAd?.dispose().then((value) => isBannerLoaded.value = false);
//   }
// }
