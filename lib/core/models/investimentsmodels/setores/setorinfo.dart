enum Setor {
  tecnologia,
  automotivo,
  bancario,
  energia,
  varejo,
  alimentos,
  industrial,
  telecom,
  saude,
  transporte,
  crypto,
  rendaFixa,
}

class SetorInfo {
  final String nome;
  final String descricao;
  final String icon;

  const SetorInfo({
    required this.nome,
    required this.descricao,
    required this.icon,
  });
}


const Map<Setor, SetorInfo> setoresInfo = {
  Setor.tecnologia: SetorInfo(
    nome: "Tecnologia",
    descricao: "Empresas de software, hardware e inovação.",
    icon: "assets/icons/setores/tech.png",
  ),
  Setor.automotivo: SetorInfo(
    nome: "Automotivo",
    descricao: "Montadoras e fabricantes de veículos.",
    icon: "assets/icons/setores/auto.png",
  ),
  Setor.bancario: SetorInfo(
    nome: "Bancos",
    descricao: "Instituições financeiras e crédito.",
    icon: "assets/icons/setores/bancos.png",
  ),
  Setor.crypto: SetorInfo(
    nome: "Cripto",
    descricao: "Criptoativos e redes descentralizadas.",
    icon: "assets/icons/setores/crypto.png",
  ),
  Setor.rendaFixa: SetorInfo(
    nome: "Renda Fixa",
    descricao: "Títulos e ativos de baixa volatilidade.",
    icon: "assets/icons/setores/rendafixa.png",
  ),
  // ... continue adicionando
};
