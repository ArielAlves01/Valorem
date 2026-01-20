import 'package:valoremidle/core/models/investimentsmodels/investimentacoesmodel.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';

/// Modelo genérico para criar um catálogo grande de ações sem criar 200 arquivos.
/// (Você continua podendo criar classes específicas depois.)
class AcaoCatalogModel extends InvestimentoAcoesModel {
  AcaoCatalogModel({
    required super.id,
    required super.nome,
    required super.logoPath,
    required super.precoAtual,
    required super.setor,
    required super.rendimentoBase,
    required super.volatilidade,
    required super.temDividendos,
    required super.dividendYield,
  }) : super(
          quantidade: 0,
          precoMedio: 0,
          acumulado: 0,
        );
}
