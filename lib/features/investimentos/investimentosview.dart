import 'package:flutter/material.dart';
import 'package:valoremidle/core/utils/actioncounter.dart';
import 'package:valoremidle/core/utils/convertermoeda.dart';
import 'package:valoremidle/core/services/adservice.dart';
import 'package:valoremidle/features/investimentos/data/investimentos_repository.dart';
import 'package:valoremidle/features/investimentos/models/empreendimento_catalog_item.dart';
import 'package:valoremidle/features/investimentos/view/empreendimento_detail_view.dart';
import 'package:valoremidle/features/investimentos/view/investimento_detail_view.dart';
import 'package:valoremidle/features/investimentos/viewmodels/investimentos_list_vm.dart';

class InvestimentosView extends StatefulWidget {
  const InvestimentosView({super.key});

  @override
  State<InvestimentosView> createState() => _InvestimentosViewState();
}

class _InvestimentosViewState extends State<InvestimentosView>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  final InvestimentosRepository _repo = InvestimentosRepositoryLocal();
  late final AcoesListVM _acoesVM;
  late final EmpreendimentosListVM _empreVM;
  late final CriptoListVM _criptoVM;

  // Conta ações de compra/venda e dispara Interstitial (ex: a cada 5)
  final ActionAdCounter _actionAdCounter = ActionAdCounter(every: 5);

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);

    // Pré-carrega interstitial para não perder o primeiro gatilho.
    AdService.I.loadInterstitial();

    _acoesVM = AcoesListVM(_repo)..load();
    _empreVM = EmpreendimentosListVM(_repo)..load();
    _criptoVM = CriptoListVM(_repo)..load();
  }

  @override
  void dispose() {
    _tab.dispose();
    _acoesVM.dispose();
    _empreVM.dispose();
    _criptoVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Investimentos'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Acoes'),
            Tab(text: 'Empreendimentos'),
            Tab(text: 'Criptoativos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _AcoesTab(vm: _acoesVM, actionAdCounter: _actionAdCounter),
          _EmpreendimentosTab(vm: _empreVM, actionAdCounter: _actionAdCounter),
          _CriptoTab(vm: _criptoVM, actionAdCounter: _actionAdCounter),
        ],
      ),
    );
  }
}

class _AcoesTab extends StatelessWidget {
  const _AcoesTab({required this.vm, required this.actionAdCounter});

  final AcoesListVM vm;
  final ActionAdCounter actionAdCounter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(child: Text(vm.error!));
        }
        if (vm.itens.isEmpty) {
          return const Center(child: Text('Sem acoes disponiveis.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.itens.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final a = vm.itens[index];
            return _InvestmentCard(
              title: a.nome,
              subtitle: 'Ação',
              trailingTop: 'R\$ ${formatBRL(a.precoAtual)}',
              trailingBottom: 'Renda/min: ${a.rendimentoBase.toStringAsFixed(3)}',
              icon: Icons.trending_up,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InvestimentoDetailView(
                      ativo: a,
                      actionAdCounter: actionAdCounter,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CriptoTab extends StatelessWidget {
  const _CriptoTab({required this.vm, required this.actionAdCounter});

  final CriptoListVM vm;
  final ActionAdCounter actionAdCounter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(child: Text(vm.error!));
        }
        if (vm.itens.isEmpty) {
          return const Center(child: Text('Sem criptoativos disponiveis.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.itens.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final c = vm.itens[index];
            return _InvestmentCard(
              title: c.nome,
              subtitle: 'Criptoativo',
              trailingTop: 'R\$ ${formatBRL(c.precoAtual)}',
              trailingBottom: c.temDividendos
                  ? 'Staking: ${c.dividendYield.toStringAsFixed(3)}'
                  : 'Sem rendimento',
              icon: Icons.currency_bitcoin,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InvestimentoDetailView(
                      ativo: c,
                      actionAdCounter: actionAdCounter,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _EmpreendimentosTab extends StatelessWidget {
  const _EmpreendimentosTab({required this.vm, required this.actionAdCounter});

  final EmpreendimentosListVM vm;
  final ActionAdCounter actionAdCounter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(child: Text(vm.error!));
        }
        if (vm.itens.isEmpty) {
          return const Center(child: Text('Sem empreendimentos disponiveis.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.itens.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final e = vm.itens[index];
            return _EmpreendimentoCard(
              item: e,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EmpreendimentoDetailView(
                      item: e,
                      actionAdCounter: actionAdCounter,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({
    required this.title,
    required this.subtitle,
    required this.trailingTop,
    required this.trailingBottom,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String trailingTop;
  final String trailingBottom;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surface,
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(trailingTop, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(trailingBottom, style: theme.textTheme.labelMedium),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _EmpreendimentoCard extends StatelessWidget {
  const _EmpreendimentoCard({required this.item, required this.onTap});

  final EmpreendimentoCatalogItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surface,
          child: Icon(item.icon, color: theme.colorScheme.primary),
        ),
        title: Text(item.nome, style: theme.textTheme.titleMedium),
        subtitle: Text(item.tipo),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('R\$ ${formatBRL(item.custo)}', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Renda/min: ${formatBRL(item.rendaPorMinuto)}', style: theme.textTheme.labelMedium),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
