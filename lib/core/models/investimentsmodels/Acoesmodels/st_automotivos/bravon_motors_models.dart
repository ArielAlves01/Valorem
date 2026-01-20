import 'package:valoremidle/core/models/investimentsmodels/investimentacoesmodel.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

class BravonMotors extends InvestimentoAcoesModel {
  BravonMotors()
      : super(
    id: '0',
    nome: 'Bravon Motors',
    logoPath: 'assets/logos/bravon.png',
    precoAtual: 42.50,
    quantidade: 5,
    precoMedio: 54.44,
    rendimentoBase: 0.08,
    volatilidade: 0.03,
    temDividendos: true,
    dividendYield:0.021,
    acumulado: 0,
    setor: Setor.automotivo
  );

  @override
  String toString() {
    return 'BravonMotors('
        'id: $id, '
        'nome: $nome, '
        'precoAtual: $precoAtual, '
        'quantidade: $quantidade, '
        'precoMedio: $precoMedio, '
        'rendimentoBase: $rendimentoBase, '
        'volatilidade: $volatilidade, '
        'temDividendos: $temDividendos, '
        'dividendYield: $dividendYield, '
        'acumulado: $acumulado'
        ')';
  }

}
