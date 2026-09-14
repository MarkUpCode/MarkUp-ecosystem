import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/di.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/cooperative/data/cooperative_repository.dart';
import '../features/credit/data/credit_repository.dart';
import '../features/onboarding/data/models/pre_registration_data.dart';

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

/// Personal data captured at registration. The login response intentionally
/// contains only authentication data, so client-facing screens use this
/// authenticated endpoint for the person's name and contact details.
final clientProfileProvider = FutureProvider.autoDispose<PreRegistrationData>((ref) {
  return ref.watch(onboardingRepositoryProvider).loadPreRegistrationData();
});

final cooperativesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(cooperativeRepositoryProvider).loadCooperatives();
});

final requestsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(creditRepositoryProvider).loadMyRequests();
});
