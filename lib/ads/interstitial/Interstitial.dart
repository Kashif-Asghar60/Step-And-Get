// import 'dart:async';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class InterstitialAdService {
//   late InterstitialAd _interstitialAd;
//   bool _isInterstitialAdReady = false;
//   final String adUnitId;
//   final String loadedEventName;
//   final String clickedEventName;
//   final String showedEventName;
//   final String impressionEventName;
//   final String screenName;
//   final String failedEventName;
//   final String dismissEventName;
//
//   InterstitialAdService({
//     required this.adUnitId,
//     required this.loadedEventName,
//     required this.clickedEventName,
//     required this.showedEventName,
//     required this.impressionEventName,
//     required this.screenName,
//     required this.dismissEventName,
//     required this.failedEventName,
//   });
//
//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: adUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           this._interstitialAd = ad;
//
//           FirebaseAnalytics.instance.logEvent(
//               name: loadedEventName, parameters: {'screen_name': screenName});
//
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdClicked: (ad) {
//               FirebaseAnalytics.instance.logEvent(
//                   name: clickedEventName,
//                   parameters: {'screen_name': screenName});
//             },
//             onAdShowedFullScreenContent: (ad) {
//               FirebaseAnalytics.instance.logEvent(
//                   name: showedEventName,
//                   parameters: {'screen_name': screenName});
//             },
//             onAdImpression: (ad) {
//               FirebaseAnalytics.instance.logEvent(
//                   name: impressionEventName,
//                   parameters: {'screen_name': screenName});
//             },
//             onAdDismissedFullScreenContent: (ad) {
//               FirebaseAnalytics.instance.logEvent(
//                   name: dismissEventName,
//                   parameters: {'screen_name': screenName});
//               _interstitialAd.dispose();
//               loadInterstitialAd();
//             },
//           );
//
//           _isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (ad) {
//           FirebaseAnalytics.instance.logEvent(
//               name: failedEventName, parameters: {'screen_name': screenName});
//         },
//       ),
//     );
//   }
//
//   Future<bool> showInterstitialAd() async {
//     if (_isInterstitialAdReady) {
//       await _interstitialAd.show();
//       _isInterstitialAdReady = false;
//       loadInterstitialAd();
//       return true;
//     }
//     return false;
//   }
//
//   // Future<bool> showInterstitialAd() async {
//   //   await _interstitialAd.show();
//   //   _isInterstitialAdReady = false;
//   //   loadInterstitialAd();
//   //   return true;
//   // }
//
//   @override
//   void dispose() {
//     _interstitialAd.dispose();
//   }
//
//   bool get isInterstitialAdReady => _isInterstitialAdReady;
// }
