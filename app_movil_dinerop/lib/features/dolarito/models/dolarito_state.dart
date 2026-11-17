import 'dolarito_reaction.dart';
import 'dolarito_mood.dart';

class DolaritoState {
  const DolaritoState({
    required this.mood,
    required this.message,
    required this.event,
    required this.priority,
    required this.visible,
    required this.dismissible,
    this.action,
    this.actionLabel,
    this.scopeKey,
    this.eventId = 0,
    this.navigateToRequests = false,
  });

  const DolaritoState.initial()
    : mood = DolaritoMood.happy,
      message = '',
      event = DolaritoEvent.greeting,
      priority = DolaritoPriority.informative,
      visible = false,
      dismissible = false,
      action = null,
      actionLabel = null,
      scopeKey = null,
      eventId = 0,
      navigateToRequests = false;

  final DolaritoMood mood;
  final String message;
  final DolaritoEvent event;
  final DolaritoPriority priority;
  final bool visible;
  final bool dismissible;
  final DolaritoAction? action;
  final String? actionLabel;
  final String? scopeKey;
  final int eventId;
  final bool navigateToRequests;

  DolaritoState copyWith({
    DolaritoMood? mood,
    String? message,
    DolaritoEvent? event,
    DolaritoPriority? priority,
    bool? visible,
    bool? dismissible,
    DolaritoAction? action,
    String? actionLabel,
    String? scopeKey,
    int? eventId,
    bool? navigateToRequests,
    bool clearAction = false,
  }) => DolaritoState(
    mood: mood ?? this.mood,
    message: message ?? this.message,
    event: event ?? this.event,
    priority: priority ?? this.priority,
    visible: visible ?? this.visible,
    dismissible: dismissible ?? this.dismissible,
    action: clearAction ? null : action ?? this.action,
    actionLabel: clearAction ? null : actionLabel ?? this.actionLabel,
    scopeKey: scopeKey ?? this.scopeKey,
    eventId: eventId ?? this.eventId,
    navigateToRequests: navigateToRequests ?? this.navigateToRequests,
  );

  factory DolaritoState.fromReaction(
    DolaritoReaction reaction, {
    required int eventId,
    bool navigateToRequests = false,
  }) => DolaritoState(
    mood: reaction.mood,
    message: reaction.message,
    event: reaction.event,
    priority: reaction.priority,
    visible: true,
    dismissible: reaction.dismissible,
    action: reaction.action,
    actionLabel: reaction.actionLabel,
    scopeKey: reaction.scopeKey,
    eventId: eventId,
    navigateToRequests: navigateToRequests,
  );

  DolaritoReaction toReaction() => DolaritoReaction(
    mood: mood,
    message: message,
    event: event,
    priority: priority,
    action: action,
    actionLabel: actionLabel,
    dismissible: dismissible,
    scopeKey: scopeKey,
  );
}
