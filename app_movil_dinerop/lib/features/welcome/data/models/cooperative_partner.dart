class CooperativePartner {
  const CooperativePartner({
    required this.id,
    required this.nombre,
    this.assetPath,
    this.logoUrl,
    this.subtitulo,
  });

  final String id;
  final String nombre;
  final String? assetPath;
  final String? logoUrl;
  final String? subtitulo;

  /// Lista predeterminada de las 3 cooperativas participantes iniciales
  static const List<CooperativePartner> initialPartners = [
    CooperativePartner(
      id: 'coop_01',
      nombre: 'Alianza del Valle',
      assetPath: 'assets/images/cooperatives/alianza_del_valle_transparente.svg',
      subtitulo: 'Cooperativa de Ahorro y Crédito',
    ),
    CooperativePartner(
      id: 'coop_02',
      nombre: 'Tulcán Ltda.',
      assetPath: 'assets/images/cooperatives/tulcan_ltda_transparente.svg',
      subtitulo: 'Cooperativa de Ahorro y Crédito',
    ),
    CooperativePartner(
      id: 'coop_03',
      nombre: 'Unión El Ejido',
      assetPath: 'assets/images/cooperatives/union_el_ejido_transparente.svg',
      subtitulo: 'Cooperativa de Ahorro y Crédito',
    ),
  ];
}
