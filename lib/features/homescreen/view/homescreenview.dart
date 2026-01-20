import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';
import 'package:valoremidle/core/services/adservice.dart';
import 'package:valoremidle/core/services/game_loop.dart';
import 'package:valoremidle/features/homescreen/viewmodel/homeviewmodel.dart';
import 'package:valoremidle/features/homescreen/utils/Bussinesstab.dart';
import 'package:valoremidle/features/homescreen/widgets/balancecard.dart';
import 'package:valoremidle/features/homescreen/widgets/boostbottom.dart';
import 'package:valoremidle/features/homescreen/widgets/kpicard.dart';
import 'package:valoremidle/features/homescreen/widgets/mainactionbutton.dart';
import 'package:valoremidle/features/homescreen/widgets/profileheader.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _money(double v) => v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final homeVM = context.read<HomeViewModel>();
    final balanceVM = context.watch<BalanceViewModel>();
    final playerVM = context.read<PlayerViewModel>();
    final loop = context.read<GameLoopService>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: BoostButtonWidget(
        onPressed: () {
          // Rewarded: 2x clique por 1 minuto (stack)
          // RemoveAds NÃO remove rewarded.
          if (!AdService.I.isInitialized) {
            AdService.I.init();
          }
          AdService.I.loadRewarded();
          final showed = AdService.I.showRewardedIfReady(
            onEarned: (_) {
              playerVM.registrarAnuncioAssistido();
              loop.addBoost1Min();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Boost 2x ativado (+1 min).')),
              );
            },
            onClosed: () {},
          );

          if (!showed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Carregando vídeo... tenta de novo em alguns segundos.')),
            );
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeaderWidget(),

              const SizedBox(height: 30),

              /// ✔ Saldo vindo do BalanceViewModel
              BalanceCardWidget(),

              const SizedBox(height: 25),

              if (balanceVM.temOfflinePendente) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Renda offline', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'Você ficou ${balanceVM.offlinePendenteMinutos} min fora.\n'
                          'Disponível: R\$ ${_money(balanceVM.offlinePendenteValor)}',
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () {
                            if (!AdService.I.isInitialized) {
                              AdService.I.init();
                            }
                            AdService.I.loadRewarded();
                            final showed = AdService.I.showRewardedIfReady(
                              onEarned: (_) {
                                final v = balanceVM.resgatarOfflinePendente();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Renda offline resgatada: R\$ ${_money(v)}')),
                                );
                              },
                            );
                            if (!showed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Carregando vídeo... tenta de novo já já.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.play_circle),
                          label: const Text('Assistir e resgatar'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              /// ✔ Renda ativa e passiva do BalanceViewModel
              _buildKpiRow(balanceVM),

              const SizedBox(height: 40),

              /// ✔ Botão principal aciona o homeVM que usa balanceVM
              MainActionButtonWidget(
                onPressed: () => homeVM.gerarRendaAtiva(balanceVM, multiplier: balanceVM.clickMultiplier),
              ),

              const SizedBox(height: 30),

              const BusinessTabsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiRow(BalanceViewModel balanceVM) {
    final b = balanceVM.balance;

    return Row(
      children: [
        Expanded(
          child: KpiCardWidget(
            title: "💰 Renda Ativa",
            value: "R\$ ${b.rendaAtivaPorToque}/toque",
            icon: Icons.touch_app,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: KpiCardWidget(
            title: "📈 Renda Passiva",
            value: "R\$ ${b.rendaPassivaPorMinuto}/min",
            icon: Icons.trending_up,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
