import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';

class AutoSaveService {
  final PlayerViewModel playerVM;
  final BalanceViewModel balanceVM;

  Timer? _timer;
  bool _running = false;

  AutoSaveService({
    required this.playerVM,
    required this.balanceVM,
  });

  void start({Duration interval = const Duration(seconds: 30)}) {
    if (_running) return;
    _running = true;

    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) async {
      try {
        await Future.wait([
          playerVM.saveProgressIfDirty(),
          balanceVM.saveBalanceIfDirty(),
        ]);
      } catch (e, s) {
        if (kDebugMode) {
          debugPrint('❌ Autosave error: $e');
          debugPrint('$s');
        }
      }
    });
  }

  Future<void> flush() async {
    await Future.wait([
      playerVM.saveProgressIfDirty(),
      balanceVM.saveBalanceIfDirty(),
    ]);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  void dispose() {
    stop();
  }
}
