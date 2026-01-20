import 'package:flutter/foundation.dart';
import '../services/adservice.dart';

class ActionAdCounter {
  ActionAdCounter({
    required this.every,
    this.enabled = true,
    this.onAdShown,
    this.onAdSkipped,
  }) : assert(every > 0);

  final int every;
  bool enabled;

  int _count = 0;

  /// opcional: callbacks pra você logar/telemetria
  final VoidCallback? onAdShown;
  final VoidCallback? onAdSkipped;

  int get count => _count;

  void reset() => _count = 0;

  void registerAction() {
    if (!enabled) return;
    _count++;

    if (_count % every == 0) {
      final showed = AdService.I.showInterstitialIfReady();
      if (showed) {
        onAdShown?.call();
      } else {
        onAdSkipped?.call();
        AdService.I.loadInterstitial();
      }
    }
  }
}
