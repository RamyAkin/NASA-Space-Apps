class Exoplanet {
  final String name;
  final String? status;
  final double? radius; // Earth radii
  final double? mass; // Earth masses
  final double? orbitalPeriod; // days
  final int? discoveryYear;
  final double? stellarRadius; // Solar radii (for candidates)
  final double? equilibriumTemp; // Kelvin (for candidates)
  final double? transitDepth; // ppm (for candidates)
  final double? transitDuration; // hours (for candidates)

  Exoplanet({
    required this.name,
    required this.status,
    this.radius,
    this.mass,
    this.orbitalPeriod,
    this.discoveryYear,
    this.stellarRadius,
    this.equilibriumTemp,
    this.transitDepth,
    this.transitDuration,
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
      // CUMULATIVE table uses different field names for candidates/false positives
      if (rade == null && json['koi_prad'] != null) rade = (json['koi_prad'] is num) ? (json['koi_prad'] as num).toDouble() : double.tryParse(json['koi_prad'].toString());
      // Note: CUMULATIVE table doesn't have mass data for candidates, so mass will be null
      if (orbper == null && json['koi_period'] != null) orbper = (json['koi_period'] is num) ? (json['koi_period'] as num).toDouble() : double.tryParse(json['koi_period'].toString());
    } catch (_) {}

    int? discYear;
    try {
      if (json['disc_year'] != null) discYear = (json['disc_year'] is num) ? (json['disc_year'] as num).toInt() : int.tryParse(json['disc_year'].toString());
      if (discYear == null && json['pl_disc'] != null) discYear = (json['pl_disc'] is num) ? (json['pl_disc'] as num).toInt() : int.tryParse(json['pl_disc'].toString());
    } catch (_) {}

    // Parse additional CUMULATIVE table fields
    double? stellarRadius, equilibriumTemp, transitDepth, transitDuration;
    try {
      if (json['koi_srad'] != null) stellarRadius = (json['koi_srad'] is num) ? (json['koi_srad'] as num).toDouble() : double.tryParse(json['koi_srad'].toString());
      if (json['koi_teq'] != null) equilibriumTemp = (json['koi_teq'] is num) ? (json['koi_teq'] as num).toDouble() : double.tryParse(json['koi_teq'].toString());
      if (json['koi_depth'] != null) transitDepth = (json['koi_depth'] is num) ? (json['koi_depth'] as num).toDouble() : double.tryParse(json['koi_depth'].toString());
      if (json['koi_duration'] != null) transitDuration = (json['koi_duration'] is num) ? (json['koi_duration'] as num).toDouble() : double.tryParse(json['koi_duration'].toString());
    } catch (_) {}

    return Exoplanet(
      name: name,
      status: status,
      radius: rade,
      mass: bmasse,
      orbitalPeriod: orbper,
      discoveryYear: discYear,
      stellarRadius: stellarRadius,
      equilibriumTemp: equilibriumTemp,
      transitDepth: transitDepth,
      transitDuration: transitDuration,
    );
  }

  factory Exoplanet.fromMap(Map<String, dynamic> map) {
    // Handle NASA TAP field names
    String name = map['pl_name'] ?? map['kepoi_name'] ?? map['name'] ?? 'Unknown';
    String? status = map['koi_disposition'] ?? map['status'] ?? 'CONFIRMED';
    
    // Parse radius (Earth radii)
    double? radius;
    if (map['pl_rade'] != null) {
      radius = (map['pl_rade'] is num) ? (map['pl_rade'] as num).toDouble() : double.tryParse(map['pl_rade'].toString());
    } else if (map['koi_prad'] != null) {
      radius = (map['koi_prad'] is num) ? (map['koi_prad'] as num).toDouble() : double.tryParse(map['koi_prad'].toString());
    } else if (map['radius'] != null) {
      radius = (map['radius'] is num) ? (map['radius'] as num).toDouble() : double.tryParse(map['radius'].toString());
    }
    
    // Parse mass (Earth masses) 
    double? mass;
    if (map['pl_bmasse'] != null) {
      mass = (map['pl_bmasse'] is num) ? (map['pl_bmasse'] as num).toDouble() : double.tryParse(map['pl_bmasse'].toString());
    } else if (map['mass'] != null) {
      mass = (map['mass'] is num) ? (map['mass'] as num).toDouble() : double.tryParse(map['mass'].toString());
    }
    
    // Parse orbital period (days)
    double? orbitalPeriod;
    if (map['pl_orbper'] != null) {
      orbitalPeriod = (map['pl_orbper'] is num) ? (map['pl_orbper'] as num).toDouble() : double.tryParse(map['pl_orbper'].toString());
    } else if (map['koi_period'] != null) {
      orbitalPeriod = (map['koi_period'] is num) ? (map['koi_period'] as num).toDouble() : double.tryParse(map['koi_period'].toString());
    } else if (map['orbitalPeriod'] != null) {
      orbitalPeriod = (map['orbitalPeriod'] is num) ? (map['orbitalPeriod'] as num).toDouble() : double.tryParse(map['orbitalPeriod'].toString());
    }
    
    // Parse discovery year
    int? discoveryYear;
    if (map['disc_year'] != null) {
      discoveryYear = (map['disc_year'] is num) ? (map['disc_year'] as num).toInt() : int.tryParse(map['disc_year'].toString());
    } else if (map['discoveryYear'] != null) {
      discoveryYear = (map['discoveryYear'] is num) ? (map['discoveryYear'] as num).toInt() : int.tryParse(map['discoveryYear'].toString());
    }
    
    // Parse CUMULATIVE table additional fields
    double? stellarRadius;
    if (map['koi_srad'] != null) {
      stellarRadius = (map['koi_srad'] is num) ? (map['koi_srad'] as num).toDouble() : double.tryParse(map['koi_srad'].toString());
    }
    
    double? equilibriumTemp;
    if (map['koi_teq'] != null) {
      equilibriumTemp = (map['koi_teq'] is num) ? (map['koi_teq'] as num).toDouble() : double.tryParse(map['koi_teq'].toString());
    }
    
    double? transitDepth;
    if (map['koi_depth'] != null) {
      transitDepth = (map['koi_depth'] is num) ? (map['koi_depth'] as num).toDouble() : double.tryParse(map['koi_depth'].toString());
    }
    
    double? transitDuration;
    if (map['koi_duration'] != null) {
      transitDuration = (map['koi_duration'] is num) ? (map['koi_duration'] as num).toDouble() : double.tryParse(map['koi_duration'].toString());
    }
    
    return Exoplanet(
      name: name,
      status: status,
      radius: radius,
      mass: mass,
      orbitalPeriod: orbitalPeriod,
      discoveryYear: discoveryYear,
      stellarRadius: stellarRadius,
      equilibriumTemp: equilibriumTemp,
      transitDepth: transitDepth,
      transitDuration: transitDuration,
    );
  }
}
