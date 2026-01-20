import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valoremidle/core/services/game_loop.dart';
import 'package:valoremidle/core/theme/theme.dart';
import 'package:valoremidle/features/homescreen/view/homescreenview.dart';
import 'package:valoremidle/core/utils/bottombanner.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';
import 'package:valoremidle/core/services/adservice.dart';
  
import 'features/central/centralview.dart';
import 'features/investimentos/investimentosview.dart';

class ValoremApp extends StatelessWidget {
  const ValoremApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Valorem Idle',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home: const RootScaffold(),
        );
      },
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;
  bool _started = false;

  final List<Widget> _tabs = const [
    HomeScreen(),
    CentralView(),
    InvestimentosView(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inicia o loop uma vez, depois que Providers já existem.
    if (_started) return;
    _started = true;

    // Sync ads flag (mock compra remove ads)
    final playerVM = context.read<PlayerViewModel>();
    AdService.I.setAdsEnabled(!playerVM.removeAdsComprado);

    context.read<GameLoopService>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_rounded),
                  label: 'Carteira',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inbox_rounded),
                  label: 'Central',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up_rounded),
                  label: 'Investir',
                ),
              ],
            ),
            const BottomBanner(),
          ],
        ),
      ),
    );
  }
}
