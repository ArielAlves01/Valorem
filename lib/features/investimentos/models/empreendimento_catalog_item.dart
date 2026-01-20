import 'package:flutter/material.dart';

class EmpreendimentoCatalogItem {
  final String id;
  final String nome;
  final String tipo;
  final double custo;
  final double rendaPorMinuto;
  final IconData icon;

  const EmpreendimentoCatalogItem({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.custo,
    required this.rendaPorMinuto,
    required this.icon,
  });
}
