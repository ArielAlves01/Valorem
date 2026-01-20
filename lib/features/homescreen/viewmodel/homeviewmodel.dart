// features/homescreen/viewmodel/homeviewmodel.dart
import 'package:flutter/material.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';


class HomeViewModel extends ChangeNotifier {

  /// Aciona a renda ativa (toque) usando o BalanceViewModel global
  void gerarRendaAtiva(BalanceViewModel balanceVM, {double? multiplier}) {
    balanceVM.toque(multiplier: multiplier ?? 1.0);
  }

/// No futuro:
/// comprarInvestimento()
/// fazerUpgrade()
/// verDetalhes()
}
