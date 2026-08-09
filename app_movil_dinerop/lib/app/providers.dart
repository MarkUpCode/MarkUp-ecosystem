import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/cooperative/data/cooperative_repository.dart';
import '../features/credit/data/credit_repository.dart';

final creditRepositoryProvider = Provider<CreditRepository>((ref) {
  return CreditRepository(ref.watch(apiClientProvider));
});

final cooperativeRepositoryProvider = Provider<CooperativeRepository>((ref) {
  return CooperativeRepository(ref.watch(apiClientProvider));
});

final dashboardCreditRequestsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(creditRepositoryProvider).loadMyRequests();
});

final dashboardOnboardingStatusProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(onboardingRepositoryProvider).loadStatus();
});

final cooperativesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(cooperativeRepositoryProvider).loadCooperatives();
});

final requestsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(creditRepositoryProvider).loadMyRequests();
});