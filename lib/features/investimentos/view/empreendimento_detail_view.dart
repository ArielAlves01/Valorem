import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoremidle/core/models/ativosmodel.dart';
import 'package:valoremidle/core/utils/actioncounter.dart';
import 'package:valoremidle/core/utils/convertermoeda.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/features/investimentos/models/empreendimento_catalog_item.dart';

class EmpreendimentoDetailView extends StatefulWidget {
  const EmpreendimentoDetailView({
    super.key,
    required this.item,
    required this.actionAdCounter,
  });

  final EmpreendimentoCatalogItem item;
  final ActionAdCounter actionAdCounter;

  @override
  State<EmpreendimentoDetailView> createState() => _EmpreendimentoDetailViewState();
}

class _EmpreendimentoDetailViewState extends State<EmpreendimentoDetailView> {
  int _qty = 1;
  String? _msg;

  void _setQty(int v) {
    setState(() {
      _qty = v.clamp(1, 999999);
    });
  }

  void _setMsg(String? v) {
    setState(() => _msg = v);
  }

  @override
  Widget build(BuildContext context) {
    final balanceVM = context.watch<BalanceViewModel>();
    final theme = Theme.of(context);
    final totalCost = widget.item.custo * _qty;
    final owned = balanceVM.ativos.where((a) => a.nome == widget.item.nome).length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.item.nome)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  child: Icon(widget.item.icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.tipo, style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Renda/min: R\$ ${formatBRL(widget.item.rendaPorMinuto)}',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('Você possui: $owned', style: theme.textTheme.labelMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _qty > 1 ? () => _setQty(_qty - 1) : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Quantidade', style: theme.textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Text('$_qty', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text('Custo: R\$ ${formatBRL(totalCost)}', style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _setQty(_qty + 1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _rowKV('Saldo', 'R\$ ${formatBRL(balanceVM.balance.saldo)}', theme),
                  const SizedBox(height: 10),
                  _rowKV('Custo total', 'R\$ ${formatBRL(totalCost)}', theme),
                ],
              ),
            ),
          ),
          if (_msg != null) ...[
            const SizedBox(height: 10),
            Text(_msg!, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: balanceVM.temSaldo(totalCost)
                ? () {
                    _setMsg(null);
                    final ok = balanceVM.gastarSaldo(totalCost);
                    if (!ok) {
                      _setMsg('Saldo insuficiente.');
                      return;
                    }

                    // Converte renda/min para renda/seg
                    final rendaPorSegundo = widget.item.rendaPorMinuto / 60.0;
                    for (var i = 0; i < _qty; i++) {
                      balanceVM.adicionarAtivo(
                        Ativo(
                          nome: widget.item.nome,
                          rendaPorSegundo: rendaPorSegundo,
                          custo: widget.item.custo,
                        ),
                      );
                    }

                    widget.actionAdCounter.registerAction();
                  }
                : null,
            child: const Text('Comprar empreendimento'),
          ),
        ],
      ),
    );
  }

  Widget _rowKV(String k, String v, ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Text(k)),
        Text(v, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
