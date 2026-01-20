import 'package:valoremidle/core/models/investimentsmodels/investimentacoesmodel.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

class AutoSteelCorp extends InvestimentoAcoesModel {
  AutoSteelCorp()
      : super(
    id: '1',
    nome: 'AutoSteel Corp',
    logoPath: 'assets/logos/autosteelcorp.png',
    precoAtual: 31.20,
    quantidade: 2,
    precoMedio: 33.20,
    rendimentoBase: 0.07,
    volatilidade: 0.3,
    temDividendos: false,
    dividendYield: 0.0,
    acumulado: 0,
    setor: Setor.automotivo
  );
}





