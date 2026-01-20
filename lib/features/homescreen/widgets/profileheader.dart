// features/homescreen/widgets/profile_header_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoremidle/core/models/carteirainvestimento.dart';
import 'package:valoremidle/core/viewmodels/vm_player.dart';
class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerVM = context.read<PlayerViewModel>();
    final carteiraVm = context.watch<CarteiraDeInvestimentos>();
    double variacao =carteiraVm.calcularVariacaoTotalPercentual();
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.person, size: 28, color: theme.colorScheme.onPrimary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playerVM.player.nome,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "@${playerVM.player.instagram}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: variacao > 0 ? theme.colorScheme.secondary.withValues(alpha: 0.2) :Color(0xFFE74C3C).withValues(alpha: 0.2) ,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color:variacao > 0 ? theme.colorScheme.secondary.withValues(alpha: 0.5) :  Color(0xFFE74C3C).withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [

              variacao > 0 ? Icon(Icons.trending_up, size: 16, color: theme.colorScheme.secondary) : Icon(Icons.trending_down, size: 16, color: Color(0xFFE74C3C)),
                const SizedBox(width: 4),
                variacao > 0 ? Text(
                  carteiraVm.calcularVariacaoTotalPercentual().toStringAsFixed(1),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ) :Text(
                  carteiraVm.calcularVariacaoTotalPercentual().toStringAsFixed(1),
                  style: TextStyle(
                    color: Color(0xFFE74C3C),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ) ,
            ],
          ),
        ),
      ],
    );
  }
}