class BalanceModel {
  final double saldo;
  final double rendaAtivaPorToque;
  final double rendaPassivaPorMinuto;

  BalanceModel({
    required this.saldo,
    required this.rendaAtivaPorToque,
    required this.rendaPassivaPorMinuto,
  });

  BalanceModel copyWith({
    double? saldo,
    double? rendaAtivaPorToque,
    double? rendaPassivaPorMinuto,
  }) {
    return BalanceModel(
      saldo: saldo ?? this.saldo,
      rendaAtivaPorToque: rendaAtivaPorToque ?? this.rendaAtivaPorToque,
      rendaPassivaPorMinuto: rendaPassivaPorMinuto ??
          this.rendaPassivaPorMinuto,
    );
  }

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    try {
      return BalanceModel(
        saldo: (json['saldo'] as num).toDouble(),
        rendaAtivaPorToque: (json['rendaAtivaPorToque'] as num).toDouble(),
        rendaPassivaPorMinuto: (json['rendaPassivaPorMinuto'] as num).toDouble(),
      );
    } catch (e) {
      print("Erro ao carregar BalanceModel: $e");
      return BalanceModel(
        saldo: 0,
        rendaAtivaPorToque: 1,
        rendaPassivaPorMinuto: 0.5,
      );
    }
  }

  Map<String,dynamic> toJson (){
    return {
      'saldo':saldo,
      'rendaAtivaPorToque':rendaAtivaPorToque,
      'rendaPassivaPorMinuto':rendaPassivaPorMinuto,
    };
  }
}
