# EVSEYE

Two Flutter apps and the shared foundation they are both built on.

```
EVSEYE/
├── evseye_core/          design system + JSON-driven UI engine (shared package)
├── rider_app/            EVSEYE Rider      (Android + iOS)
└── fleet_manager_app/    EVSEYE Fleet      (Android + iOS)
```

Both apps depend on `evseye_core` by path, so a change to a colour, a button or
a validator lands in both at once.

## Running

```bash
cd rider_app         && flutter pub get && flutter run
cd fleet_manager_app && flutter pub get && flutter run
```

Only Android and iOS are configured. There is no web or desktop target.

The apps are UI-complete and run entirely on bundled mock data — no backend is
required. Sign-in accepts any 10-digit mobile number and any 6-digit OTP.

## The apps

### Rider

Sign in with a mobile number and an OTP. The fleet operator is fixed per build
via `SessionController.hardcodedClientCode`, so there is no company-code step.
Onboarding then runs as a six-step JSON-driven flow — profile, KYC, eligibility,
commercials, training and the rider agreement — followed by a review screen, a
submission wait, a pre-delivery inspection checklist and an allocation wait.

The home screen carries the two controls that define the app: an **attendance
switch** in the app bar that turns green for present and red for absent, and a
**hamburger** that opens the side navigation. Below it sit the four numbers a
rider opens the app to check — today's earnings, incentive earned, rent due and
wallet balance — plus the incentive gap, the vehicle, quick actions and the
week's earnings.

The bottom bar has four destinations — Home, Scooter, Support, Wallet — with the
**vehicle power control raised into the middle**, overlapping the bar. It is not
a tab: it opens the ride sheet and never changes the page under it.

### Fleet Manager

Sign in, then land on the hub dashboard: utilisation, a fleet status band,
pending allocations and returns, open maintenance and the charging bays.

The bottom bar has three destinations — Hub, Allocations, Maintenance — with a
raised scan control in the middle.

Allocation runs as a JSON-driven flow: vendor mapping, then the photo set (left,
right, front, back, vehicle with rider, IoT, battery, accessories), then IoT
pairing, battery assignment and the accessory checklist. De-allocation mirrors
it: return photos, condition assessment, then two-party verification with an OTP
from the rider and an OTP from the team lead, ending in a fleet status update.

## Architecture

Clean architecture, one folder per feature:

```
lib/features/<feature>/
├── domain/          entities, repository interface, use cases   (no Flutter)
├── data/            repository implementation, JSON → entity mapping
└── presentation/    cubit, pages, screen-local widgets
```

- Repositories return `Result<T>` — `Ok` or `Err` with a typed `Failure`. They
  never throw across the layer boundary.
- `lib/app/di/injector.dart` is the only place dependencies are wired.
- `go_router` handles all navigation. Paths live in `lib/app/router/app_routes.dart`;
  nothing hardcodes a path string.
- Tabs use `StatefulShellRoute`, so each destination keeps its own back stack.

## Server-driven screens

Onboarding, allocation and de-allocation are not hardcoded. Each is a JSON
document parsed into `UiFlowConfig` → `UiScreenConfig` → a tree of `UiNode`, and
rendered by `WidgetRegistry`, which maps a node's `type` string onto a Flutter
builder.

A node looks like this:

```jsonc
{
  "type": "textField",
  "id": "aadhaarNumber",
  "props": { "key": "aadhaarNumber", "label": "Aadhaar number", "keyboard": "number" },
  "visibleWhen": { "flag": "AADHAAR_VERIFICATION" },
  "validations": [{ "type": "required" }, { "type": "aadhaar" }]
}
```

**What this buys you.** Showing, hiding, reordering or adding a component is a
change to the document, not to the app. `visibleWhen` reads the client's package
feature flags and the live form values, so a client who does not use PAN
verification simply never sees the field, its validation or the step it sits in.
Validation travels with the document too, so a hidden field can never block a
submission.

The registry degrades rather than crashes: a document referencing a component
this build does not know renders an inert placeholder, so an old app version
stays usable against a newer document.

Register app-specific components alongside the built-ins:

```dart
registerDefaultWidgets();
WidgetRegistry.instance.register('walletLedger', (context, node, scope) => …);
```

### The component vocabulary

Layout `column` `row` `wrap` `stack` `grid` `expanded` `spacer` `gap` `divider`
`card` `accentCard` `section` `group`

Content `text` `heading` `icon` `image` `illustration` `banner` `chip` `statCard`
`heroStat` `keyValue` `navTile` `progress` `ringGauge` `emptyState` `bulletList`
`termsBlock` `primaryButton` `secondaryButton` `ghostButton`

Input `textField` `pickerField` `dateField` `checkbox` `switchTile` `radioGroup`
`otpField` `upload` `photoGrid`

