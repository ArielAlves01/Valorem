import 'package:valoremidle/core/models/investimentsmodels/investimentcriptomodel.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

class SolanaModel extends InvestimentoCriptoModel {
  SolanaModel()
      : super(
          id: 'sol',
          nome: 'Solana',
          logoPath: 'assets/logos/sol.png',
          precoAtual: 600,
          quantidade: 0,
          precoMedio: 0,
          rendimentoBase: 0.0010,
          volatilidade: 0.12,
          temDividendos: true,
          dividendYield: 0.06,
          acumulado: 0,
          setor: Setor.tecnologia,
        );
}
