import 'package:flutter/material.dart';

class AppAuthenticatedHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppAuthenticatedHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  void _showHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Centro de ayuda', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Estamos aquí para acompañarte en cada paso de tu solicitud.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.support_agent_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Contactar soporte'),
                  subtitle: const Text(
                    'Te ayudamos con tu cuenta y tus solicitudes',
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.security_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Tu seguridad'),
                  subtitle: const Text('Tus datos se manejan de forma segura'),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_rounded,
              color: colors.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Text(
            'DINEROP',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showHelp(context),
          tooltip: 'Ayuda y soporte',
          icon: Icon(Icons.help_outline_rounded, color: colors.primary),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: colors.primary),
      ),
    );
  }
}
