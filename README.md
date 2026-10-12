# EVSEYE

White-label rider and fleet manager apps in one melos monorepo.

```
apps/rider_app              rider app
apps/fleet_manager_app      fleet manager app
packages/evseye_core        shared code
packages/evseye_flavors     flavor tool and the original illustrations
flavors/<client>/           branding for each client
```

## Setup

```bash
dart pub global activate melos
melos bootstrap
melos run flavor pinkrides
```

The last step generates the client files (icons, splash, colours, package IDs).
They are not in git, so apply a client once after cloning.

The rider app needs a Google Maps key in `apps/rider_app/.env` (see `.env.example`).

Scripts: `melos run get`, `analyze`, `format`, `l10n`, `flavor <client>`.

## Run and build

Go to the app first:

```bash
cd apps/rider_app
```

```bash
cd apps/fleet_manager_app
```

Run on a device or simulator:

```bash
flutter run
```

Android APK, saved to `build/app/outputs/flutter-apk/app-release.apk`:

```bash
flutter build apk --release
```

Android App Bundle for the Play Store, saved to `build/app/outputs/bundle/release/app-release.aab`:

```bash
flutter build appbundle --release
```

iOS IPA for the App Store and TestFlight, saved to `build/ios/ipa/`:

```bash
flutter build ipa --release
```

By default the apps call `http://localhost:3000/api/v1`. For a real server, add
the URL to the command:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://<server>/api/v1
```

The client code comes from the applied flavor.

## Flavors

Clients: `pinkrides` (default), `whizz`, `trueevs`.

From either app folder (it switches both apps):

```bash
dart run evseye_flavors --flavor whizz
```

Then stop and re-run the apps. Hot reload won't change the name, icon or splash.
From the repo root, `melos run flavor whizz` does the same.

```
flavors/<client>/
├── flavor.yaml     client code, app names, package IDs, versions, colours
├── banner.png      first two intro slides, login and OTP
├── rider/          app_icon.png, app_icon_foreground.png (1024×1024)
└── fleet/          the same two icons
```

The illustrations are recoloured to the client's `primary` colour automatically.
Each client has its own package ID and version, so clients install as separate
apps. Bump `version` in `flavor.yaml` before each release.

### Add a client

```bash
cp -R flavors/whizz flavors/acme
```

Swap in the client's images, edit `flavor.yaml`, then run `dart run evseye_flavors --flavor acme`.
