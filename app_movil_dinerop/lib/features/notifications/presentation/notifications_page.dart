import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _navy = Color(0xFF142B4A);
  static const _teal = Color(0xFF16B8A6);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF7F9FC),
      foregroundColor: _navy,
      title: const Text(
        'Notificaciones',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Mantente al día con tu actividad financiera',
          style: TextStyle(color: Color(0xFF718096), fontSize: 14),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _UnavailableFilter('Todas'),
            _UnavailableFilter('Créditos'),
            _UnavailableFilter('Cooperativas'),
            _UnavailableFilter('Novedades'),
          ],
        ),
        const SizedBox(height: 34),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8EDF3)),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: _teal,
                  size: 31,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tu bandeja estará aquí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'La app puede mostrar notificaciones push cuando llegan, pero todavía no dispone de un servicio para consultar el historial, actualizar el contador o marcar mensajes como leídos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF718096),
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'La bandeja requiere integración con el backend.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _UnavailableFilter extends StatelessWidget {
  const _UnavailableFilter(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: const Color(0xFFE8EDF3)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: const Color(0xFF718096),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
