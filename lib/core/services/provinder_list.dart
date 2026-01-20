import 'package:provider/provider.dart';
import 'package:valoremidle/app.dart';
import 'package:valoremidle/core/models/balancemodel.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';
import 'package:valoremidle/core/services/auto_save.dart';
import 'package:valoremidle/core/services/game_loop.dart';
import 'package:valoremidle/core/theme/theme.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';
import 'package:valoremidle/features/homescreen/viewmodel/homeviewmodel.dart';

import 'package:provider/provider.dart';
import 'package:valoremidle/app.dart';
import 'package:valoremidle/core/models/balancemodel.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';
import 'package:valoremidle/core/services/game_loop.dart';
import 'package:valoremidle/core/theme/theme.dart';
import 'package:valoremidle/core/viewmodels/vm_balance.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';
import 'package:valoremidle/features/homescreen/viewmodel/homeviewmodel.dart';

MultiProvider listProviders() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),

      ChangeNotifierProvider(
        create: (_) => BalanceViewModel(
          inicial: BalanceModel(
            saldo: 0.0,
            rendaAtivaPorToque: 1.25,
            rendaPassivaPorMinuto: 5,
          ),
        ),
      ),

      ChangeNotifierProvider(create: (_) => PlayerViewModel()),

      // Autosave depende de PlayerVM e BalanceVM
      ProxyProvider2<BalanceViewModel, PlayerViewModel, AutoSaveService>(
        update: (_, balanceVM, playerVM, previous) =>
        previous ??
            AutoSaveService(
              playerVM: playerVM,
              balanceVM: balanceVM,
            ),
        dispose: (_, svc) => svc.dispose(),
      ),

      ChangeNotifierProvider(create: (_) => CarteiraDeInvestimentos()),

      ProxyProvider4<BalanceViewModel, PlayerViewModel, AutoSaveService, CarteiraDeInvestimentos,
          GameLoopService>(
        update: (_, balanceVM, playerVM, autosave, carteira, previous) =>
        previous ?? GameLoopService(balanceVM, playerVM, autosave, carteira),
        dispose: (_, svc) => svc.dispose(),
      ),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),


    ],
    child: const ValoremApp(),
  );
}
