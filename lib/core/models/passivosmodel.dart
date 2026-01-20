class Passivo {
  final String nome;
  final double custoPorSegundo;
  final double valor;

  Passivo({
    required this.nome,
    required this.custoPorSegundo,
    required this.valor,
  });

  factory Passivo.fromJson(Map<String, dynamic> json) {
    return Passivo(
      nome: json['nome'],
      custoPorSegundo: (json['custoPorSegundo'] as num).toDouble(),
      valor: (json['valor'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'custoPorSegundo': custoPorSegundo,
      'valor': valor,
    };
  }
}
