abstract class SetorEconomico {
  String nome;
  double riscoBase;
  double crescimentoBase;
  double influenciaGlobal;
  double variacaoSetor;

  SetorEconomico({
    required this.nome,
    required this.riscoBase,
    required this.crescimentoBase,
    required this.influenciaGlobal,
    required this.variacaoSetor,
  });

  /// Atualiza o setor (economia setorial)
  void processarTick();

  /// Gera uma variação que afetará os investimentos desse setor
  double gerarVariacao();
}
