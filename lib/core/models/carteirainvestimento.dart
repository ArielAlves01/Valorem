import 'package:flutter/cupertino.dart';
import 'package:valoremidle/core/abstracsmodel/abs_investmentbase.dart';
import 'package:valoremidle/core/models/investimentsmodels/Acoesmodels/st_automotivos/autosteelcorp.dart';
import 'package:valoremidle/core/models/investimentsmodels/Acoesmodels/st_automotivos/bravon_motors_models.dart';
import 'package:valoremidle/core/models/investimentsmodels/Acoesmodels/acao_catalog_model.dart';
import 'package:valoremidle/core/models/investimentsmodels/Criptomodels/bitcoin_model.dart';
import 'package:valoremidle/core/models/investimentsmodels/Criptomodels/ethereum_model.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';
import 'package:valoremidle/core/models/investimentsmodels/transacoesmodels.dart';

class CarteiraDeInvestimentos extends ChangeNotifier {
  // Catálogo + posição (a mesma instância guarda quantidade, PM, acumulado e preço atual)
  List<InvestmentBase> ativos = _buildCatalog();
  List<TransacaoModel> historico = [];

  int _marketCounterMin = 0;
  int _divCounterMin = 0;

  static List<InvestmentBase> _buildCatalog() {
    // 20 ações
    final acoes = <InvestmentBase>[
      AutoSteelCorp(),
      BravonMotors(),
      AcaoCatalogModel(
        id: 'TEC_01',
        nome: 'Nimbus Soft',
        logoPath: '',
        precoAtual: 38.50,
        setor: Setor.tecnologia,
        rendimentoBase: 0.0,
        volatilidade: 0.022,
        temDividendos: false,
        dividendYield: 0.0,
      ),
      AcaoCatalogModel(
        id: 'TEC_02',
        nome: 'Aurora Chips',
        logoPath: '',
        precoAtual: 62.10,
        setor: Setor.tecnologia,
        rendimentoBase: 0.0,
        volatilidade: 0.028,
        temDividendos: false,
        dividendYield: 0.0,
      ),
      AcaoCatalogModel(
        id: 'BAN_01',
        nome: 'Banco Horizonte',
        logoPath: '',
        precoAtual: 27.40,
        setor: Setor.bancario,
        rendimentoBase: 0.0,
        volatilidade: 0.012,
        temDividendos: true,
        dividendYield: 0.072,
      ),
      AcaoCatalogModel(
        id: 'BAN_02',
        nome: 'CrediNova',
        logoPath: '',
        precoAtual: 19.80,
        setor: Setor.bancario,
        rendimentoBase: 0.0,
        volatilidade: 0.014,
        temDividendos: true,
        dividendYield: 0.058,
      ),
      AcaoCatalogModel(
        id: 'ENE_01',
        nome: 'EletroSol',
        logoPath: '',
        precoAtual: 41.20,
        setor: Setor.energia,
        rendimentoBase: 0.0,
        volatilidade: 0.010,
        temDividendos: true,
        dividendYield: 0.092,
      ),
      AcaoCatalogModel(
        id: 'ENE_02',
        nome: 'VentoSul',
        logoPath: '',
        precoAtual: 23.90,
        setor: Setor.energia,
        rendimentoBase: 0.0,
        volatilidade: 0.013,
        temDividendos: true,
        dividendYield: 0.081,
      ),
      AcaoCatalogModel(
        id: 'VAR_01',
        nome: 'Varejo Max',
        logoPath: '',
        precoAtual: 11.60,
        setor: Setor.varejo,
        rendimentoBase: 0.0,
        volatilidade: 0.030,
        temDividendos: false,
        dividendYield: 0.0,
      ),
      AcaoCatalogModel(
        id: 'VAR_02',
        nome: 'LojaPulse',
        logoPath: '',
        precoAtual: 16.35,
        setor: Setor.varejo,
        rendimentoBase: 0.0,
        volatilidade: 0.026,
        temDividendos: false,
        dividendYield: 0.0,
      ),
      AcaoCatalogModel(
        id: 'ALI_01',
        nome: 'Alimenta BR',
        logoPath: '',
        precoAtual: 29.70,
        setor: Setor.alimentos,
        rendimentoBase: 0.0,
        volatilidade: 0.009,
        temDividendos: true,
        dividendYield: 0.054,
      ),
      AcaoCatalogModel(
        id: 'ALI_02',
        nome: 'Sabor Mix',
        logoPath: '',
        precoAtual: 18.05,
        setor: Setor.alimentos,
        rendimentoBase: 0.0,
        volatilidade: 0.011,
        temDividendos: true,
        dividendYield: 0.061,
      ),
      AcaoCatalogModel(
        id: 'SAU_01',
        nome: 'Clinica Vida',
        logoPath: '',
        precoAtual: 47.90,
        setor: Setor.saude,
        rendimentoBase: 0.0,
        volatilidade: 0.017,
        temDividendos: false,
        dividendYield: 0.0,
      ),
      AcaoCatalogModel(
        id: 'SAU_02',
        nome: 'Farmatec',
        logoPath: '',
        precoAtual: 33.25,
        setor: Setor.saude,
        rendimentoBase: 0.0,
        volatilidade: 0.015,
        temDividendos: true,
        dividendYield: 0.043,
      ),
      AcaoCatalogModel(
        id: 'IND_01',
        nome: 'MetalFort',
        logoPath: '',
        precoAtual: 21.40,
        setor: Setor.industrial,
        rendimentoBase: 0.0,
        volatilidade: 0.018,
        temDividendos: true,
        dividendYield: 0.067,
      ),
      AcaoCatalogModel(
        id: 'IND_02',
        nome: 'Construtiva',
        logoPath: '',
        precoAtual: 14.80,
        setor: Setor.industrial,
        rendimentoBase: 0.0,
        volatilidade: 0.021,
        temDividendos: true,
        dividendYield: 0.052,
      ),
      AcaoCatalogModel(
        id: 'TEL_01',
        nome: 'TeleZ',
        logoPath: '',
        precoAtual: 9.85,
        setor: Setor.telecom,
        rendimentoBase: 0.0,
        volatilidade: 0.012,
        temDividendos: true,
        dividendYield: 0.088,
      ),
      AcaoCatalogModel(
        id: 'TEL_02',
        nome: 'RedePlus',
        logoPath: '',
        precoAtual: 12.30,
        setor: Setor.telecom,
        rendimentoBase: 0.0,
        volatilidade: 0.013,
        temDividendos: true,
        dividendYield: 0.074,
      ),
      AcaoCatalogModel(
        id: 'TRA_01',
        nome: 'LogiTrack',
        logoPath: '',
        precoAtual: 17.60,
        setor: Setor.transporte,
        rendimentoBase: 0.0,
        volatilidade: 0.020,
        temDividendos: false,
        dividendYield: 0.0,
      ),
      AcaoCatalogModel(
        id: 'TRA_02',
        nome: 'AeroNorte',
        logoPath: '',
        precoAtual: 25.15,
        setor: Setor.transporte,
        rendimentoBase: 0.0,
        volatilidade: 0.019,
        temDividendos: false,
        dividendYield: 0.0,
      ),
    ];

    // 2 cripto
    final cripto = <InvestmentBase>[
      BitcoinModel(),
      EthereumModel(),
    ];

    return [...acoes, ...cripto];
  }

