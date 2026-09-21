Screens taken out of the rider app when the side navigation was trimmed to
Profile / Help & support / Terms / Privacy / About.

  settings/       was /settings — the drawer was its only entry point
  plan_page.dart  was /plan ("Rental plan") — likewise

Kept here rather than deleted because this project is not under version
control. To restore one, move it back under rider_app/lib/features/ and
re-add its Routes entry, its GoRoute in app_router.dart, and a way in.

  earnings/       was /earnings — the "Earnings ›" action on the home glance
                  card was its only entry point. Only the UI came out; the
                  repository behind it still serves the incentives screen, so
                  EarningsRepository.getEarnings() is intact and waiting.

  documents_page.dart  was /documents — the profile screen's "View documents"
                       action, on the KYC card, was its only entry point. Its
                       replace-a-document sheet went with it.

  attendance/     was /attendance — the "Online today" tile on the home glance
                  card was its only entry point. Marking present/absent still
                  lives on the home band; this was the month's history.
