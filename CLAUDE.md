@AGENTS.md

## Claude Code

Everything tool-neutral lives in `AGENTS.md` (imported above). Keep it that way: only add
things here that are specific to Claude Code, and put any new project rule in `AGENTS.md`
so other agents and human contributors pick it up too.

### Tooling in this checkout

- Use the plain `flutter` / `dart` commands in `AGENTS.md`. They are what CI runs and
  what a contributor will have. If this checkout happens to carry a local fvm pin
  (`.fvmrc` is gitignored, so it may or may not) prefix with `fvm`. Do not add one,
  and do not tell anyone they need fvm to work on this repo.
- `flutter run` in any `<package>/example/` is long-running. Ask before starting it
  and don't leave it running in the background. The same goes for the desktop and
  iOS example builds, which take minutes.
- There are seven packages, so `cd` into the right one first. A bare `flutter test`
  at the repo root does nothing useful.

### Working style

- Prefer the file tools (Read / Edit / Grep / Glob) over `cat`/`sed`/`grep` in Bash for
  reading and editing repo files.
- Use the `Explore` subagent for questions that span the Dart, Java, Objective-C and
  C++ sides at once. For anything inside one package, a targeted `Grep` is faster.
- After changing `geolocator_platform_interface/lib/`, grep every implementation and
  `geolocator_windows/windows/` before calling it done. The interface analyzes clean
  on its own while an implementation is broken.
- Run `/code-review` on the diff before handing work over, and `/security-review` when
  a change touches permission or location data handling: the permission handlers in
  `geolocator_android/android/src/main/java/com/baseflow/geolocator/permission/` and
  `geolocator_apple/darwin/`, or the background location service in
  `geolocator_android`.

### Commits and PRs

- Follow the PR workflow in `AGENTS.md`, and check the user's access before the
  first push (`gh api repos/Baseflow/flutter-geolocator --jq .permissions.admin`).
  For a repository admin, push branches straight to `Baseflow/flutter-geolocator`
  and open the PR from there. Do not use or create a fork. For anyone else, push to
  their fork and never to a `Baseflow` branch. Never push to `main`. Target `main`.
- Never run `dart pub publish`, dry run or otherwise, and never push a release tag,
  unless the user asked for that release in this session.
- End commit messages with:

  ```
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

- End PR descriptions with:

  ```
  🤖 Generated with [Claude Code](https://claude.com/claude-code)
  ```
