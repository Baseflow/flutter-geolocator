# flutter-geolocator agent instructions

Technical reference for AI agents and contributors developing in this repository.

Process and conduct live in their own files: contribution workflow in
[CONTRIBUTING.md](CONTRIBUTING.md), the [Contributor Covenant Code of
Conduct](CODE_OF_CONDUCT.md) (report unacceptable behavior to
[hello@baseflow.com](mailto:hello@baseflow.com)).

## Scope and stack

- This repo is the **geolocator federated plugin** monorepo maintained by
  [Baseflow](https://baseflow.com).
- It contains seven published packages: an app-facing package, a platform
  interface and five platform implementations. Work inside the **specific
  package** you are changing. There is no Melos, no root `pubspec.yaml` and no
  root `analysis_options.yaml`, and none should be added unless the team decides
  to. Every command below needs a `cd` into a package first.
- Run Flutter and Dart commands with the same tooling CI uses (`flutter`, `dart`).
  Nothing in this repo requires anything else. If you happen to manage SDK
  versions locally with [fvm](https://fvm.app), prefix commands with `fvm`; that
  is a personal setup choice and is never checked in.

### Prerequisites

- Basic Dart and Flutter knowledge, and some familiarity with the platform you
  are changing
- A working Flutter SDK installation, stable channel. **No workflow pins a
  version.** Every workflow installs Flutter with `subosito/flutter-action` at
  `channel: 'stable'`, so CI runs whatever stable resolves to on the day. The
  committed floor is the pubspec constraint: `sdk: ^3.5.0` in every package, with
  Flutter floors that differ per package.
- For `geolocator_apple` and the app-facing iOS build, access to a Mac
- Android builds require JDK 17
- Chrome, to run the web package's tests locally
- Linux and Windows builds need that desktop OS

### Reference documentation

- [Developing packages & plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages),
  in particular the [federated plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins) section
- [Writing platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels)
- [Platform interface breaking changes](https://flutter.dev/go/platform-interface-breaking-changes)
- [Effective Dart](https://dart.dev/effective-dart)
- [pub versioning philosophy](https://dart.dev/tools/pub/versioning)

## Packages in this repo

| Package | Role | Native code |
|---|---|---|
| `geolocator` | App-facing API: `Geolocator` static methods delegating to `GeolocatorPlatform.instance` | none |
| `geolocator_platform_interface` | Shared contract, models, errors and the default `MethodChannelGeolocator` | none |
| `geolocator_android` | Android implementation, `GeolocatorAndroid` | Java |
| `geolocator_apple` | iOS and macOS implementation, `GeolocatorApple` | Objective-C, one shared `darwin/` tree |
| `geolocator_web` | Web implementation over the browser Geolocation API | none |
| `geolocator_linux` | Linux implementation over GeoClue on D-Bus, with a GNOME variant | none |
| `geolocator_windows` | Windows implementation | C++ (WinRT), no Dart library |

## Architecture overview

This is an **endorsed federated plugin**. Apps depend only on `geolocator`; its
`pubspec.yaml` depends on every implementation and names it as the
`default_package` for its platform, so consumers get them automatically.

```
App → Geolocator.* → GeolocatorPlatform.instance → platform package → native or Dart implementation
```

- Each implementation declares `implements: geolocator` in its `pubspec.yaml`
  and registers itself through `registerWith()`, for example
  `GeolocatorPlatform.instance = GeolocatorAndroid();`.
- Implementations **extend** `GeolocatorPlatform`. They never `implement` it:
  the `instance` setter calls `PlatformInterface.verify`, which rejects an
  implementing class, and `extends` is what lets the interface add methods
  without breaking existing implementations.
- `geolocator_apple` sets `sharedDarwinSource: true`, so iOS and macOS build
  from the same `darwin/` sources.
- `geolocator_windows` is the outlier. It has no Dart class; its C++ plugin
  answers the default `MethodChannelGeolocator` from the platform interface on
  the unsuffixed legacy channel names.

### Method channels

Every native platform uses three channels under the `flutter.baseflow.com/`
namespace: a `MethodChannel` for calls, an `EventChannel` for the position
stream and an `EventChannel` for location service status.

| Platform | Method | Position updates | Service status |
|---|---|---|---|
| Android | `geolocator_android` | `geolocator_updates_android` | `geolocator_service_updates_android` |
| Apple | `geolocator_apple` | `geolocator_updates_apple` | `geolocator_service_updates_apple` |
| Windows (default) | `geolocator` | `geolocator_updates` | `geolocator_service_updates` |

Native errors arrive as `PlatformException` and are mapped to the typed
exceptions in `geolocator_platform_interface/lib/src/errors/` by their `code`,
for example `PERMISSION_DENIED`.

## Authoritative project structure

- Root overview: `README.md`
- Contribution workflow: `CONTRIBUTING.md`
- App-facing API: `geolocator/lib/geolocator.dart`
- Platform contract: `geolocator_platform_interface/lib/geolocator_platform_interface.dart`
- Default channel client: `geolocator_platform_interface/lib/src/implementations/method_channel_geolocator.dart`
- Dart implementations: `geolocator_<platform>/lib/`
- Native entry points:
  - Android: `geolocator_android/android/src/main/java/com/baseflow/geolocator/GeolocatorPlugin.java`
  - Apple: `geolocator_apple/darwin/geolocator_apple/Sources/geolocator_apple/GeolocatorPlugin.m`
  - Windows: `geolocator_windows/windows/geolocator_plugin.cpp`
- Example apps: `<package>/example/`, in every package except the platform interface
- CI: `.github/workflows/<package>.yaml`, one per package

### CI map

Every workflow runs on pushes and pull requests to `main`, filtered to its own
package directory and its own workflow file. A change to root files such as this
one starts no workflow.

| Workflow | Runner | Format, analyze | Example build | Unit tests |
|---|---|---|---|---|
| `geolocator.yaml` | macOS | yes | apk, iOS | `flutter test --coverage` |
| `geolocator_platform_interface.yaml` | Ubuntu | yes | none | `flutter test --coverage` |
| `geolocator_android.yaml` | Ubuntu | yes | apk | **not run** |
| `geolocator_apple.yaml` | macOS | yes | iOS | **not run** |
| `geolocator_web.yaml` | Ubuntu | yes | web | `flutter test --platform chrome` |
| `geolocator_linux.yaml` | Ubuntu | yes | Linux | `flutter test --coverage` |
| `geolocator_windows.yaml` | Windows | yes | Windows | none exist |

Android and Apple have tests that CI does not run, so run them yourself (see
[Testing expectations](#testing-expectations)). No workflow publishes.

## Where to make changes

- **Public API and docs for app developers** → `geolocator/lib/` and its README
- **Cross-platform contract** → `geolocator_platform_interface/lib/`. Prefer
  additive changes: add methods, do not change signatures.
- **Platform behavior** → the matching `geolocator_<platform>` package only
- **Platform-only settings** such as `AndroidSettings` and `AppleSettings` live
  in their platform package and are re-exported from `geolocator` when app
  developers need them.
- **Never** put platform-specific logic in `geolocator` beyond re-exports and
  thin delegation.

Adding an API to `Geolocator` touches several packages in order: the method on
`GeolocatorPlatform`, then the default `MethodChannelGeolocator`, then each
implementation, then the app-facing facade. Each package is its own pull request
and its own release, and the app-facing constraint on the interface has to be
raised before the facade can use the new method.

Traps:

- **Channel names are wire protocol.** Renaming one breaks every app whose
  native side is a different version. Do not change them without a major version
  and a migration plan.
- **Windows has no Dart side.** A change to `MethodChannelGeolocator` changes
  what the Windows plugin receives, so check `geolocator_plugin.cpp` too.
- **Web cannot do everything.** `getLastKnownPosition` throws
  `UnsupportedError`, and `isLocationServiceEnabled()` always returns `true`.
  Do not paper over that in the facade.

## Development setup

Per [CONTRIBUTING.md](CONTRIBUTING.md) and Baseflow's open-source forking workflow:

1. Fork `https://github.com/Baseflow/flutter-geolocator` on GitHub.
2. Clone your fork: `git clone git@github.com:<your_name>/flutter-geolocator.git`
3. Add upstream (the official repo you fetch from, not your fork):

```bash
git remote add upstream git@github.com:Baseflow/flutter-geolocator.git
```

4. Branch from the latest `main`:

```bash
git fetch upstream
git checkout upstream/main -b <name_of_your_branch>
```

Expected remotes after setup:

```
origin    git@github.com:<your_name>/flutter-geolocator.git   # your fork (push here)
upstream  git@github.com:Baseflow/flutter-geolocator.git      # official repo (fetch here)
```

Repository admins skip the fork: clone `Baseflow/flutter-geolocator` directly
and branch from `origin/main`.

## Commands

Run from the package you are editing:

```bash
cd geolocator_android   # or any other package
flutter pub get
dart format .
flutter analyze
flutter test            # flutter test --platform chrome for geolocator_web
```

CI runs the same commands with stricter flags:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
```

Build or run an example from `<package>/example/`:

```bash
cd geolocator/example
flutter run
```

Before finishing work, run what CI runs for the package you changed, including
its example build where your platform allows it.

## Testing expectations

| Package | Tests |
|---|---|
| `geolocator`, `geolocator_platform_interface` | Dart unit tests under `test/` |
| `geolocator_android` | Dart tests under `test/`, and JUnit tests under `android/src/test/`. CI runs neither. |
| `geolocator_apple` | Dart tests under `test/`, and XCTest under `example/ios/RunnerTests/`. CI runs neither. |
| `geolocator_web` | Dart tests, run in Chrome |
| `geolocator_linux` | Dart tests with generated mocks (`*.mocks.dart`) |
| `geolocator_windows` | No tests. Verify through the example build. |

Mock the channels with the helpers each package already has
(`MethodChannelMock`, `EventChannelMock`) rather than writing new ones. When a
test file has a generated `.mocks.dart` companion, regenerate it rather than
editing it by hand.

## Platform notes

- **Android**: picks between `FusedLocationClient` (Google Play services) and
  `LocationManagerClient`, and runs a foreground service for background
  location.
- **Apple**: the plugin splits into handlers for geolocation, permission,
  accuracy and streams. Test hooks are exposed through `GeolocatorPlugin_Test.h`.
- **Linux**: chooses the GNOME implementation when `XDG_CURRENT_DESKTOP`
  contains `GNOME` or `GNOME_SHELL_SESSION_MODE` is set, and GeoClue otherwise.
- **Windows**: WinRT, asynchronous. Rebuild the native side after any C++ change.

## Pull request workflow

**`main` is the branch of record.** Branch from the latest `main`, open every
pull request against `main`, and rebase onto `main` before submitting. Every
workflow builds `main` only, so a pull request against anything else gets no CI.
`master` is a leftover from an earlier branch layout, years behind `main`: it is
not maintained and must not be branched from or targeted. Pull requests are
squash merged, so each one becomes a single commit on `main`.

This repo uses the **forking workflow** for everyone who is not a repository
admin: contributors work on their own fork and open pull requests to the main
repository, and must not push branches to `Baseflow/flutter-geolocator`.
Repository admins push their branches straight to `Baseflow/flutter-geolocator`
and open pull requests from there. Either way, every change reaches `main`
through a reviewed pull request; nobody pushes to `main` directly.

1. Apply changes on a branch based on `main`, scoped to one package.
2. Bump that package's `version:` in `pubspec.yaml` following semver, and add a
   matching `CHANGELOG.md` entry (format: see [Releases](#releases)).
3. Verify locally, from the package you changed: `dart format .`,
   `flutter analyze`, `flutter test`.
4. Push the branch and open a pull request against `main` on
   `Baseflow/flutter-geolocator`, filling out the full
   [PR template](.github/PULL_REQUEST_TEMPLATE.md).

Docs-only and CI-only pull requests, such as changes to this file,
`CONTRIBUTING.md` or `.github/`, do not bump a version and add no changelog
entry.

Keep public API changes additive and non-breaking where possible. A breaking
change needs a major version and a README and changelog callout. For the
platform interface, follow the Flutter guidance on
[platform interface breaking changes](https://flutter.dev/go/platform-interface-breaking-changes).

### PR description style

The [PR template](.github/PULL_REQUEST_TEMPLATE.md) has no headings: it opens
with a free-text description of the change and the issue it fixes, followed by
`## Pre-launch Checklist`. Keep that structure.

- State what changed and why. Don't narrate your own editing process, and don't
  explain why one obvious, in-scope edit was made alongside another.
- Don't repeat file paths in prose; the diff already shows them.
- Link at least one fixed issue, as the template asks.
- Tick only what you actually did. If something was left to CI, say so in the
  description and leave the box unticked.

### PR checklist

The template's Pre-launch Checklist, verbatim:

- [ ] I made sure the project builds.
- [ ] I read the Contributor Guide and followed the process outlined there for submitting PRs.
- [ ] I updated `pubspec.yaml` with an appropriate new version according to the pub versioning philosophy, or this PR is does not need version changes.
- [ ] I updated `CHANGELOG.md` to add a description of the change.
- [ ] I updated/added relevant documentation (doc comments with `///`).
- [ ] I rebased onto `main`.
- [ ] I added new tests to check the change I am making, or this PR does not need tests.
- [ ] I made sure all existing and new tests are passing.
- [ ] I ran `dart format .` and committed any changes.
- [ ] I ran `flutter analyze` and fixed any errors.

And for this repo specifically:

- [ ] This PR changes exactly one package
- [ ] No channel name changed
- [ ] For `geolocator_android` or `geolocator_apple`, the native tests that CI
      skips were run locally

## Releases

Each package is versioned and released independently. Only maintainers cut
releases.

**No workflow publishes.** A release is published to pub.dev by a maintainer, and
the release commit on `main` is tagged `<package>_v<version>`, for example
`geolocator_v14.1.2` or `geolocator_apple_v2.4.3`. Every merged pull request
already bumped its own package's version and added its changelog entry, so there
is no separate release-prep pull request.

When a release depends on a sibling's new version (an implementation using a new
platform interface method, or the app-facing package using a new implementation),
publish the dependency first and raise the constraint in a pull request before
releasing the dependent package.

`CHANGELOG.md` uses `## x.y.z` headings with no date and a flat list of `-`
bullets, newest first, with no `## [Unreleased]` section. Match that format.
Introducing a different one is a separate decision, not part of an unrelated
change.

Published versions are immutable, so keep branch names out of URLs in
`pubspec.yaml` and in docs: a branch-specific link becomes a permanent dead link
once that branch is gone.
