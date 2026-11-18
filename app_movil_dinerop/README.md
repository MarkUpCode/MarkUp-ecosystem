# app_movil_dinerop

App movil de dinerop

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## OTP and onboarding experience

The OTP and password fields are separate inputs with independent focus nodes.
After OTP verification, the numeric field releases focus and Flutter hides the
numeric keyboard before the alphanumeric password step is shown.

After registration or login, the dashboard reads
`/api/onboarding/cliente/formulario-status` through
`dashboardOnboardingStatusProvider`. `formularioCompleto` is the source of truth
for showing Dolarito's profile reminder and its dashboard spotlight.
Dismissing the spotlight is stored only for the current in-memory session; it
does not change onboarding status. The next login starts with the spotlight
available again while the backend reports an incomplete profile.

Submitting the existing onboarding form still requires a successful refresh
that confirms `formularioCompleto == true`. Partial saves and failed or
unconfirmed submissions do not mark the profile complete.

The dashboard's applications section uses the existing credit and investment
request providers in one segmented view. Dolarito's status message is rendered
inside each request card. Selecting a card's details action passes that
request's id to the existing request details sheet.
Credit summaries currently expose the number of cooperatives notified, rather
than their names. Investment requests expose their real status but no numeric
progress value, so the dashboard does not fabricate an investment progress bar.
