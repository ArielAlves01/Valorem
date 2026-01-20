import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:valoremidle/core/services/auto_save.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';

class GameLoopService {
  final BalanceViewModel _balanceVM;
  final PlayerViewModel _playerVM;
  final AutoSaveService _autosave;
  final CarteiraDeInvestimentos _carteira;

  Timer? _timer;
  double multiplier = 1.0; // reservado (não use pro boost de clique)

  DateTime _boostUntil = DateTime.fromMillisecondsSinceEpoch(0);

  bool _initialized = false;
  bool _loopRunning = false;
  bool _initInProgress = false;

  GameLoopService(this._balanceVM, this._playerVM, this._autosave, this._carteira);

  double get rendimentoBonusMultiplier => _playerVM.removeAdsComprado ? 1.2 : 1.0;
  double get boostMultiplier => DateTime.now().isBefore(_boostUntil) ? 2.0 : 1.0;
  double get clickMultiplier => boostMultiplier * rendimentoBonusMultiplier;

  Future<void> init() async {
    if (_initialized || _initInProgress) return;
    _initInProgress = true;

    try {
      await Future.wait([
        _playerVM.loadProgress(),
        _balanceVM.loadBalance(),
      ]);

      _initialized = true;

      // Pré-carrega rewarded/interstitial por padrão (se ads enabled)
      // Não derruba se não estiver pronto.
      // (O flag de adsEnabled é setado no RootScaffold)
      //
      _startLoop();

      _autosave.start(interval: const Duration(seconds: 30));
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('❌ GameLoop init error: $e');
        debugPrint('$s');
      }
      // Não derruba o app por causa de storage.
      // Em produção, você pode apenas seguir com estado inicial.
    } finally {
      _initInProgress = false;
    }
  }

  void _startLoop() {
    if (_loopRunning) return;
    _loopRunning = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      try {
        // 1) multipliers atuais
        _balanceVM.setClickMultiplier(clickMultiplier);

        // 2) renda passiva (com +20% se remove ads)
        _balanceVM.aplicarTick(multiplier: rendimentoBonusMultiplier, minutes: 1);

        // 3) mercado (1h) e dividendos (3min) - credita automático
        final div = _carteira.processarMinutos(minutes: 1);
        if (div > 0) {
          _balanceVM.adicionarSaldo(div * rendimentoBonusMultiplier);
        }
      } catch (e, s) {
        if (kDebugMode) {
          debugPrint('❌ Tick error: $e');
          debugPrint('$s');
        }
      }
    });
  }

  void setMultiplier(double m) => multiplier = m;

  /// Rewarded: soma 1 minuto de boost (stack). Se já estiver ativo, empilha.
  void addBoost1Min() {
    final now = DateTime.now();
    if (_boostUntil.isAfter(now)) {
      _boostUntil = _boostUntil.add(const Duration(minutes: 1));
    } else {
      _boostUntil = now.add(const Duration(minutes: 1));
    }

    _balanceVM.setClickMultiplier(clickMultiplier);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _loopRunning = false;

    // best effort
    _autosave.flush();
    _autosave.dispose();
  }
}
