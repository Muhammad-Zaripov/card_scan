## udevs_initial_project

## Table of Contents
- [Project overview](#project-overview)
- [Tech stack](#tech-stack)
- [Folder structure](#folder-structure)
- [How the app works](#How the app works)
- [Architecture rules](#architecture-rules)
- [State management rules](#state-management-rules)
- [Elixir + BLoC pattern](#elixir--bloc-pass-only-state-between-pages)
- [How to run locally](#how-to-run-locally) 

### Project overview
Flutter mobile app (Android/iOS) — Melos workspace.
Runtime config is provided via `--dart-define` / `--dart-define-from-file` (`config/*.json`).
App-wide dependencies are created during startup and injected via `DependenciesScope`.

### Tech stack
- **State management**: `flutter_bloc`, `equatable` — BLoC pattern va value equality.
- **DI / app composition**: `DependenciesScope`, `SettingsScope` — InheritedWidget orqali dependency injection va app settings.
- **Navigation**: `elixir` — type-safe navigation pages.
- **Networking**: `dio` (exported), `thunder` — HTTP client va custom networking layer.
- **Persistence**: `drift`/`drift_flutter` (local DB), `shared_preferences` + `encrypt` (key-value storage with encryption).
- **Firebase**: `firebase_messaging`, `firebase_remote_config` — push notifications and remote config.
- **Localization**: `flutter_localizations`, `intl`, `flutter_intl` — i18n and localization codegen.
- **Code generation**: `build_runner`, `flutter_gen_runner`, `pubspec_generator`, `drift_dev` — automate code generation.
- **Workspace tooling**: `melos`, `make` — manage multi-package workspace and scripts.

### Folder structure

```text
assets/
android/
config/
ios/
lib/
  src/
    common/
    feature/
package/
  database/
  local_source/
test/
tools/
```

### How the app works 

1. **Entrypoint**: `lib/main.dart`
   - Boots the app inside a `DependenciesScope`
   - Wraps UI with `SettingsScope`

2. **Initialization (DI)**: `lib/src/common/dependencies/initialization/`
   - Creates app-wide dependencies (DB, LocalSource, Dio, SettingsBloc)
   - Access via `DependenciesScope.of(context)` or `context.dependencies`

3. **Navigation**: `lib/src/common/router/routes.dart`
   - Use `context.push(...)` to move between `ElixirPage`

4. **Runtime config**: `config/*.json` loaded via `--dart-define-from-file`
   - Non-production builds can show **App Configuration** screen to override `API_BASE_URL`

### Architecture rules 
  - Keep shared code in `lib/src/common/`; keep feature code in `lib/src/feature/<feature>/`.
  - Build app-wide dependencies in `lib/src/common/dependencies/initialization/` and inject them via `DependenciesScope`.
  - Access app dependencies via `context.dependencies` / `DependenciesScope.of(context)` (see `lib/src/common/extension/context_extension.dart`).
  - Define navigation pages in `lib/src/common/router/` as `ElixirPage` implementations.
  - Provide runtime config through `Config` (`lib/src/common/constant/config.dart`) using `--dart-define*` and/or `config/*.json`.
  - Keep formatting at 120 columns (`analysis_options.yaml` / `make format` / `melos run format`).

### State management rules 
  - Use `flutter_bloc` for app state (example: `SettingsBloc`).
  - Expose app settings via `SettingsScope` and read them via `SettingsScope.settingsOf(context)`.
  - Provide existing BLoC instances with `BlocProvider.value` only when the instance comes from DI (`context.dependencies`).
  - For feature/page-scoped BLoCs, create them inside the corresponding `ElixirPage` (router) via `BlocProvider(create: ...)` and pass
    an optional initial state via the page constructor.
  - Use `DroppableCubit` for drop-while-busy flows and `SequentialCubit` for queued async flows when writing new Cubits.
 

### 🧭 Elixir + 🧠 BLoC: pass only **State** between pages (our pattern)

> ✅ In our project, we **do not carry BLoC instances** from page to page.  
> ✅ We only pass **State**, and the next page creates a new BLoC and uses that state as the **initialState**.


#### 🧩 Example: `BlocProvider(create: ...)` + `initialState` inside an `ElixirPage`

```dart
final class HomePage extends AppPage {
  HomePage({HomeState? state})
      : super(
          name: 'home',
          child: BlocProvider(
            create: (context) => HomeBloc(initialState: state),
            child: const HomeScreen(),
          ),
        );
}
```

#### 🧱 Example: accept `initialState` in the BLoC constructor

```dart
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeState? initialState}) : super(initialState ?? const HomeState()) {
    // on<Event>((event, emit) { ... });
  }
}
```

#### 🚀 Example: Elixir navigation (`context.push`)

Source: `NavigatorX` in [`lib/src/common/extension/context_extension.dart`](lib/src/common/extension/context_extension.dart)

```dart
context.push(SettingsPage(data: 'from_home'));
```

#### 🔁 Example: pass state to the next page (template)

```dart
final state = context.read<HomeBloc>().state;
context.push(HomePage(state: state));  
```
 

### How to run locally

```bash
# Workspace bootstrap (links local packages)
make get

# Codegen + format (flutter_gen, l10n, build_runner)
make gen

# Run (Android example)
flutter run --dart-define-from-file=config/development.json --dart-define=config.platform=android

# Run (iOS example)
flutter run --dart-define-from-file=config/development.json --dart-define=config.platform=ios
```

