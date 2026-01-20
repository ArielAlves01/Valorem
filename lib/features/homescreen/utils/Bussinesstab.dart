// features/homescreen/widgets/business_tabs_section.dart
import 'package:flutter/material.dart';
import 'package:valoremidle/features/homescreen/widgets/businessessection.dart';
import 'package:valoremidle/features/homescreen/widgets/investingsection.dart';

class BusinessTabsSection extends StatefulWidget {
  const BusinessTabsSection({super.key});

  @override
  State<BusinessTabsSection> createState() => _BusinessTabsSectionState();
}

class _BusinessTabsSectionState extends State<BusinessTabsSection>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MEUS NEGÓCIOS",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: "Meus Investimentos"),
                Tab(text: "Meus Empreendimentos"),
              ],
            ),
          ),

          const SizedBox(height: 16),


          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                InvestmentsTabContent(),
                BusinessesTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}