import 'dart:io';

class AdsManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7032258249264130~6344876959";
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7032258249264130/8779468606";
    }
  }
}
