class PlayerModel {
  String nome;
  String? instagram;
  String? fotoPath;
  int nivel;
  double ganhoPorCliqueBonus;
  int experienciaAtual;
  int experienciaNecessaria;
  int missoesCompletas;
  int anunciosAssistidos;
  bool removeAdsComprado;

  PlayerModel({
    required this.nome,
    this.instagram,
    this.fotoPath,
    required this.ganhoPorCliqueBonus,
    required this.experienciaAtual,
    required this.experienciaNecessaria,
    required this.missoesCompletas,
    required this.anunciosAssistidos,
    this.removeAdsComprado = false,
    required this.nivel
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      nome: json['nome'],
      instagram: json['instagram'],
      fotoPath: json['fotoPath'],
      // compat: já vi projeto salvar como ganhoPorClick (typo) e como ganhoPorCliqueBonus
      ganhoPorCliqueBonus: ((json['ganhoPorCliqueBonus'] ?? json['ganhoPorClick'] ?? 1) as num).toDouble(),
      experienciaAtual: json['experienciaAtual'] ?? 0,
      experienciaNecessaria: json['experienciaNecessaria'] ?? 100,
      missoesCompletas: json['missoesCompletas'] ?? 0,
      anunciosAssistidos: json['anunciosAssistidos'] ?? 0,
      removeAdsComprado: json['removeAdsComprado'] ?? false,
      nivel: json['nivel'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'instagram': instagram,
      'fotoPath': fotoPath,
      // salva nos dois formatos por compatibilidade
      'ganhoPorCliqueBonus': ganhoPorCliqueBonus,
      'ganhoPorClick': ganhoPorCliqueBonus,
      'experienciaAtual': experienciaAtual,
      'experienciaNecessaria': experienciaNecessaria,
      'missoesCompletas': missoesCompletas,
      'anunciosAssistidos': anunciosAssistidos,
      'removeAdsComprado': removeAdsComprado,
      'nivel':nivel
    };
  }
}
