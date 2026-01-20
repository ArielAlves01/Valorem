import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:valoremidle/core/services/auto_save.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';

class GameLoopService {
  final BalanceViewModel _balanceVM;
  final PlayerViewModel _playerVM;
  final AutoSaveService _autosave;
  Timer? _timer;
  double multiplier = 1.0;
  bool _initialized = false;

  GameLoopService(this._balanceVM, this._playerVM, this._autosave);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await Future.wait([_playerVM.loadProgress(), _balanceVM.loadBalance()]);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _balanceVM.aplicarTick(multiplier: multiplier, minutes: 1);
    });

    _autosave.start(interval: const Duration(seconds: 30));
  }

  void dispose() {
    _timer?.cancel();
    _autosave.dispose();
  }
}
