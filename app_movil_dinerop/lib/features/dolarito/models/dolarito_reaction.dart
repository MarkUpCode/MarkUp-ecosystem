import 'dolarito_mood.dart';

enum DolaritoPriority {
  informative,
  motivation,
  actionable,
  alert,
  critical,
  celebration,
}

enum DolaritoEvent {
  greeting,
  onboardingRequired,
  onboardingProgress,
  onboardingError,
  onboardingComplete,
  creditCreated,
  creditPending,
  creditReview,
  creditPreApproved,
  creditAccepted,
  creditRejected,
  guaranteeRequired,
  informationPending,
  connectionError,
  pushUpdate,
  investmentWelcome,
  investmentThinking,
  investmentOffersFound,
  investmentNoOffers,
  investmentOfferSelected,
  investmentRequestSent,
  investmentRequestStatus,
  investmentAccountRequired,
  investmentAccountReady,
}

enum DolaritoAction { completeProfile, viewRequests, retry }

class DolaritoReaction {
  const DolaritoReaction({
    required this.mood,
    required this.message,
    required this.event,
    required this.priority,
    this.action,
    this.actionLabel,
    this.dismissible = false,
    this.scopeKey,
  });

  final DolaritoMood mood;
  final String message;
  final DolaritoEvent event;
  final DolaritoPriority priority;
  final DolaritoAction? action;
  final String? actionLabel;
  final bool dismissible;
  final String? scopeKey;
}
