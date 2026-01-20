import 'package:valoremidle/core/models/investimentsmodels/investimentcriptomodel.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

class EthereumModel extends InvestimentoCriptoModel {
  EthereumModel()
      : super(
          id: 'eth',
          nome: 'Ethereum',
          logoPath: 'assets/logos/eth.png',
          precoAtual: 18000,
          quantidade: 0,
          precoMedio: 0,
          rendimentoBase: 0.0008,
          volatilidade: 0.10,
          temDividendos: true,
          dividendYield: 0.04,
          acumulado: 0,
          setor: Setor.crypto,
        );
}
