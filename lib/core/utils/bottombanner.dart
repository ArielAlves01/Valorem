import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/adservice.dart';

class BottomBanner extends StatefulWidget {
  const BottomBanner({super.key});

  @override
  State<BottomBanner> createState() => _BottomBannerState();
}

class _BottomBannerState extends State<BottomBanner> {
  BannerAd? _banner;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AdService.I.adsEnabled) return;

    if (!AdService.I.isInitialized) {
      await AdService.I.init();
    }

    final ad = BannerAd(
      adUnitId: AdService.I.bannerUnitId, // <- aqui: teste no debug, real no release
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    );

    _banner = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdService.I.adsEnabled) return const SizedBox.shrink();

    final h = AdSize.banner.height.toDouble();

    // Reserva espaço fixo (não pula)
    return SizedBox(
      height: h,
      width: double.infinity,
      child: _loaded && _banner != null
          ? Center(child: AdWidget(ad: _banner!))
          : const SizedBox.shrink(),
    );
  }
}
