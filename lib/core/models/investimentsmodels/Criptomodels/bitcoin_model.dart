import 'package:valoremidle/core/models/investimentsmodels/investimentcriptomodel.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

class BitcoinModel extends InvestimentoCriptoModel {
  BitcoinModel()
      : super(
          id: 'btc',
          nome: 'Bitcoin',
          logoPath: 'assets/logos/btc.png',
          precoAtual: 350000,
          quantidade: 0,
          precoMedio: 0,
          rendimentoBase: 0.0006,
          volatilidade: 0.08,
          temDividendos: false,
          dividendYield: 0.0,
          acumulado: 0,
          setor: Setor.crypto,
        );
}
