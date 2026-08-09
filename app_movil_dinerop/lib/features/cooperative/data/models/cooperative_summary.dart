class CooperativeSummary {
  const CooperativeSummary({
    required this.id,
    required this.nombre,
    required this.ciudad,
    required this.provincia,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
    required this.logoUrl,
    required this.calificacion,
  });

  final int id;
  final String nombre;
  final String? ciudad;
  final String? provincia;
  final String? direccion;
  final String? telefono;
  final String? paginaWeb;
  final String? logoUrl;
  final double? calificacion;

  factory CooperativeSummary.fromJson(Map<String, dynamic> json) {
    return CooperativeSummary(
      id: (json['id'] as num).toInt(),
      nombre: (json['nombre'] ?? '').toString(),
      ciudad: json['ciudad']?.toString(),
      provincia: json['provincia']?.toString(),
      direccion: json['direccion']?.toString(),
      telefono: json['telefono']?.toString(),
      paginaWeb: json['paginaWeb']?.toString(),
      logoUrl: json['logoUrl']?.toString(),
      calificacion: (json['calificacion'] as num?)?.toDouble(),
    );
  }
}