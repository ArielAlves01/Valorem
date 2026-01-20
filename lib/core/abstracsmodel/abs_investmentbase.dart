import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

abstract class InvestmentBase {
  // ---------- ATRIBUTOS FIXOS ----------
  final String id;
  final String nome;
  final String logoPath;

  /// Rendimento por minuto (ex: 0.012 = 1.2%)
  final double rendimentoBase;

  /// Variação típica de preço (0.01 = 1% por tick)
  final double volatilidade;

  /// Indica se gera rendimentos (dividendos, cupons, staking…)
  final bool temDividendos;

  /// Percentual anual/mensal dependendo do tipo (ex: 6% a.a)
  final double dividendYield;

  // ---------- ESTADO QUE MUDA ----------
  double precoAtual;
  double quantidade;
  double acumulado;
  double precoMedio;
  final Setor setor;
  InvestmentBase({
    required this.id,
    required this.nome,
    required this.logoPath,
    required this.precoAtual,
    required this.quantidade,
    required this.precoMedio,
    required this.rendimentoBase,
    required this.volatilidade,
    required this.temDividendos,
    required this.dividendYield,
    required this.acumulado,
    required this.setor,
  });

  // =============================================================
  // MÉTODOS QUE DEVEM SER IMPLEMENTADOS PELAS CLASSES FILHAS
  // =============================================================

  /// Como o ativo reage ao mercado
  void aplicarVariacaoMercado();

  /// Como o ativo gera dividendos/rendimentos
  void pagarDividendos();

  /// A cada tick do game loop
  void processarTick() {
    aplicarVariacaoMercado();
    pagarDividendos();
  }

  // =============================================================
  // MÉTODOS COMUNS PARA TODOS OS TIPOS DE INVESTIMENTO
  // =============================================================

  /// Comprar unidades — controla preço médio automaticamente
  void comprar(double qtd) {
    if (qtd <= 0) return;

    final custoTotal = precoAtual * qtd;
    precoMedio = ((precoMedio * quantidade) + custoTotal) /
        (quantidade + qtd);

    quantidade += qtd;
  }

  /// Vender unidades do ativo
  void vender(double qtd) {
    if (qtd <= 0) return;
    if (qtd > quantidade) qtd = quantidade;

    quantidade -= qtd;

    // Opcional: ao zerar posição, pode resetar preço médio
    if (quantidade == 0) {
      precoMedio = 0;
    }
  }

  /// Coletar dividendos/rendimentos acumulados
  double coletarRendimentos() {
    final valor = acumulado;
    acumulado = 0;
    return valor;
  }

  double variacaoPercentualPreco() {
    if (precoMedio <= 0) return 0;
    return (precoAtual - precoMedio) / precoMedio; // ex: 0.12 = +12%
  }

}
