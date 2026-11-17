import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/notifications/push_notification_service.dart';
import '../../auth/presentation/auth_controller.dart';
import '../models/dolarito_reaction.dart';
import '../models/dolarito_state.dart';
import '../services/dolarito_service.dart';

final dolaritoServiceProvider = Provider<DolaritoService>(
  (ref) => const DolaritoService(),
);

final dolaritoProvider = StateNotifierProvider<DolaritoNotifier, DolaritoState>(
  (ref) {
    final notifier = DolaritoNotifier();
    final pushService = ref.watch(pushNotificationServiceProvider);
    void handlePush(PushNotificationEvent event) {
      if (!ref.read(authControllerProvider).isAuthenticated) return;
      notifier.show(
        ref.read(dolaritoServiceProvider).notification(event),
        force: true,
        navigateToRequests: event.opened,
      );
      ref.invalidate(dashboardCreditRequestsProvider);
      ref.invalidate(requestsProvider);
    }

    final subscription = pushService.events.listen(handlePush);
    final pendingOpenedEvent = pushService.consumePendingOpenedEvent();
    if (pendingOpenedEvent != null) handlePush(pendingOpenedEvent);
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isAuthenticated == true && !next.isAuthenticated) {
        notifier.reset();
      }
    });
    ref.onDispose(() {
      unawaited(subscription.cancel());
    });
    return notifier;
  },
);

class DolaritoNotifier extends StateNotifier<DolaritoState> {
  DolaritoNotifier() : super(const DolaritoState.initial());

  void show(
    DolaritoReaction reaction, {
    bool force = false,
    bool navigateToRequests = false,
  }) {
    if (!force &&
        state.visible &&
        state.priority.index > reaction.priority.index) {
      return;
    }
    if (state.event == reaction.event &&
        state.scopeKey == reaction.scopeKey &&
        state.message == reaction.message &&
        state.visible == true) {
      return;
    }
    state = DolaritoState.fromReaction(
      reaction,
      eventId: state.eventId + 1,
      navigateToRequests: navigateToRequests,
    );
  }

  void dismiss() {
    if (state.dismissible) state = state.copyWith(visible: false);
  }

  void consumeNavigation(int eventId) {
    if (state.eventId == eventId && state.navigateToRequests) {
      state = state.copyWith(navigateToRequests: false);
    }
  }

  void reset() => state = const DolaritoState.initial();
}
