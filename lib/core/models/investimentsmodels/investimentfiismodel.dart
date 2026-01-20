import 'package:valoremidle/core/abstracsmodel/abs_investmentbase.dart';

class InvestimentoFiisModel extends InvestmentBase {
  InvestimentoFiisModel({
    required super.id,
    required super.nome,
    required super.logoPath,
    required super.precoAtual,
    required super.quantidade,
    required super.precoMedio,
    required super.rendimentoBase,
    required super.volatilidade,
    required super.temDividendos,
    required super.dividendYield,
    required super.acumulado, required super.setor,
  });

  @override
  void aplicarVariacaoMercado() {
    final variacao = (volatilidade * precoAtual) *
        (1 - 2 * (DateTime.now().millisecond % 2));
    precoAtual += variacao;
  }

  @override
  void pagarDividendos() {
    if (!temDividendos) return;
    acumulado += quantidade * (precoAtual * dividendYield / 12);
  }
}
