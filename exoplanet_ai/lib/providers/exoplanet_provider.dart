import 'package:flutter/foundation.dart';
import '../models/exoplanet.dart';
import '../services/exoplanet_service.dart';

class ExoplanetProvider extends ChangeNotifier {
  final ExoplanetService _service;
  static const int _pageSize = 20;

  ExoplanetProvider([ExoplanetService? service]) : _service = service ?? ExoplanetService();

  // Confirmed planets
  List<Exoplanet> confirmed = [];
  bool confirmedLoading = false;
  bool confirmedHasMore = true;
  int _confirmedPage = 0;

  // Candidates
  List<Exoplanet> candidates = [];
  bool candidatesLoading = false;
  bool candidatesHasMore = true;
  int _candidatesPage = 0;

  // False Positives
  List<Exoplanet> falsePositives = [];
  bool falsePositivesLoading = false;
  bool falsePositivesHasMore = true;
  int _falsePositivesPage = 0;

  String? error;

  Future<void> loadConfirmed({bool refresh = false}) async {
    if (confirmedLoading || (!confirmedHasMore && !refresh)) return;

    if (refresh) {
      confirmed.clear();
      _confirmedPage = 0;
      confirmedHasMore = true;
    }

    confirmedLoading = true;
    error = null;
    notifyListeners();

    try {
      final newItems = await _service.fetchConfirmed(
        offset: _confirmedPage * _pageSize,
        limit: _pageSize,
      );
      
      if (newItems.length < _pageSize) {
        confirmedHasMore = false;
      }
      
      confirmed.addAll(newItems);
      _confirmedPage++;
    } catch (e) {
      error = e.toString();
    }

    confirmedLoading = false;
    notifyListeners();
  }

  Future<void> loadCandidates({bool refresh = false}) async {
    if (candidatesLoading || (!candidatesHasMore && !refresh)) return;

    if (refresh) {
      candidates.clear();
      _candidatesPage = 0;
      candidatesHasMore = true;
    }

    candidatesLoading = true;
    error = null;
    notifyListeners();

    try {
      final candidateOffset = _candidatesPage * _pageSize;
      final pageLimit = _pageSize;
      final newItems = await _service.fetchCandidates(
        offset: candidateOffset,
        limit: pageLimit,
      );
      
      if (newItems.length < _pageSize) {
        candidatesHasMore = false;
      }
      
      candidates.addAll(newItems);
      _candidatesPage++;
    } catch (e) {
      error = e.toString();
    }

    candidatesLoading = false;
    notifyListeners();
  }

  Future<void> loadFalsePositives({bool refresh = false}) async {
    if (falsePositivesLoading || (!falsePositivesHasMore && !refresh)) return;

    if (refresh) {
      falsePositives.clear();
      _falsePositivesPage = 0;
      falsePositivesHasMore = true;
    }

    falsePositivesLoading = true;
    error = null;
    notifyListeners();

    try {
      final newItems = await _service.fetchFalsePositives(
        offset: _falsePositivesPage * _pageSize,
        limit: _pageSize,
      );
      
      if (newItems.length < _pageSize) {
        falsePositivesHasMore = false;
      }
      
      falsePositives.addAll(newItems);
      _falsePositivesPage++;
    } catch (e) {
      error = e.toString();
    }

    falsePositivesLoading = false;
    notifyListeners();
  }

  // Legacy method for initial load
  Future<void> loadAll() async {
    await Future.wait([
      loadConfirmed(refresh: true),
      loadCandidates(refresh: true),
      loadFalsePositives(refresh: true),
    ]);
  }
}
