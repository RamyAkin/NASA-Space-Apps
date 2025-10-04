import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/exoplanet.dart';

class ExoplanetService {
  // Use localhost Node.js proxy server to avoid CORS issues in web browsers
  static const String _base = 'http://localhost:3001/tap/sync';

  Uri _buildQueryUrl({required String adql, String format = 'json'}) {
    final params = {
      'query': adql,
      'format': format,
    };
    return Uri.parse(_base).replace(queryParameters: params);
  }

  /// Fetch confirmed planets. Optionally provide [limit] to restrict rows for
  /// quicker tests (useful on web to avoid large payloads).
  Future<List<Exoplanet>> fetchConfirmed({int? limit}) async {
    var q = 'SELECT * FROM ps';
    if (limit != null) q = 'SELECT TOP $limit * FROM ps';
    final uri = _buildQueryUrl(adql: q, format: 'json');
    return _fetch(uri);
  }

  Future<List<Exoplanet>> fetchCandidates({int? limit}) async {
    var q = "SELECT * FROM cumulative WHERE koi_disposition = 'CANDIDATE'";
    if (limit != null) q = "SELECT TOP $limit * FROM cumulative WHERE koi_disposition = 'CANDIDATE'";
    final uri = _buildQueryUrl(adql: q, format: 'json');
    return _fetch(uri);
  }

  Future<List<Exoplanet>> fetchFalsePositives({int? limit}) async {
    var q = "SELECT * FROM cumulative WHERE koi_disposition = 'FALSE POSITIVE'";
    if (limit != null) q = "SELECT TOP $limit * FROM cumulative WHERE koi_disposition = 'FALSE POSITIVE'";
    final uri = _buildQueryUrl(adql: q, format: 'json');
    return _fetch(uri);
  }

  Future<List<Exoplanet>> _fetch(Uri uri) async {
    http.Response resp;
    try {
      // Helpful debug info when diagnosing failures
      // ignore: avoid_print
      print('ExoplanetService: fetching ${uri.toString()}');
      resp = await http.get(uri);
    } catch (e) {
      // Network-level error (also covers CORS failures on web)
      throw Exception('Network error fetching ${uri.toString()}: $e');
    }

    if (resp.statusCode != 200) {
      final snippet = resp.body.length > 500 ? resp.body.substring(0, 500) + '...' : resp.body;
      throw Exception('Failed to load (${resp.statusCode}). Response snippet: $snippet');
    }

    // Try JSON first
    try {
      final decoded = json.decode(resp.body);
      if (decoded is List) {
        return decoded.map<Exoplanet>((e) => Exoplanet.fromJson(e as Map<String, dynamic>)).toList();
      }
      // Some responses can have a top-level 'data' or 'result'
      if (decoded is Map && decoded['data'] is List) {
        return (decoded['data'] as List).map((e) => Exoplanet.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // fallthrough to CSV parser; keep the exception for debugging
      // but do not fail here immediately
      // debugPrint('JSON parse failed: $e');
    }

    // Fallback: parse CSV
    try {
      return _parseCsv(resp.body);
    } catch (e) {
      throw Exception('Failed to parse response from ${uri.toString()}: $e');
    }
  }

  List<Exoplanet> _parseCsv(String csv) {
    final lines = LineSplitter.split(csv).toList();
    if (lines.isEmpty) return [];
    final header = _splitCsvLine(lines.first);
    final List<Exoplanet> out = [];
    for (var i = 1; i < lines.length; i++) {
      final row = _splitCsvLine(lines[i]);
      if (row.isEmpty) continue;
      final map = <String, dynamic>{};
      for (var j = 0; j < header.length && j < row.length; j++) {
        map[header[j]] = row[j];
      }
      out.add(Exoplanet.fromJson(map));
    }
    return out;
  }

  List<String> _splitCsvLine(String line) {
    // Very simple CSV splitter that handles quoted commas
    final List<String> parts = [];
    final buffer = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
        continue;
      }
      if (ch == ',' && !inQuotes) {
        parts.add(buffer.toString());
        buffer.clear();
        continue;
      }
      buffer.write(ch);
    }
    parts.add(buffer.toString());
    return parts.map((s) => s.trim()).toList();
  }
}
