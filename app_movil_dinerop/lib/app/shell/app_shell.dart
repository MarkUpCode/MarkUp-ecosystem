import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/app_authenticated_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  int _selectedIndex(String location) {
    if (location.startsWith('/requests')) return 2;
    if (location.startsWith('/cooperatives')) return 3;
    if (location.startsWith('/profile')) return 4;
    if (location.startsWith('/notifications')) return -1;
    return 0;
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La sección Productos estará disponible próximamente.',
            ),
          ),
        );
        break;
      case 2:
        context.go('/requests');
        break;
      case 3:
        context.go('/cooperatives');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      appBar: location == '/notifications'
          ? null
          : AppAuthenticatedHeader(
              showNotifications: location == '/dashboard',
              onNotifications: () => context.push('/notifications'),
            ),
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 62,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE8EDF3))),
            boxShadow: [
              BoxShadow(
                color: Color(0x080E2440),
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavigationItem(
                index: 0,
                selectedIndex: selectedIndex,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Inicio',
                onTap: () => _navigate(context, 0),
              ),
              _NavigationItem(
                index: 1,
                selectedIndex: selectedIndex,
                icon: Icons.storefront_outlined,
                selectedIcon: Icons.storefront_rounded,
                label: 'Productos',
                onTap: () => _navigate(context, 1),
              ),
              _NavigationItem(
                index: 2,
                selectedIndex: selectedIndex,
                icon: Icons.receipt_long_outlined,
                selectedIcon: Icons.receipt_long_rounded,
                label: 'Solicitudes',
                onTap: () => _navigate(context, 2),
              ),
              _NavigationItem(
                index: 3,
                selectedIndex: selectedIndex,
                icon: Icons.account_balance_outlined,
                selectedIcon: Icons.account_balance_rounded,
                label: 'Coop.',
                onTap: () => _navigate(context, 3),
              ),
              _NavigationItem(
                index: 4,
                selectedIndex: selectedIndex,
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Perfil',
                onTap: () => _navigate(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = selectedIndex == index;
    final color = selected ? const Color(0xFF142B4A) : const Color(0xFF8793A1);
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.04 : 1,
                duration: const Duration(milliseconds: 160),
                child: Icon(
                  selected ? selectedIcon : icon,
                  color: color,
                  size: 21,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: selected ? 14 : 4,
                height: 3,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF16B8A6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
