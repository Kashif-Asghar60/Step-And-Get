import 'dart:io';

///Banner Ad
class AdHelper {
  static String get rewardedAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
