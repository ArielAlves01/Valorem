import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoremidle/core/models/playermodel.dart';

class PlayerViewModel extends ChangeNotifier {
  PlayerModel player;

  SharedPreferences? _prefs;
  bool _dirty = false;

  PlayerViewModel() : player = _criarPlayerInicial();

  static PlayerModel _criarPlayerInicial() {
    return PlayerModel(
      experienciaNecessaria: 100,
      ganhoPorCliqueBonus: 0,
      experienciaAtual: 0,
      missoesCompletas: 0,
      anunciosAssistidos: 0,
      nome: 'Ariel Alves',
      instagram: 'arielalvexs',
      nivel: 15,
    );
  }

  Future<void> initStorage() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  double ganhoTotalPorClique(double ganhoBaseDoBalance) {
    return ganhoBaseDoBalance + player.ganhoPorCliqueBonus;
  }

  bool get removeAdsComprado => player.removeAdsComprado;

  void setRemoveAdsComprado(bool v) {
    if (player.removeAdsComprado == v) return;
    player.removeAdsComprado = v;
    _markDirty();
    notifyListeners();
  }

  void ganharExperiencia(int xp) {
    player.experienciaAtual += xp;

    if (player.experienciaAtual >= player.experienciaNecessaria) {
      _subirNivelInternal();
    }

    _markDirty();
    notifyListeners();
  }

  void completarMissao() {
    player.missoesCompletas++;
    _markDirty();
    notifyListeners();
  }

  void aumentarGanhoPorCliqueComAnuncio() {
    player.ganhoPorCliqueBonus += 2.0;
    player.anunciosAssistidos++;
    _markDirty();
    notifyListeners();
  }

  void registrarAnuncioAssistido() {
    player.anunciosAssistidos++;
    _markDirty();
    notifyListeners();
  }

  void _subirNivelInternal() {
    player.nivel++;
    player.experienciaAtual = 0;
    player.experienciaNecessaria = (player.experienciaNecessaria * 1.5).toInt();
    player.ganhoPorCliqueBonus += 0.5;
  }

  void _markDirty() => _dirty = true;

  Future<void> saveProgressIfDirty() async {
    if (!_dirty) return;
    await saveProgress();
  }

  Future<void> saveProgress() async {
    await initStorage();
    final prefs = _prefs!;
    await prefs.setString("player_save", jsonEncode(player.toJson()));
    _dirty = false;
  }

  Future<void> loadProgress() async {
    await initStorage();
    final prefs = _prefs!;
    final data = prefs.getString("player_save");
    if (data == null) return;

    try {
      player = PlayerModel.fromJson(jsonDecode(data));
    } catch (e) {
      if (kDebugMode) debugPrint("ERRO ao carregar player: $e");
    }

    notifyListeners();
  }
}
