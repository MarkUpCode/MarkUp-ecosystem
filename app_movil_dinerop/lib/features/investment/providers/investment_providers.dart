import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../data/investment_repository.dart';
import '../data/investment_draft_store.dart';

final investmentDraftStoreProvider = Provider<InvestmentDraftStore>(
  (ref) => InvestmentDraftStore(ref.watch(flutterSecureStorageProvider)),
);

final investmentRepositoryProvider = Provider<InvestmentRepository>(
  (ref) => InvestmentRepository(ref.watch(apiClientProvider)),
);

final investmentRequestsProvider = FutureProvider.autoDispose((ref) {
  final timer = Timer.periodic(const Duration(seconds: 25), (_) {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);
  return ref.watch(investmentRepositoryProvider).loadMyRequests();
});
