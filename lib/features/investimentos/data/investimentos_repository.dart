import 'package:valoremidle/core/abstracsmodel/abs_investmentbase.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';
import 'package:valoremidle/core/models/investimentsmodels/setores/setorinfo.dart';
import 'package:valoremidle/features/investimentos/models/empreendimento_catalog_item.dart';
import 'package:flutter/material.dart';

abstract class InvestimentosRepository {
  Future<List<InvestmentBase>> listarAcoes();
  Future<List<InvestmentBase>> listarCriptoativos();
  Future<List<EmpreendimentoCatalogItem>> listarEmpreendimentos();
}

class InvestimentosRepositoryLocal implements InvestimentosRepository {
  InvestimentosRepositoryLocal({this.carteira});
  final CarteiraDeInvestimentos? carteira;

  @override
  Future<List<InvestmentBase>> listarAcoes() async {
    // Preferência: usa o catálogo vivo da carteira (preço muda, posição fica na mesma instância).
    final cat = carteira?.ativos;
    if (cat != null) {
      return cat.where((a) => a.setor != Setor.crypto && a.setor != Setor.rendaFixa).toList();
    }
    // Fallback: lista vazia (evita criar instâncias desconectadas)
    return [];
  }

  @override
  Future<List<InvestmentBase>> listarCriptoativos() async {
    final cat = carteira?.ativos;
    if (cat != null) {
      return cat.where((a) => a.setor == Setor.crypto).toList();
    }
    return [];
  }

  @override
  Future<List<EmpreendimentoCatalogItem>> listarEmpreendimentos() async {
    return const [
      EmpreendimentoCatalogItem(
        id: 'emp_01',
        nome: 'Lanchonete',
        tipo: 'Alimentos',
        custo: 250,
        rendaPorMinuto: 6,
        icon: Icons.fastfood,
      ),
      EmpreendimentoCatalogItem(
        id: 'emp_02',
        nome: 'Oficina',
        tipo: 'Serviços',
        custo: 480,
        rendaPorMinuto: 10,
        icon: Icons.car_repair,
      ),
      EmpreendimentoCatalogItem(
        id: 'emp_03',
        nome: 'Loja Online',
        tipo: 'E-commerce',
        custo: 620,
        rendaPorMinuto: 14,
        icon: Icons.shopping_bag,
      ),
      EmpreendimentoCatalogItem(
        id: 'emp_04',
        nome: 'Agência',
        tipo: 'Marketing',
        custo: 900,
        rendaPorMinuto: 20,
        icon: Icons.campaign,
      ),
      EmpreendimentoCatalogItem(
        id: 'emp_05',
        nome: 'Barbearia',
        tipo: 'Serviços',
        custo: 1350,
        rendaPorMinuto: 30,
        icon: Icons.cut,
      ),
      EmpreendimentoCatalogItem(
        id: 'emp_06',
        nome: 'Mini Mercado',
        tipo: 'Varejo',
        custo: 2400,
        rendaPorMinuto: 55,
        icon: Icons.store,
      ),
    ];
  }
}
