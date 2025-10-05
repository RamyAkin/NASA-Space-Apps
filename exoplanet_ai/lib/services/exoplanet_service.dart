import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exoplanet.dart';

class ExoplanetService {
  static const String _base = 'http://localhost:3001/tap/sync';
  static const String _aiApiBase = 'http://localhost:3001';

  Uri _buildQueryUrl({required String adql, String format = 'json'}) {
    final params = {
      'query': adql,
      'format': format,
    };
    return Uri.parse(_base).replace(queryParameters: params);
  }

  Future<List<Exoplanet>> fetchConfirmed({int? offset, int? limit}) async {
   
    final totalToFetch = (offset ?? 0) + (limit ?? 100);
    var q = 'SELECT TOP $totalToFetch * FROM ps';
    final uri = _buildQueryUrl(adql: q, format: 'json');
    final allItems = await _fetch(uri);
    

    final startIndex = offset ?? 0;
    if (startIndex >= allItems.length) return [];
    final endIndex = startIndex + (limit ?? allItems.length);
    return allItems.sublist(startIndex, endIndex.clamp(0, allItems.length));
  }

  Future<List<Exoplanet>> fetchCandidates({int? offset, int? limit}) async {

    final totalToFetch = (offset ?? 0) + (limit ?? 100);
    var q = "SELECT TOP $totalToFetch * FROM CUMULATIVE WHERE koi_disposition = 'CANDIDATE'";
    final uri = _buildQueryUrl(adql: q, format: 'json');
    final allItems = await _fetch(uri);
    
    // Client-side pagination
    final startIndex = offset ?? 0;
    if (startIndex >= allItems.length) return [];
    final endIndex = startIndex + (limit ?? allItems.length);
    return allItems.sublist(startIndex, endIndex.clamp(0, allItems.length));
  }

  Future<List<Exoplanet>> fetchFalsePositives({int? offset, int? limit}) async {

    final totalToFetch = (offset ?? 0) + (limit ?? 100);
    var q = "SELECT TOP $totalToFetch * FROM CUMULATIVE WHERE koi_disposition = 'FALSE POSITIVE'";
    final uri = _buildQueryUrl(adql: q, format: 'json');
    final allItems = await _fetch(uri);
    
    // Client-side pagination
    final startIndex = offset ?? 0;
    if (startIndex >= allItems.length) return [];
    final endIndex = startIndex + (limit ?? allItems.length);
    return allItems.sublist(startIndex, endIndex.clamp(0, allItems.length));
  }

  Future<List<Exoplanet>> _fetch(Uri uri) async {
    http.Response resp;
    try {
      print('Fetching: $uri');
      resp = await http.get(uri);
    } catch (e) {
      throw Exception('Network error: $e');
    }

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.reasonPhrase}');
    }

    try {
      final data = jsonDecode(resp.body);
      List<dynamic> rows;
      
      // Handle different response formats
      if (data is List) {
        // Direct array response (NASA TAP format)
        rows = data;
      } else if (data is Map && data.containsKey('data')) {
        // Wrapped response format
        rows = data['data'] as List;
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
      
      return rows.map((row) => Exoplanet.fromMap(row as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }

  // AI Prediction Methods - Exoplanet Confirmation
  Future<Map<String, dynamic>> predictHabitability(Exoplanet exoplanet) async {
    try {
      final uri = Uri.parse('$_aiApiBase/ai/predict');
      
      // Only predict if we have orbital period data
      if (exoplanet.orbitalPeriod == null) {
        throw Exception('Insufficient data for AI prediction');
      }
      
      // Prepare the request body with the 4 parameters your AI expects
      // Using orbital period and deriving other values from available data
      final requestBody = {
        'period': exoplanet.orbitalPeriod!,
        'duration': exoplanet.radius != null ? exoplanet.radius! * 2.5 : 3.0, // Transit duration estimate
        'depth': exoplanet.radius != null ? (exoplanet.radius! * 0.0001) : 0.001, // Transit depth
        'ror': exoplanet.radius != null ? (exoplanet.radius! * 0.05) : 0.1, // Radius ratio
      };

      print('Sending AI prediction request for ${exoplanet.name}: $requestBody');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('AI prediction result for ${exoplanet.name}: $result');
        return result;
      } else {
        throw Exception('AI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error calling AI API: $e');
      throw Exception('Failed to get AI prediction: $e');
    }
  }

  Future<Map<String, dynamic>> predictExoplanetType(Exoplanet exoplanet) async {
    // You can add more specific prediction endpoints here
    return await predictHabitability(exoplanet);
  }
}