Conditions support `flag`, `notFlag`, field comparisons (`equals`, `notEquals`,
`oneOf`, `gte`, `lte`, `isNotEmpty`) and the combinators `allOf`, `anyOf`, `not`.

Validators: `required` `minLength` `maxLength` `pattern` `email` `mobile`
`aadhaar` `pan` `ifsc` `upi` `minAge` `match` `min` `max`.

## Mock data

Every screen reads bundled JSON through `UiConfigService`, which resolves a name
to `assets/config/<name>.json`. Swapping in a real API is a change to that one
class — everything above it only ever sees parsed models.

**rider_app/assets/config/** — `package_features` (the feature flags),
`rider_profile`, `intro_slides`, `onboarding_flow`, `pdi_checklist`,
`home_layout`, `home_data`, `scooter_data`, `wallet_data`, `support_data`,
`attendance_data`, `notifications_data`, `legal_content`

**fleet_manager_app/assets/config/** — `package_features`, `manager_profile`,
`hub_data`, `allocation_data`, `maintenance_data`, `allocation_flow`,
`deallocation_flow`

Turning a feature off is a one-line edit. Set `"PAN_VERIFICATION": false` in
`package_features.json`, restart, and the PAN field, its upload and its
validation are gone from onboarding.

## Design system

One theme, two apps. **Light and quiet, with one confident block of colour**:
a pale grey page, white cards that separate by elevation, and ink carrying the
hierarchy. Brand colour appears in two places and no others — the header band
at the top of a screen, and the one primary action, status or number worth
noticing. There are no page gradients, no glows and no glass.

| Token | Use |
| --- | --- |
| `canvas` / `surface` | the page (pale grey) and its cards (white) |
| `surfaceMuted` / `surfaceSunken` | quiet fills: inputs, inactive segments |
| `stroke` / `strokeStrong` | hairlines, and borders meant to be seen |
| `primary` | the brand purple; the single filled action per screen |
| `mint` | money and success |
| `warning` | incentives and deadlines |
| `danger` | destructive actions and alerts |

`AppColors.washFor(tone)` returns the pale partner of any status colour, for
chip fills and banner grounds. **There are no gradients** — every surface is a
flat fill, including the header band and the logo mark. The only sweeps left are
the loading shimmer and the scan screen's laser, both of which are animation.

Type is Sora for display and numbers, Manrope for text, both bundled as static
instances so nothing is fetched at runtime. Sora has no rupee sign, so every
Sora style falls back to Manrope — otherwise `₹` would come from whatever face
the OS happened to pick.

`evseye_core` ships the full component set — `AppScaffold`, `GlassCard`,
`PrimaryButton`, `AppTextField`, `OtpInput`, `StatCard`, `RingGauge`,
`StepProgress`, `PhotoSlot`, `AttendanceToggle`, `AppSheet`, `AppDialog` and the
rest. Screens compose these; they do not define their own colours or text
styles.

## Assets

`app_logo.png` is the launcher icon on both platforms, `splash_screen.png` is
the splash — shown edge to edge and uncropped, on the native launch screen and
on the Dart one, so there is no visible hand-off between them. Regenerate after
replacing either:

```bash
cd <app_dir>
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Tests

```bash
cd evseye_core        && flutter test                          # 17 — the engine
cd rider_app          && flutter test --exclude-tags screenshots  # 52
cd fleet_manager_app  && flutter test --exclude-tags screenshots  # 51
```

Each app also carries an **overflow suite** that pumps every screen at
320x568 and 430x932 and fails on any `RenderFlex` overflow. It found 18 real
layout breaks on the rider side alone, which is why it exists: a dense row of
chips, a long vehicle number or a large rupee amount breaks on a small phone
long before anyone notices on a simulator.

### Reviewing the UI

```bash
cd rider_app && flutter test test/screenshot_test.dart --dart-define=OUT=build/screens
```

Renders every screen to a PNG so the whole app can be reviewed in one pass.
Tagged `screenshots`, so it is excluded from the normal run.

`evseye_core` covers condition evaluation, the validators, visible-only form
validation, feature-flag parsing, document parsing, and that the registry hides
gated nodes and survives an unknown component type.

The two app suites run against the **real bundled JSON**, not fixtures, so a bad
edit to `assets/config/*.json` fails the build rather than the app. They assert
that every component type a document names is registered, that the flows have
the steps the spec describes, and — concretely — that turning
`PAN_VERIFICATION` off removes the field *and* stops it blocking submission,
that dropping `TEAM_LEAD_OTP` leaves only the rider's OTP, and that the damage
fields appear only once a vehicle is marked damaged and leave no stale errors
behind when it is marked good again.

## Checks

```bash
cd evseye_core && flutter analyze
cd rider_app && flutter analyze
cd fleet_manager_app && flutter analyze
```
