// features/homescreen/widgets/investments_tab_content.dart
import 'package:flutter/material.dart';
import 'package:valoremidle/core/abstracsmodel/abs_investmentbase.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';
import 'package:valoremidle/core/utils/convertermoeda.dart';
import 'package:valoremidle/features/homescreen/widgets/investingitem.dart';
import 'package:provider/provider.dart';
class InvestmentsTabContent extends StatelessWidget {
  const InvestmentsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final carteiraVm = context.watch<CarteiraDeInvestimentos>();
    return ListView(
      children:  [

        InvestmentItemWidget(
            name: "Ações",
            value: "R\$ ${formatBRL(carteiraVm.calcularTotalInvestidos())}",
            percent: carteiraVm.calcularVariacaoTotalPercentual(),
            color: Colors.greenAccent,
          ),
        InvestmentItemWidget(
          name: "Fundos Imobiliários",
          value: "R\$ 1.800,00",
          percent: 2.1,
          color: Colors.blueAccent,
        ),
        InvestmentItemWidget(
          name: "Criptomoedas",
          value: "R\$ 890,00",
          percent: 2.5,
          color: Colors.redAccent,
        ),
        InvestmentItemWidget(
          name: "Tesouro Direto",
          value: "R\$ 3.200,00",
          percent: 7.7,
          color: Colors.amber,
        ),
        InvestmentItemWidget(
          name: "ETF Internacional",
          value: "R\$ 1.550,00",
          percent: 23.3,
          color: Colors.purpleAccent,
        ),
      ],
    );
  }
}