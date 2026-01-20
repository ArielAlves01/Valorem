import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoremidle/core/abstracsmodel/abs_investmentbase.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';
import 'package:valoremidle/core/models/investimentsmodels/transacoesmodels.dart';
import 'package:valoremidle/core/utils/actioncounter.dart';
import 'package:valoremidle/core/utils/convertermoeda.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';

class InvestimentoDetailView extends StatefulWidget {
  const InvestimentoDetailView({
    super.key,
    required this.ativo,
    required this.actionAdCounter,
  });

  final InvestmentBase ativo;
  final ActionAdCounter actionAdCounter;

  @override
  State<InvestimentoDetailView> createState() => _InvestimentoDetailViewState();
}

class _InvestimentoDetailViewState extends State<InvestimentoDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int _qty = 1;
  String? _msg;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _setQty(int v) {
    setState(() {
      _qty = v.clamp(1, 999999);
    });
  }

  void _setMsg(String? v) {
    setState(() => _msg = v);
  }

  InvestmentBase _resolvePosicao(CarteiraDeInvestimentos carteira) {
    // Se já existir na carteira, use a instância da carteira (estado real).
    final found = carteira.ativos.where((a) => a.id == widget.ativo.id).toList();
    if (found.isNotEmpty) return found.first;
    return widget.ativo;
  }

  @override
  Widget build(BuildContext context) {
    final carteira = context.watch<CarteiraDeInvestimentos>();
    final balanceVM = context.watch<BalanceViewModel>();
    final playerVM = context.watch<PlayerViewModel>();
    final ativo = _resolvePosicao(carteira);
    final theme = Theme.of(context);

    final bruto = ativo.precoAtual * _qty;
    final taxa = playerVM.removeAdsComprado ? 0.0 : bruto * 0.02;
    final custo = bruto + taxa;

    final brutoVenda = bruto;
    final taxaVenda = taxa;
    final valorReceber = (brutoVenda - taxaVenda).clamp(0.0, double.infinity);
    final podeComprar = balanceVM.temSaldo(custo);
    final podeVender = ativo.quantidade >= _qty;

    return Scaffold(
      appBar: AppBar(
        title: Text(ativo.nome),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Comprar'),
            Tab(text: 'Vender'),
            Tab(text: 'Detalhes'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'R\$ ${formatBRL(ativo.precoAtual)}',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Saldo: R\$ ${formatBRL(balanceVM.balance.saldo)}'),
                    const Spacer(),
                    Text('Você tem: ${ativo.quantidade.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('PM: R\$ ${formatBRL(ativo.precoMedio)}'),
                    const Spacer(),
                    Text('P/L: ${(ativo.precoAtual - ativo.precoMedio) * ativo.quantidade >= 0 ? '+' : ''}R\$ ${formatBRL(((ativo.precoAtual - ativo.precoMedio) * ativo.quantidade).toDouble())}'),
                  ],
                ),
                if (_msg != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _msg!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ]
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _buildBuy(context, carteira, balanceVM, ativo, custo, podeComprar),
                _buildSell(context, carteira, balanceVM, ativo, valorReceber, podeVender),
                _buildDetails(context, ativo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtySelector(BuildContext context, {required String hint}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              onPressed: _qty > 1 ? () => _setQty(_qty - 1) : null,
              icon: const Icon(Icons.remove),
              tooltip: 'Diminuir',
            ),
            Expanded(
              child: Column(
                children: [
                  Text('Quantidade', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text('$_qty', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(hint, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _setQty(_qty + 1),
              icon: const Icon(Icons.add),
              tooltip: 'Aumentar',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuy(
    BuildContext context,
    CarteiraDeInvestimentos carteira,
    BalanceViewModel balanceVM,
    InvestmentBase ativo,
    double custo,
    bool podeComprar,
  ) {
    final playerVM = context.read<PlayerViewModel>();
    final bruto = ativo.precoAtual * _qty;
    final taxa = playerVM.removeAdsComprado ? 0.0 : bruto * 0.02;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _qtySelector(context, hint: 'Custo: R\$ ${formatBRL(custo)}'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _rowKV(context, k: 'Preço (bruto)', v: 'R\$ ${formatBRL(bruto)}'),
                const SizedBox(height: 8),
                _rowKV(context, k: 'Taxa de corretagem (2%)', v: 'R\$ ${formatBRL(taxa)}'),
                const SizedBox(height: 10),
                _rowKV(context, k: 'Custo total', v: 'R\$ ${formatBRL(custo)}'),
                const SizedBox(height: 10),
                _rowKV(context, k: 'Saldo', v: 'R\$ ${formatBRL(balanceVM.balance.saldo)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: podeComprar
              ? () {
                  _setMsg(null);
                  final ok = balanceVM.gastarSaldo(custo);
                  if (!ok) {
                    _setMsg('Saldo insuficiente.');
                    return;
                  }

                  carteira.registrarTransacao(
                    ativo: ativo,
                    tipo: TipoTransacao.compra,
                    quantidade: _qty.toDouble(),
                    precoUnitario: ativo.precoAtual,
                    origem: 'InvestimentosView',
                  );

                  // Anúncio a cada X ações (compra/venda)
                  widget.actionAdCounter.registerAction();
                }
              : null,
          child: const Text('Comprar'),
        ),
      ],
    );
  }

  Widget _buildSell(
    BuildContext context,
    CarteiraDeInvestimentos carteira,
    BalanceViewModel balanceVM,
    InvestmentBase ativo,
    double valorReceber,
    bool podeVender,
  ) {
    final playerVM = context.read<PlayerViewModel>();
    final brutoVenda = ativo.precoAtual * _qty;
    final taxaVenda = playerVM.removeAdsComprado ? 0.0 : brutoVenda * 0.02;
    final receber = (brutoVenda - taxaVenda).clamp(0.0, double.infinity);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _qtySelector(
          context,
          hint: 'Você tem: ${ativo.quantidade.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _rowKV(context, k: 'Preço (bruto)', v: 'R\$ ${formatBRL(brutoVenda)}'),
                const SizedBox(height: 8),
                _rowKV(context, k: 'Taxa de corretagem (2%)', v: 'R\$ ${formatBRL(taxaVenda)}'),
                const SizedBox(height: 10),
                _rowKV(context, k: 'Valor a receber', v: 'R\$ ${formatBRL(receber)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: podeVender
              ? () {
                  _setMsg(null);

                  carteira.registrarTransacao(
                    ativo: ativo,
                    tipo: TipoTransacao.venda,
                    quantidade: _qty.toDouble(),
                    precoUnitario: ativo.precoAtual,
                    origem: 'InvestimentosView',
                  );

                  balanceVM.adicionarSaldo(receber);
                  widget.actionAdCounter.registerAction();
                }
              : null,
          child: const Text('Vender'),
        ),
        if (!podeVender) ...[
          const SizedBox(height: 8),
          Text(
            'Você não tem quantidade suficiente para vender.',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ]
      ],
    );
  }

  Widget _buildDetails(BuildContext context, InvestmentBase ativo) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _rowKV(context, k: 'Volatilidade', v: ativo.volatilidade.toStringAsFixed(2)),
                const SizedBox(height: 10),
                _rowKV(context, k: 'Rendimento base', v: ativo.rendimentoBase.toStringAsFixed(4)),
                const SizedBox(height: 10),
                _rowKV(context, k: 'Dividendos', v: ativo.temDividendos ? 'Sim' : 'Não'),
                const SizedBox(height: 10),
                _rowKV(context, k: 'Dividend yield', v: ativo.dividendYield.toStringAsFixed(4)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowKV(BuildContext context, {required String k, required String v}) {
    return Row(
      children: [
        Expanded(child: Text(k)),
        Text(v, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
