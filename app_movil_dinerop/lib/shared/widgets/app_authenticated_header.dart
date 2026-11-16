import 'package:flutter/material.dart';

class AppAuthenticatedHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppAuthenticatedHeader({
    super.key,
    this.showNotifications = false,
    this.onNotifications,
  });

  final bool showNotifications;
  final VoidCallback? onNotifications;

  @override
  Size get preferredSize => const Size.fromHeight(62);

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
      toolbarHeight: 62,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/icon/app_icon.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DINEROP',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF142B4A),
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tu futuro financiero empieza aquí',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF718096),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (showNotifications)
          IconButton(
            onPressed: onNotifications,
            tooltip: 'Notificaciones',
            icon: Icon(Icons.notifications_none_rounded, color: colors.primary),
          ),
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
