// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class RewardedAdManager {
//   static final RewardedAdManager _instance = RewardedAdManager._internal();
//
//   factory RewardedAdManager() => _instance;
//
//   late RewardedAd rewardedAd;
//
//   RewardedAdManager._internal();
//
//   Future<void> initialize() async {
//     rewardedAd = RewardedAd(
//       adUnitId: '<your_ad_unit_id>',
//       request: AdRequest(),
//       listener: AdListener(
//         onRewardedAdUserEarnedReward: (_, reward) {
//           // Handle the reward and add 20 points to the user's total
//           // You can update the points in the top section here
//           print('Reward earned: ${reward.amount}');
//           // Add your logic to update the points count in the top section
//         },
//         onAdFailedToLoad: (ad, error) {
//           print('Rewarded ad failed to load: $error');
//         },
//       ),
//     );
//
//     await rewardedAd.load();
//   }
//
//   void showRewardedAd() {
//     if (rewardedAd != null) {
//       rewardedAd.show();
//     } else {
//       print('Rewarded ad is not ready yet.');
//     }
//   }
// }
