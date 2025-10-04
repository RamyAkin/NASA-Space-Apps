class Exoplanet {
  final String name;
  final String status;
  final double? radius; // Earth radii
  final double? mass; // Earth masses
  final double? orbitalPeriod; // days

  Exoplanet({
    required this.name,
    required this.status,
    this.radius,
    this.mass,
    this.orbitalPeriod,
  });

  factory Exoplanet.fromJson(Map<String, dynamic> json) {
    String name = json['pl_name'] ?? json['kepoi_name'] ?? json['kepid']?.toString() ?? 'Unknown';
    String status = json['koi_disposition'] ?? json['disposition'] ?? 'CONFIRMED';
    double? rade;
    double? bmasse;
    double? orbper;
    try {
      if (json['pl_rade'] != null) rade = (json['pl_rade'] is num) ? (json['pl_rade'] as num).toDouble() : double.tryParse(json['pl_rade'].toString());
      if (json['pl_bmasse'] != null) bmasse = (json['pl_bmasse'] is num) ? (json['pl_bmasse'] as num).toDouble() : double.tryParse(json['pl_bmasse'].toString());
      if (json['pl_orbper'] != null) orbper = (json['pl_orbper'] is num) ? (json['pl_orbper'] as num).toDouble() : double.tryParse(json['pl_orbper'].toString());
      // Some tables use different keys
      if (rade == null && json['pl_rade'] == null && json['koi_prad'] != null) rade = (json['koi_prad'] is num) ? (json['koi_prad'] as num).toDouble() : double.tryParse(json['koi_prad'].toString());
      if (bmasse == null && json['pl_bmasse'] == null && json['koi_mass'] != null) bmasse = (json['koi_mass'] is num) ? (json['koi_mass'] as num).toDouble() : double.tryParse(json['koi_mass'].toString());
      if (orbper == null && json['pl_orbper'] == null && json['koi_period'] != null) orbper = (json['koi_period'] is num) ? (json['koi_period'] as num).toDouble() : double.tryParse(json['koi_period'].toString());
    } catch (_) {}

    return Exoplanet(
      name: name,
      status: status,
      radius: rade,
      mass: bmasse,
      orbitalPeriod: orbper,
    );
  }
}
