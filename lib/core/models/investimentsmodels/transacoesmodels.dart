enum TipoTransacao {
  compra,
  venda,
}

class TransacaoModel {
  final String id;
  final String nomeAtivo;
  final TipoTransacao tipo;

  final double quantidade;
  final double precoUnitario;
  final double precoTotal;

  final DateTime dataHora;

  final double precoMedioAntes;
  final double precoMedioDepois;

  final double quantidadeAntes;
  final double quantidadeDepois;


  final String? origem;
  final String? observacao;

  TransacaoModel({
    required this.id,
    required this.nomeAtivo,
    required this.tipo,
    required this.quantidade,
    required this.precoUnitario,
    required this.precoTotal,
    required this.dataHora,
    required this.precoMedioAntes,
    required this.precoMedioDepois,
    required this.quantidadeAntes,
    required this.quantidadeDepois,
    this.origem,
    this.observacao,
  });
}
