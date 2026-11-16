import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _navy = Color(0xFF142B4A);
const _teal = Color(0xFF16B8A6);
const _muted = Color(0xFF718096);
const _line = Color(0xFFE8EDF3);

class ProductShowcaseSection extends StatelessWidget {
  const ProductShowcaseSection({super.key});

  static const _products = [
    (Icons.smartphone_rounded, 'Smartphones', 'Tecnología'),
    (Icons.laptop_mac_rounded, 'Laptops', 'Computación'),
    (Icons.tv_rounded, 'Televisores', 'Entretenimiento'),
    (Icons.kitchen_rounded, 'Hogar', 'Electrodomésticos'),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeading(
        title: 'Productos para ti',
        subtitle: 'Descubre productos y oportunidades que podrían interesarte',
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 204,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _products.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final product = _products[index];
            return Container(
              width: 148,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 72,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF8F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(product.$1, size: 38, color: _teal),
                  ),
                  const Spacer(),
                  Text(
                    product.$2,
                    style: const TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.$3,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'PRÓXIMAMENTE',
                    style: TextStyle(
                      color: _teal,
                      fontSize: 9,
                      letterSpacing: .7,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

class FinanceToolsSection extends StatelessWidget {
  const FinanceToolsSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeading(title: 'Herramientas financieras'),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _ToolCard(
            icon: Icons.add_card_rounded,
            title: 'Solicitar crédito',
            onTap: () => context.push('/request-credit'),
          ),
          _ToolCard(
            icon: Icons.receipt_long_rounded,
            title: 'Mis solicitudes',
            onTap: () => context.go('/requests'),
          ),
          _ToolCard(
            icon: Icons.calculate_rounded,
            title: 'Simulador de cuotas',
            onTap: () => context.push('/simulate-credit'),
          ),
          _ToolCard(
            icon: Icons.person_outline_rounded,
            title: 'Mi perfil financiero',
            onTap: () => context.go('/profile'),
          ),
          const _ToolCard(
            icon: Icons.auto_stories_rounded,
            title: 'Educación financiera',
            comingSoon: true,
          ),
        ],
      ),
    ],
  );
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    this.onTap,
    this.comingSoon = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: _line),
        ),
        child: Row(
          children: [
            Icon(icon, color: _teal, size: 22),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (comingSoon)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'PRÓXIMAMENTE',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 8,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!comingSoon)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: _muted,
              ),
          ],
        ),
      ),
    ),
  );
}

class CreditHealthCard extends StatelessWidget {
  const CreditHealthCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [_navy, Color(0xFF1D4567)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.insights_rounded, color: Colors.white),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mi perfil crediticio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Conoce y mejora tu salud financiera',
                style: TextStyle(color: Color(0xFFD3E1ED), fontSize: 12),
              ),
              SizedBox(height: 9),
              Text(
                'PRÓXIMAMENTE',
                style: TextStyle(
                  color: Color(0xFF73E0D1),
                  fontSize: 10,
                  letterSpacing: .8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class FinancialEducationSection extends StatelessWidget {
  const FinancialEducationSection({super.key});

  static const _topics = [
    (
      Icons.trending_up_rounded,
      'Cómo mejorar tu historial crediticio',
      'Paga tus obligaciones a tiempo y revisa tus compromisos con frecuencia.',
    ),
    (
      Icons.fact_check_outlined,
      'Antes de solicitar un crédito',
      'Compara el monto y el plazo con lo que puedes pagar cada mes.',
    ),
    (
      Icons.account_balance_wallet_outlined,
      'Organiza ingresos y gastos',
      'Anota tus ingresos y gastos para entender cuánto queda disponible.',
    ),
    (
      Icons.calculate_outlined,
      'Calcula tu capacidad de pago',
      'Incluye tus cuotas actuales y gastos fijos en tu presupuesto.',
    ),
    (
      Icons.credit_score_rounded,
      'Maneja tus deudas',
      'Prioriza tus pagos y evita asumir cuotas que no caben en tu presupuesto.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeading(
        title: 'Aprende a mejorar tus finanzas',
        subtitle: 'Consejos prácticos para tomar mejores decisiones',
      ),
      const SizedBox(height: 12),
      for (final topic in _topics) ...[
        Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _line),
          ),
          child: Row(
            children: [
              Icon(topic.$1, color: _teal, size: 21),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.$2,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      topic.$3,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      const Text(
        'Contenido educativo general; no sustituye asesoría financiera personalizada.',
        style: TextStyle(color: _muted, fontSize: 10),
      ),
    ],
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _navy,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(
          subtitle!,
          style: const TextStyle(color: _muted, fontSize: 12, height: 1.35),
        ),
      ],
    ],
  );
}