  bool validarCarteira() => ativos.isEmpty;

  /// Processa minutos do jogo para:
  /// - Mercado: 1h
  /// - Dividendos: 3min
  /// Retorna o total em R$ (dividendos) que deve ser creditado no saldo.
  double processarMinutos({required int minutes}) {
    if (minutes <= 0) return 0.0;

    _marketCounterMin += minutes;
    _divCounterMin += minutes;

    // Mercado (a cada 60 min)
    if (_marketCounterMin >= 60) {
      final blocos = _marketCounterMin ~/ 60;
      _marketCounterMin = _marketCounterMin % 60;
      for (var i = 0; i < blocos; i++) {
        for (final a in ativos) {
          a.aplicarVariacaoMercado();
        }
      }
    }

    // Dividendos (a cada 3 min)
    double payout = 0.0;
    if (_divCounterMin >= 3) {
      final blocos = _divCounterMin ~/ 3;
      _divCounterMin = _divCounterMin % 3;

      for (var i = 0; i < blocos; i++) {
        for (final a in ativos) {
          if (!a.temDividendos) continue;
          if (a.quantidade <= 0) continue;
          a.pagarDividendos();
          payout += a.coletarRendimentos();
        }
      }
    }

    if (payout > 0) notifyListeners();
    return payout;
  }

  void adicionar(InvestmentBase ativo) {
    final jaExiste = ativos.any((a) => a.id == ativo.id);
    if (jaExiste) {
      print('Ativo já existe na carteira: ${ativo.nome}');
      return;
    }

    ativos.add(ativo);
    print('${ativo.nome} Adicionado à Carteira');
    notifyListeners();
  }

