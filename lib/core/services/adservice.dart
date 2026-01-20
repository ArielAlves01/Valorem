import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();
  static final AdService I = AdService._();

  bool _initialized = false;
  bool _adsEnabled = true;

  bool get isInitialized => _initialized;
  bool get adsEnabled => _adsEnabled;

  void setAdsEnabled(bool v) => _adsEnabled = v;

  Future<void> init() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  // Banner
  String get bannerUnitId {
    if (kDebugMode) {
      // IDs oficiais de teste
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
      return 'ca-app-pub-3940256099942544/6300978111'; // Android
    }

    // PRODUÇÃO (trocar depois)
    if (Platform.isIOS) return 'ca-app-pub-xxxx/IOS_BANNER';
    return 'ca-app-pub-xxxx/ANDROID_BANNER';
  }

  // Interstitial (vídeo/tela cheia)
  String get interstitialUnitId {
    if (kDebugMode) {
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    if (Platform.isIOS) return 'ca-app-pub-xxxx/IOS_INTER';
    return 'ca-app-pub-xxxx/ANDROID_INTER';
  }

  InterstitialAd? _interstitial;
  bool _loadingInter = false;

  void loadInterstitial() {
    if (_loadingInter || _interstitial != null) return;
    _loadingInter = true;

    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingInter = false;
          _interstitial = ad;
        },
        onAdFailedToLoad: (err) {
          _loadingInter = false;
          _interstitial = null;
        },
      ),
    );
  }

  bool showInterstitialIfReady({VoidCallback? onClosed}) {
    final ad = _interstitial;
    if (ad == null) return false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitial = null;
        loadInterstitial();
        onClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitial = null;
        loadInterstitial();
        onClosed?.call();
      },
    );

    ad.show();
    _interstitial = null;
    return true;
  }

  // =============================================================
  // Rewarded (vídeo com recompensa)
  // =============================================================
  String get rewardedUnitId {
    if (kDebugMode) {
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/1712485313';
      return 'ca-app-pub-3940256099942544/5224354917'; // Android
    }
    if (Platform.isIOS) return 'ca-app-pub-xxxx/IOS_REWARDED';
    return 'ca-app-pub-xxxx/ANDROID_REWARDED';
  }

  RewardedAd? _rewarded;
  bool _loadingRewarded = false;

  void loadRewarded() {
    if (_loadingRewarded || _rewarded != null) return;
    _loadingRewarded = true;

    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingRewarded = false;
          _rewarded = ad;
        },
        onAdFailedToLoad: (_) {
          _loadingRewarded = false;
          _rewarded = null;
        },
      ),
    );
  }

  bool showRewardedIfReady({
    required void Function(RewardItem reward) onEarned,
    VoidCallback? onClosed,
  }) {
    final ad = _rewarded;
    if (ad == null) return false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewarded = null;
        loadRewarded();
        onClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewarded = null;
        loadRewarded();
        onClosed?.call();
      },
    );

    ad.show(onUserEarnedReward: (_, reward) => onEarned(reward));
    _rewarded = null;
    return true;
  }
}
