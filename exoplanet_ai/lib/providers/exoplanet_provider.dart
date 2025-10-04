import 'package:flutter/foundation.dart';
import '../models/exoplanet.dart';
import '../services/exoplanet_service.dart';

class ExoplanetProvider extends ChangeNotifier {
  final ExoplanetService _service;

  ExoplanetProvider([ExoplanetService? service]) : _service = service ?? ExoplanetService();

  List<Exoplanet> confirmed = [];
  List<Exoplanet> candidates = [];
  List<Exoplanet> falsePositives = [];

  bool loading = false;
  String? error;

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final c = await _service.fetchConfirmed();
      final cand = await _service.fetchCandidates();
      final fp = await _service.fetchFalsePositives();
      confirmed = c;
      candidates = cand;
      falsePositives = fp;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}