  void remover(InvestmentBase ativo) {
    if (!ativos.contains(ativo)) {
      print('Você não possui esse ativo');
      return;
    }
    ativos.remove(ativo);
    print('${ativo.nome} removido da carteira');
    notifyListeners();
  }

  void registrarTransacao({
    required InvestmentBase ativo,
    required TipoTransacao tipo,
    required double quantidade,
    required double precoUnitario,
    String? origem,
    String? observacao,
  }) {
    if (quantidade <= 0) {
      print('Quantidade inválida');
      return;
    }
    if (precoUnitario <= 0) {
      print('Preço unitário inválido');
      return;
    }


    if (!ativos.any((a) => a.id == ativo.id)) {
      ativos.add(ativo);
    }


    final double precoMedioAntes = ativo.precoMedio;
    final double quantidadeAntes = ativo.quantidade;


    final double precoAtualAntes = ativo.precoAtual;
    ativo.precoAtual = precoUnitario;


    if (tipo == TipoTransacao.compra) {
      ativo.comprar(quantidade);
    } else if (tipo == TipoTransacao.venda) {

      if (quantidade > quantidadeAntes) {
        print('Venda inválida: você tem $quantidadeAntes e tentou vender $quantidade');

        ativo.precoAtual = precoAtualAntes;
        return;
      }
      ativo.vender(quantidade);
    }

    // Restaura precoAtual (opcional, mas evita efeitos colaterais no tick/mercado)
    ativo.precoAtual = precoAtualAntes;

    // Registra histórico com antes/depois reais
    historico.add(
      TransacaoModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nomeAtivo: ativo.nome,
        tipo: tipo,
        quantidade: quantidade,
        precoUnitario: precoUnitario,
        precoTotal: quantidade * precoUnitario,
        dataHora: DateTime.now(),
        precoMedioAntes: precoMedioAntes,
        precoMedioDepois: ativo.precoMedio,
        quantidadeAntes: quantidadeAntes,
        quantidadeDepois: ativo.quantidade,
        origem: origem,
        observacao: observacao,
      ),
    );

    notifyListeners();
  }

  // ------------------------------------
  // Listar carteira
  // ------------------------------------
  void listarCarteira() {
    if (validarCarteira()) {
      print('Sua carteira está vazia');
      return;
    }

    for (var investimento in ativos) {
      print(
        '${investimento.nome} - Qtde: ${investimento.quantidade} '
            '- Preço Atual: ${investimento.precoAtual.toStringAsFixed(2)} '
            '- Preço Médio: ${investimento.precoMedio.toStringAsFixed(2)}',
      );
    }
  }

  // ------------------------------------
  // Total investido baseado no preço MÉDIO
  // ------------------------------------
  double calcularTotalInvestidos() {
    if (validarCarteira()) return 0;

    return ativos.fold(
      0,
          (total, ativo) => total + (ativo.precoMedio * ativo.quantidade),
    );
  }

  // ------------------------------------
  // Valor atual da carteira
  // ------------------------------------
  double calcularValorAtual() {
    if (validarCarteira()) return 0;

    return ativos.fold(
      0,
          (total, ativo) => total + (ativo.precoAtual * ativo.quantidade),
    );
  }

  // ------------------------------------
  // Lucro/prejuízo total da carteira
  // ------------------------------------
  double calcularLucroTotal() {
    return calcularValorAtual() - calcularTotalInvestidos();
  }
  double calcularVariacaoTotalPercentual() {
    final totalInvestido = calcularTotalInvestidos();
    if (totalInvestido <= 0) return 0;

    final valorAtual = calcularValorAtual();
    return (valorAtual - totalInvestido) / totalInvestido;
  }

  // ------------------------------------
  // Buscar ativo pelo nome
  // ------------------------------------
  InvestmentBase? buscarAtivo(String nome) {
    try {
      return ativos.firstWhere((a) => a.nome == nome);
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------
  // Listar histórico de transações
  // ------------------------------------
  void listarHistorico() {
    if (historico.isEmpty) {
      print('Nenhuma transação registrada ainda.');
      return;
    }

    for (var t in historico) {
      print(
        '[${t.tipo}] ${t.nomeAtivo} | Qtde: ${t.quantidade} | '
            'Preço: ${t.precoUnitario} | Total: ${t.precoTotal} | ${t.dataHora}',
      );
    }
  }

  // ------------------------------------
  // Limpar tudo
  // ------------------------------------
  void resetarCarteira() {
    ativos.clear();
    historico.clear();
    print('Carteira resetada!');
    notifyListeners();
  }
}
