import 'package:flutter/foundation.dart';
import 'package:valoremidle/core/abstracsmodel/abs_investmentbase.dart';
import 'package:valoremidle/features/investimentos/data/investimentos_repository.dart';
import 'package:valoremidle/features/investimentos/models/empreendimento_catalog_item.dart';

abstract class _BaseVM extends ChangeNotifier {
  bool loading = false;
  String? error;

  @protected
  Future<void> run(Future<void> Function() work) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await work();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

class AcoesListVM extends _BaseVM {
  AcoesListVM(this.repo);
  final InvestimentosRepository repo;

  List<InvestmentBase> itens = [];

  Future<void> load() => run(() async {
        itens = await repo.listarAcoes();
      });
}

class CriptoListVM extends _BaseVM {
  CriptoListVM(this.repo);
  final InvestimentosRepository repo;

  List<InvestmentBase> itens = [];

  Future<void> load() => run(() async {
        itens = await repo.listarCriptoativos();
      });
}

class EmpreendimentosListVM extends _BaseVM {
  EmpreendimentosListVM(this.repo);
  final InvestimentosRepository repo;

  List<EmpreendimentoCatalogItem> itens = [];

  Future<void> load() => run(() async {
        itens = await repo.listarEmpreendimentos();
      });
}
