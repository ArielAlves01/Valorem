import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:valoremidle/core/models/balancemodel.dart';
import 'package:valoremidle/core/models/ativosmodel.dart';
import 'package:valoremidle/core/models/passivosmodel.dart';

class BalanceViewModel extends ChangeNotifier {
  BalanceModel balance;
  final List<Ativo> ativos = [];
  final List<Passivo> passivos = [];

  SharedPreferences? _prefs;
  bool _dirty = false; // mudou algo que precisa salvar?

  // --- Boost / Multipliers ---
  double _clickMultiplier = 1.0;
  double get clickMultiplier => _clickMultiplier;
  void setClickMultiplier(double v) {
    final nv = v <= 0 ? 1.0 : v;
    if (_clickMultiplier == nv) return;
    _clickMultiplier = nv;
    notifyListeners();
  }

  // --- Offline earnings (pendente, precisa ver anúncio para resgatar) ---
  double _offlinePendente = 0.0;
  int _offlineMinutos = 0;
  bool get temOfflinePendente => _offlinePendente > 0 && _offlineMinutos > 0;
  double get offlinePendenteValor => _offlinePendente;
  int get offlinePendenteMinutos => _offlineMinutos;

  // agenda do empreendimento: paga em blocos de 5 minutos
  int _empreTickCounter = 0;

  BalanceViewModel({BalanceModel? inicial})
      : balance = inicial ??
      BalanceModel(
        saldo: 0.0,
        rendaAtivaPorToque: 1.0,
        rendaPassivaPorMinuto: 0.50,
      );

  /// Chame isso uma vez no boot (GameInitializer).
  Future<void> initStorage() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /* ======================================================
   * GETTERS
   * ====================================================== */

  double get rendaPassivaTotalPorMinuto {
    final rendaAtivos =
    ativos.fold(0.0, (s, a) => s + (a.rendaPorSegundo * 60));
    final custoPassivos =
    passivos.fold(0.0, (s, p) => s + (p.custoPorSegundo * 60));

    return rendaAtivos + balance.rendaPassivaPorMinuto - custoPassivos;
  }

  double get rendaPassivaTotalPorSegundo => rendaPassivaTotalPorMinuto / 60;

  /* ======================================================
   * FUNÇÕES PRINCIPAIS
   * ====================================================== */

  /// Tick do jogo em "minutos de jogo".
  /// Se seu Timer roda a cada 1 minuto, passe minutes: 1.
  void aplicarTick({double multiplier = 1.0, int minutes = 1}) {
    if (minutes <= 0) return;

    // Base passiva (sem empreendimento) cai todo minuto
    final basePassiva = (balance.rendaPassivaPorMinuto) * minutes * multiplier;

    // Empreendimentos (ativos) pagam em blocos de 5 minutos, com imposto 27.5%
    _empreTickCounter += minutes;
    double empreLiquido = 0.0;
    if (_empreTickCounter >= 5) {
      final blocos = _empreTickCounter ~/ 5;
      _empreTickCounter = _empreTickCounter % 5;

      final rendaEmprePorMin = ativos.fold(0.0, (s, a) => s + (a.rendaPorSegundo * 60));
      final bruto = rendaEmprePorMin * (5 * blocos) * multiplier;
      final imposto = bruto * 0.275;
      empreLiquido = (bruto - imposto);
    }

    // Custos passivos (se existirem) descontam continuamente
    final custoPassivos = passivos.fold(0.0, (s, p) => s + (p.custoPorSegundo * 60));
    final custo = custoPassivos * minutes; // custo não recebe multiplicador

    final ganho = basePassiva + empreLiquido - custo;
    if (ganho == 0) return;

    balance = balance.copyWith(saldo: balance.saldo + ganho);

    _markDirty();
    notifyListeners();
  }

  void toque({double multiplier = 1.0}) {
    final ganho = balance.rendaAtivaPorToque * multiplier;

    balance = balance.copyWith(
      saldo: balance.saldo + ganho,
    );

    _markDirty();
    notifyListeners();
  }

  void adicionarAtivo(Ativo a) {
    ativos.add(a);
    _markDirty();
    notifyListeners();
  }

  void adicionarPassivo(Passivo p) {
    passivos.add(p);
    _markDirty();
    notifyListeners();
  }

  void _markDirty() {
    _dirty = true;
  }

  /* ======================================================
   * INVESTIMENTOS / MOVIMENTAÇÃO DE SALDO
   * (Adicionado sem renomear nada do que já existe)
   * ====================================================== */

  bool temSaldo(double valor) {
    if (valor <= 0) return true;
    return balance.saldo >= valor;
  }

  /// Debita do saldo, se possível. Retorna true se debitou.
  bool gastarSaldo(double valor) {
    if (valor <= 0) return true;
    if (!temSaldo(valor)) return false;

    balance = balance.copyWith(saldo: balance.saldo - valor);
    _markDirty();
    notifyListeners();
    return true;
  }

  /// Credita no saldo (venda / coleta / recompensa etc.)
  void adicionarSaldo(double valor) {
    if (valor == 0) return;

    balance = balance.copyWith(saldo: balance.saldo + valor);
    _markDirty();
    notifyListeners();
  }

  /* ======================================================
   * SALVAR E CARREGAR
   * ====================================================== */

  /// Salva APENAS quando você decidir (autosave / pause / manual).
  Future<void> saveBalanceIfDirty() async {
    if (!_dirty) return;
    await saveBalance();
  }

  Future<void> saveBalance() async {
    await initStorage();
    final prefs = _prefs!;

    final data = {
      "balance": balance.toJson(),
      "ativos": ativos.map((a) => a.toJson()).toList(),
      "passivos": passivos.map((p) => p.toJson()).toList(),
      "lastSavedAtMs": DateTime.now().millisecondsSinceEpoch,
    };

    await prefs.setString("balance_data", jsonEncode(data));
    _dirty = false;
  }

  Future<void> loadBalance() async {
    await initStorage();
    final prefs = _prefs!;
    final saved = prefs.getString("balance_data");

    if (saved == null) return;

    try {
      final Map<String, dynamic> data = jsonDecode(saved);

      balance = BalanceModel.fromJson(data["balance"]);

      ativos
        ..clear()
        ..addAll((data["ativos"] as List).map((e) => Ativo.fromJson(e)));

      passivos
        ..clear()
        ..addAll((data["passivos"] as List).map((e) => Passivo.fromJson(e)));

      // Offline pendente (cap 8h) - não credita automático
      final lastMs = (data["lastSavedAtMs"] as num?)?.toInt();
      if (lastMs != null) {
        final diff = DateTime.now().millisecondsSinceEpoch - lastMs;
        final mins = (diff ~/ 60000);
        final cappedMins = mins.clamp(0, 480);
        if (cappedMins > 0) {
          _offlineMinutos = cappedMins;
          _offlinePendente = rendaPassivaTotalPorMinuto * cappedMins;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("ERRO ao carregar balance: $e");
      }
    }

    notifyListeners();
  }

  /// Chame depois de ver o anúncio rewarded para resgatar.
  double resgatarOfflinePendente() {
    if (!temOfflinePendente) return 0.0;
    final v = _offlinePendente;
    _offlinePendente = 0.0;
    _offlineMinutos = 0;
    adicionarSaldo(v);
    return v;
  }
}
