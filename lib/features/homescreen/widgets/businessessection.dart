// features/homescreen/widgets/businesses_tab_content.dart
import 'package:flutter/material.dart';
import 'package:valoremidle/features/homescreen/widgets/businessitem.dart';

class BusinessesTabContent extends StatelessWidget {
  const BusinessesTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessItemWidget(
          name: "Posto de Gasolina",
          type: "Combustível",
          profit: "R\$ 2.800/mês",
          level: "Nível 3",
          progress: 0.75,
          icon: Icons.local_gas_station,
          color: Colors.orange,
        ),
        BusinessItemWidget(
          name: "Supermercado",
          type: "Varejo",
          profit: "R\$ 5.200/mês",
          level: "Nível 5",
          progress: 0.9,
          icon: Icons.shopping_cart,
          color: Colors.green,
        ),
        BusinessItemWidget(
          name: "Agência Marketing",
          type: "Serviços",
          profit: "R\$ 3.500/mês",
          level: "Nível 2",
          progress: 0.4,
          icon: Icons.brush,
          color: Colors.blue,
        ),
        BusinessItemWidget(
          name: "Banco Digital",
          type: "Financeiro",
          profit: "R\$ 8.900/mês",
          level: "Nível 7",
          progress: 0.95,
          icon: Icons.account_balance,
          color: Colors.purple,
        ),
        BusinessItemWidget(
          name: "Restaurante",
          type: "Alimentação",
          profit: "R\$ 1.800/mês",
          level: "Nível 1",
          progress: 0.2,
          icon: Icons.restaurant,
          color: Colors.red,
        ),
        BusinessItemWidget(
          name: "Concessionária",
          type: "Automotivo",
          profit: "R\$ 12.500/mês",
          level: "Nível 8",
          progress: 1.0,
          icon: Icons.directions_car,
          color: Colors.teal,
        ),
      ],
    );
  }
}