class Ativo {
  final String nome;
  final double rendaPorSegundo;
  final double custo;

  Ativo({
    required this.nome,
    required this.rendaPorSegundo,
    required this.custo,
  });

  factory Ativo.fromJson(Map<String, dynamic> json) {
    return Ativo(
      nome: json['nome'],
      rendaPorSegundo: (json['rendaPorSegundo'] as num).toDouble(),
      custo: (json['custo'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'rendaPorSegundo': rendaPorSegundo,
      'custo': custo,
    };
  }
}
