import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';

class CooperativesPage extends ConsumerWidget {
  const CooperativesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cooperativesAsync = ref.watch(cooperativesProvider);

    return Scaffold(
      body: SafeArea(
        child: cooperativesAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const AppEmptyState(
                title: 'Sin cooperativas',
                message: 'El backend no devolvió cooperativas disponibles.',
                icon: Icons.apartment_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                final cooperative = items[index];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cooperative.nombre,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${cooperative.ciudad ?? '-'}, ${cooperative.provincia ?? '-'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cooperative.direccion ?? '-',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (cooperative.calificacion != null)
                            Text(
                              '${cooperative.calificacion!.toStringAsFixed(1)} / 5',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          const Spacer(),
                          Text(
                            cooperative.telefono ?? '-',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      if (cooperative.paginaWeb != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          cooperative.paginaWeb!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
          loading: () => const AppLoader(label: 'Cargando cooperativas...'),
          error: (error, stackTrace) => AppErrorView(
            message: error is AppException
                ? error.message
                : AppErrorMessages.generic,
          ),
        ),
      ),
    );
  }
}
