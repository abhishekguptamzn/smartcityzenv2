# Smart Cityzen Flutter App — Handoff Context

## Project location
Flutter app: `/Users/abhishekgupta/Documents/flutters/smartcityzenv1/smartcityzenv2`
Laravel API (read-only reference, do not modify unless asked): `/Users/abhishekgupta/Documents/LARAVELS/smart-citizen-api-v1`
Design mockups: `/Users/abhishekgupta/Downloads/stitch_smart_cityzen_digital_hub/`

## What this is
A Flutter app (Android + responsive Web, single codebase) for citizens ("customer" role) of a Laravel-backed civic services platform ("Smart Cityzen"): browse libraries/gyms, view memberships, view payments, gym check-in, profile/security, all wired to a real REST API. Design system: "Luminous Urbanity v2" (glassmorphism, indigo `#000314` + cyan `#00E3FD`, Sora+Inter fonts, see `luminous_urbanity_2/DESIGN.md` for full token list).

## Toolchain gotchas already solved (do not re-break these)
1. `flutter_form_builder` MUST be `^10.3.0`+, not `9.x` — 9.x's intl constraint conflicts with `flutter_localizations` from the SDK.
2. `custom_lint`/`riverpod_lint` were REMOVED from dev_dependencies entirely — their old versions pulled an `analyzer_plugin` incompatible with the `analyzer` version resolved by `build_runner`/`json_serializable`, causing the generated build script itself to fail to compile. Do not re-add them unless you also verify `dart run build_runner build` still succeeds afterward.
3. Riverpod stack was upgraded to **3.x** (`flutter_riverpod ^3.0.0`, `riverpod_annotation ^3.0.0`, `riverpod_generator ^3.0.0`), and **freezed to 3.x** (`freezed_annotation ^3.0.0`, `freezed ^3.0.0`) together — riverpod_generator 3.x requires a newer `build`/`riverpod_analyzer_utils`/`custom_lint_core` chain that IS compatible with the resolved analyzer, which is what actually fixed the build-script compile failure from point 2.
4. **CRITICAL freezed 3.x syntax change**: every `@freezed` class MUST be declared `abstract class X with _$X` — plain `class X with _$X` (freezed 2.x style) compiles the mixin fine but the concrete class silently fails to implement it, producing `non_abstract_class_inherits_abstract_member` errors for every field. All 12 model files were fixed with this pattern; keep it for every new model.
5. `analysis_options.yaml` has `analyzer.errors.invalid_annotation_target: ignore` — this is required because `@JsonKey(name: '...')` on constructor parameters in freezed classes triggers a known, harmless analyzer false-positive (see comment in the file). Do not remove this suppression; it is not hiding a real bug.
6. `l10n.yaml` must NOT include `synthetic-package: false` — that option was removed in this Flutter version and causes a warning (harmless but noisy); it's already omitted, keep it that way.
7. Toolchain fully verified end-to-end as of this note: `flutter pub get`, `flutter gen-l10n`, `dart run build_runner build --delete-conflicting-outputs`, and `flutter analyze` all pass with **zero issues**. If any of these break after adding new files, bisect against this known-good state rather than assuming a new fundamental incompatibility — it's more likely a missed `abstract class` or a genuine typo.

## Already done (verified working)
- `pubspec.yaml` fully configured with correct compatible versions (see gotchas above for the exact riverpod/freezed/form_builder versions that matter): flutter_riverpod 3.x+riverpod_annotation 3.x+riverpod_generator 3.x, go_router 15.x, dio+pretty_dio_logger+connectivity_plus, freezed 3.x+json_serializable, flutter_secure_storage+shared_preferences, flutter_form_builder 10.x+form_builder_validators, google_sign_in, flutter_facebook_auth, google_fonts, qr_flutter, url_launcher, uuid, logger, package_info_plus. Confirmed `flutter pub get` resolves clean.
- `l10n.yaml` configured (arb-dir lib/l10n, output-dir lib/l10n/gen, output-class AppLocalizations).
- `lib/l10n/app_{en,hi,es,fr,ar}.arb` — full string sets including auth, dashboard, facilities, membership, payments, profile, security, errors, AND settings/network-config keys (apiBaseUrl, testConnection, connectionSuccessful, etc.) — all 5 locales have real (not copy-pasted) translations. Confirmed `flutter gen-l10n` generates clean into `lib/l10n/gen/`.
- `lib/core/theme/app_colors.dart` — ThemeExtension<AppColors> with the full Luminous Urbanity v2 token set.
- `lib/core/theme/app_theme.dart` — AppTheme.light/dark ThemeData.
- `lib/shared/widgets/glass_container.dart` — reusable glassmorphic container (BackdropFilter+blur+translucent border).
- `lib/data/models/*.dart` — ALL freezed+json_serializable models done: city_model, facility_exception_model, facility_member_model, facility_model, fee_plan_model, gym_attendance_model, login_history_model, membership_renewal_model, payment_model, user_model, api_error, pagination_meta (incl. hand-written generic `Paginated<T>` wrapper in the same file).
- `lib/core/config/app_config.dart` — `AppConfig` value class + `AppConfigController` (`@Riverpod(keepAlive: true)`), shared_preferences-backed, dart-define/platform-detected as first-run-only seed, with `updateApiBaseUrl`/`updateTimeouts`/`updateRequestLogging`/`resetToDefaults` methods.
- Xcode license accepted; `flutter --version` / `flutter doctor` work. Flutter 3.44.9, Dart 3.12.2. Chrome web target works. Android SDK NOT configured on this machine (`flutter doctor` flags missing ANDROID_HOME toolchain) — code can still be written for Android, just can't `flutter run -d android` locally until SDK is installed; Chrome is the available verification target for now.
- **Full toolchain verified clean**: `flutter pub get` ✅, `flutter gen-l10n` ✅, `dart run build_runner build --delete-conflicting-outputs` ✅ (38 outputs, 0 errors), `flutter analyze` ✅ (**0 issues**).

## Not yet started
- `dart run build_runner build` has NOT been run yet on the models — `.freezed.dart`/`.g.dart` files don't exist yet, so nothing compiles yet.
- Config layer (`lib/core/config/app_config.dart` — runtime-editable settings backed by shared_preferences, NOT just compile-time `--dart-define`).
- Dio client + interceptors (auth token injection, redacted logging, error-code mapping to typed `AppException`).
- All API service classes (Auth, Cities, Users, Facilities, FacilityMembers, GymAttendance, Payments, Exceptions, Health) — full endpoint contract is documented below.
- All repositories, including the special "derive my memberships from payments" logic (see constraint below).
- Riverpod providers (auth controller, locale, theme mode, config, feature list/detail providers).
- go_router setup with auth guard + responsive shell (bottom nav <900px / sidebar ≥900px).
- ALL screens: splash, login/register, forgot/reset password, home dashboard, services explorer, facility detail, membership details+QR check-in, ID card, profile+edit, settings (new — runtime config UI), security (login history+change password+logout-all), payments+receipt, my exceptions.
- `lib/main.dart` rewrite to wire everything together (currently still boilerplate counter app, NOT yet touched).

## Critical API constraints (verified at the Laravel source-code level — do not build UI that assumes otherwise)
1. **No self-service membership join/renew.** `POST /libraries/{id}/members`, `POST /gyms/{id}/members`, and `.../renew` all require staff/manager/admin permission (`LibraryMemberPolicy::create`/`GymMemberPolicy::create` have no self-service branch). Customers CANNOT enroll or renew themselves via the API. UI must show a "Contact staff to join/renew" CTA (phone/email from facility record via url_launcher) instead of a fake self-submit form.
2. **No "list my memberships" endpoint.** `GET /libraries/{id}/members` (index) is permission-gated shut for customers; no self-scoping fallback exists server-side. The only legitimate way to discover a customer's own membership IDs is via `GET /payments` (which IS self-scoped server-side for member/customer role — `PaymentService.php:32-37` filters `where('user_id', actor.id)`), filtering `payable_type IN (LibraryMember, GymMember)` to recover `payable_id`. Build a `MyMembershipSummary` derived purely from payment records for the dashboard's "My Memberships" cards — do not try to build a full membership-resolution pipeline the API can't support; degrade gracefully to "contact staff for full details" if a full member record isn't resolvable.
3. **No notifications feature exists server-side at all** (confirmed by full repo grep — no model/table/route/push). Expiry reminders are email-only via a server cron. Do not build an in-app notifications inbox against this API.
4. **Invoices are email-only PDFs** — no download endpoint. Render an in-app "receipt" view from `PaymentModel` fields instead.
5. **Gym attendance `GET .../attendance` (index) and `.../attendance/today` are gate-open to customer role but NOT query-scoped to self** — do not use these for a "my attendance" UI (would leak all users' data or at minimum be architecturally wrong for a customer view). Use `.../attendance/members/{member_id}/attendance` and `.../attendance/{id}` instead — both are properly self-scoped.
6. **Facility-scoped exception lists are not self-scoped**; the global `GET /exceptions` IS self-scoped for member-tier roles. Use only the global endpoint for "My Discounts/Exceptions."
7. Library `membership_type` is a loose validated string (`standard|student|researcher|annual`); Gym's is a stricter set (`daily|monthly|quarterly|annual`) — do not share one Dart enum between both facility types; just use String.
8. All entity IDs are prefixed string IDs (`USR...`, `LIB...`, `GYM...`, `PAY...`, etc.) — always `String id`, never `int`.

## Exact API contract for customer-relevant endpoints
Base: `/api/v1` (health check only is unversioned: `/api/health`).
Auth: `Authorization: Bearer <sanctum-token>` header. All bodies JSON, snake_case keys.

**Envelope shapes:**
```
Success: { "success": true, "data": {...}|[...], "meta": { "message"?: string, "pagination"?: {total,count,per_page,current_page,total_pages,has_more_pages} }, "request_id": "uuid" }
Error:   { "success": false, "error": { "code": string, "message": string, "details": object }, "request_id": "uuid" }
```
Real error codes: `VALIDATION_ERROR`(422), `AUTHENTICATION_ERROR`(401), `AUTHORIZATION_ERROR`(403), `ACCOUNT_BLOCKED`(403), `ACCOUNT_INACTIVE`(403), `NOT_FOUND`(404), `METHOD_NOT_ALLOWED`(405), `CONFLICT`(409), `BAD_REQUEST`(400), `TOO_MANY_REQUESTS`(429), `INTERNAL_SERVER_ERROR`(500), fallback `HTTP_ERROR`.

**Rate limits:** `api` default 60/min (user id or IP); `auth.login` 5/min (email+ip, applies to login + all oauth login/callback); `auth.register` 10/min (IP); `auth.password` 5/min (IP, applies to forgot/reset/change-password).

**Enums:** UserRole: admin/manager/staff/member/customer/user (self-register always → customer). UserStatus: active/inactive/blocked. FacilityStatus: active/inactive/maintenance. MembershipStatus: active/inactive/expired/suspended. PaymentStatus: paid/pending/failed/refunded. PaymentMethod: card/upi/bank_transfer/cash/wallet. PayableType: Gym/Library/GymMember/LibraryMember/User. FeeInterval: hour/day/week/month/year. ExceptionType: fee_waiver/grace_period/membership_freeze/attendance_override/custom_discount. ExceptionStatus: active/revoked/expired. LoginStatus: success/failed/blocked.

**Customer-usable endpoints (method, path, notes):**
- POST `/auth/register` {name*,email*,phone?,city_id*,password*,password_confirmation*} → {token,token_type,user}
- POST `/auth/login` {email*,password*} → {token,token_type,user}
- POST `/auth/oauth/{provider}` {provider*(google|facebook),access_token?,id_token?,email?,name?,avatar?,provider_id?} → {token,token_type,user}
- GET `/auth/oauth/{provider}/redirect` → {provider,redirect_url}
- POST `/auth/forgot-password` {email*} → {reset_token} (dev convenience, token in response)
- POST `/auth/reset-password` {email*,token*,password*,password_confirmation*}
- POST `/auth/logout` (auth) — POST `/auth/logout-all` (auth)
- GET `/auth/me` (auth) → {user}
- POST `/auth/change-password` {current_password*,new_password*,new_password_confirmation*} (auth, throttled)
- GET `/auth/login-history?per_page=&status=&is_suspicious=` (auth) → paginated LoginHistory
- GET `/cities?search=&state=&is_capital=&per_page=` (public) — GET `/cities/{id}` (public)
- GET `/users/{id}` (self or admin) — PATCH `/users/{id}` {name?,email?,phone?,city_id?,password?} (never send `role` — server ignores/blocks for non-admin anyway)
- GET `/libraries?search=&city_id=&location=&status=&sort_by=&sort_dir=&per_page=` (any authed incl. customer) — GET `/libraries/{id}` (same)
- GET `/gyms?...` / GET `/gyms/{id}` — identical shape to libraries
- GET `/libraries/{id}/fee-plans` / `/gyms/{id}/fee-plans` (any authed) → plain array, NOT paginated
- GET `/libraries/{lib_id}/members/{id}` / `/gyms/{gym_id}/members/{id}` (self-view only, if you already know the id) 
- GET `.../members/{id}/renewals` (self allowed)
- POST `/gyms/{gym_id}/attendance/check-in` {member_id*} (self allowed) → 201, 400 if membership inactive, 409 if already open session
- POST `/gyms/{gym_id}/attendance/check-out` {attendance_id*} (self allowed) → 409 if already checked out
- GET `/gyms/{gym_id}/attendance/members/{member_id}/attendance?date_from=&date_to=&per_page=` (self-scoped, correct "my history" endpoint)
- GET `/gyms/{gym_id}/attendance/{id}` (self allowed)
- GET `/payments?status=&date_from=&date_to=&per_page=` (self-scoped server-side) — GET `/payments/{id}` (self)
- GET `/exceptions?status=&per_page=` (GLOBAL endpoint, self-scoped server-side for member-tier)
- GET `/translations?locale=&group=&search=&per_page=` (any authed) — optional, for server-driven copy overlay (static ARB is source of truth though)
- GET `/api/health` and `/api/v1/health` (public, unversioned-and-versioned variants) → {status,timestamp,app,services,meta:{healthy}}

**Do NOT implement** (staff/admin only, will 403 for customer): create/update/delete Library or Gym; library/gym members index+create+renew+update+status+delete; fee-plan create/update/delete; payments create/mark-paid/earnings; facility-scoped exceptions list; exception create/revoke; users list-all/delete/status; translations management; audit logs.

**Resource JSON field names** (authoritative from `app/Http/Resources/V1/*.php`):
- User: id,name,email,phone,city_id,city,role,status,custom_permissions,email_verified_at,created_at,updated_at
- City: id,name,state,tagline,description,latitude,longitude,is_capital,timezone
- Library/Gym (identical shape): id,name,description,address,city_id,city,latitude,longitude,contact_phone,contact_email,opening_time,closing_time,status,created_by,created_at,updated_at
- LibraryMember: id,library_id,user_id,membership_type,start_date,end_date,status,user,library,created_at,updated_at
- GymMember: id,gym_id,user_id,membership_type,start_date,end_date,status,user,gym,created_at,updated_at
- GymAttendance: id,gym_id,member_id,check_in_at,check_out_at,duration,date,request_id,gym,member,created_at,updated_at
- FeePlan: id,facility_type,facility_id,name,interval,interval_count,amount,currency,is_active,description,created_at,updated_at
- Payment: id,user_id,payable_type,payable_id,amount,currency,status,payment_method,transaction_reference,invoice_number,due_date,paid_at,notes,user,created_at,updated_at
- MembershipRenewal: id,user_id,membership_type,membership_id,fee_plan_id,payment_id,previous_end_date,new_end_date,extended_interval,extended_count,amount_paid,currency,notes,fee_plan,payment,created_at
- FacilityException: id,facility_type,facility_id,user_id,exception_type,reason,details,approved_by,starts_at,expires_at,status,user,approver,created_at,updated_at
- LoginHistory: id,user_id,email,ip_address,user_agent,device_type,browser,platform,location,status,failure_reason,is_suspicious,flagged_reason,created_at,user

## Screens required (all must be REAL, wired to live API — not placeholders)
1. Splash (health check + session hydration)
2. Login/Register tabbed (mockup: `premium_login_registration/code.html`, re-skin to v2 tokens)
3. Forgot/Reset Password (2-step)
4. Home Dashboard (mockup: `dashboard_with_memberships/code.html` — hero Cityzen ID card, service grid, membership cards from payment-derived summary)
5. Services Explorer / facility list (mockup: `premium_services_explorer/code.html`)
6. Facility Detail (mockup: `service_details_view/code.html`)
7. Membership Details + QR check-in (mockup: `membership_details_qr_check_in/code.html`, tabs: Details/Attendance/Payments)
8. Cityzen ID full screen (mockup: `premium_dashboard_identity_card/code.html`, hero card only)
9. Profile + Edit Profile (role badge, staff-view toggle if role≠customer)
10. **Settings** (NEW — user explicitly asked for runtime-editable config): API base URL, connect/receive timeouts, request-logging toggle, "Test Connection" before persisting a URL change, reset-to-defaults. ARB keys already exist for this screen.
11. Security (change password, login history list w/ suspicious flagging, logout / logout-all)
12. Payments list + receipt detail (client-rendered from PaymentModel, no PDF)
13. My Exceptions/Discounts (global self-scoped list)
14. Shared: ErrorStateView, EmptyStateView, LoadingIndicator, NoConnectionBanner (connectivity_plus)

## User's explicit requirements (verbatim intent, not to be watered down)
- "complete all UI along with api, make it very beautifully designed fully functional app" — every screen real, polished glassmorphic styling matching mockups closely, no bare Material defaults, no TODOs.
- "make configurations editable like api url and other configs" — runtime-editable Settings screen backed by shared_preferences, NOT just compile-time dart-define. Dio client must reactively pick up config changes without app restart.
- Security/validation/logging were explicitly requested up front: secure token storage (flutter_secure_storage, never SharedPreferences for the token), client-side form validation mirroring server FormRequest rules, structured redacted logging (never log passwords/full tokens), typed error handling with no raw stack traces shown to users, rate-limit-aware UX (client-side cooldowns mirroring server's 5/min and 10/min limits).
- Single responsive Flutter codebase for both Android and Web (breakpoint ~900px: bottom nav vs sidebar).

## Recommended order to finish (if resuming/handing off) — HISTORICAL, app is now built
This section described the original build-from-scratch plan and is kept for history. **As of this update, the app is fully built, all screens are real and wired to the live API, and everything below this line documents what has actually shipped since.** Skip to "Status as of latest session" below for current state.
1. Add missing models: PaginationMeta, generic Paginated<T>, ApiError.
2. Run `dart run build_runner build --delete-conflicting-outputs`, fix generation errors.
3. Build `lib/core/config/app_config.dart` (AppConfigController, shared_preferences-backed, dart-define as first-run-only seed).
4. Build `lib/data/api/dio_client.dart` (3 interceptors: auth injection, redacted logging via `logger` package, error-mapping to typed AppException) — must watch/rebuild on AppConfigController changes.
5. Build `lib/data/api/token_storage.dart` (flutter_secure_storage wrapper).
6. Build the 8 API service classes listed above, then the repositories (with the payments-derived membership logic as its own clearly-commented method).
7. Build Riverpod providers.
8. Build go_router + responsive shell.
9. Build shared widgets, then screens in roughly the order a user encounters them (splash→auth→dashboard→facilities→membership→payments→profile/settings/security→exceptions).
10. Rewrite main.dart.
11. `flutter analyze` until clean, `flutter gen-l10n` if new strings added.

---

## Status as of latest session (read this first)

**The app is fully built and functional.** All ~14 screens exist and are wired to the live Laravel API, `flutter analyze` passes with **zero issues**, `dart run build_runner build` is clean, and it has been run and manually verified in Chrome against a local Laravel dev server (`php artisan serve` on port 8000). This session's work was: (1) a large initial build via a background coding agent, (2) an independent code review that caught and fixed a real bug, (3) a round of live-testing fixes from the user actually clicking through the app, and (4) branding/platform-scoping work. Details below.

### Round 1: Initial full build (background agent + coordinator fixes)
- A background agent built the entire app (theme, all data models, Dio/API/repository layers, Riverpod providers, go_router, and all 14 screens) against a foundation the coordinating session had already de-risked (see the freezed/riverpod version-conflict notes earlier in this file — still valid, don't re-break them).
- **Independent code review** (a separate agent re-reading the actual source, not trusting the builder's self-report) confirmed: the payments-derived membership workaround is implemented correctly and doesn't fabricate data it can't get; the Dio client genuinely rebuilds reactively when `AppConfigController` changes (no restart needed); the router has a real auth guard and a genuinely responsive shell (not a stub); the forbidden endpoints (member list/create/renew, non-self-scoped attendance/exceptions) are correctly never called.
- **One real bug found and fixed**: `lib/data/api/dio_client.dart`'s debug-logging redaction only scrubbed `Authorization` headers via regex, but plaintext passwords in request bodies (login/register/change-password) could still be logged verbatim in debug mode because the regex didn't match JSON body fields. Fixed by detecting sensitive body keys (`password`, `password_confirmation`, `current_password`, `new_password`, `access_token`, `id_token`, `reset_token`, etc.) and suppressing the entire log line for that request/response rather than trying to regex-redact arbitrary JSON in place. This is exactly the kind of bug `flutter analyze` cannot catch — it's a logic/security issue, not a type error. **Lesson for future work on this app: never trust "flutter analyze is clean" as proof of correctness for security-sensitive logging/auth code — read it.**

### Round 2: Live-testing fixes (from the user actually running the app)
The user ran `flutter run -d chrome --dart-define=API_BASE_URL=https://smartct.online/api/v1` against the live Laravel server and reported real, concrete problems — this is why "run it yourself" matters more than static analysis:
1. **Register form overflow bug (fixed)**: `lib/features/auth/screens/login_register_screen.dart` had the login/register tab content wrapped in a `TabBarView` inside a `SizedBox` with a **hardcoded height guess** (`260` for login, `480` for register). The register form (6 fields + validation + button) didn't fit in 480px, so the submit button was pushed off-screen with a visible "BOTTOM OVERFLOWED BY 247 PIXELS" banner. Fixed by removing `TabBarView`/fixed-height entirely and switching to a `TabController`-listener-driven conditional render (`_activeTab == 0 ? _buildLoginForm() : _buildRegisterForm()`) inside an `AnimatedSwitcher`, letting the outer `SingleChildScrollView` size to whichever form is showing. **If you ever add a third tab or more fields to either form, do not reintroduce a hardcoded height — this pattern is now height-agnostic by design, keep it that way.**
2. **Staff View + "My Discounts & Exceptions" fully removed** (user's explicit scope correction — this app is customer-only, no adaptive staff views): deleted `lib/features/exceptions/` entirely, `lib/core/providers/staff_view_controller.dart` (+`.g.dart`), `lib/core/providers/exceptions_providers.dart` (+`.g.dart`), `lib/data/repositories/exceptions_repository.dart` (+`.g.dart`), `lib/data/api/exceptions_api.dart` (+`.g.dart`), `lib/data/models/facility_exception_model.dart` (+`.freezed.dart`/`.g.dart`), the `/exceptions` route in `app_router.dart`, and the corresponding `myExceptions`/`staffView` ARB keys from all 5 locale files. **This feature is gone, not hidden — if it's wanted back later, it needs to be rebuilt from the API contract (global self-scoped `GET /exceptions`), not un-commented, since nothing was left in place.**
3. **Settings screen simplified to theme-mode only** (user's explicit correction — the runtime-editable network config UI I'd built per an earlier request was more than they wanted surfaced): `lib/features/settings/screens/settings_screen.dart` was rewritten from scratch to show only a System/Light/Dark picker wired to the pre-existing (already fully implemented, just previously unused in UI) `lib/core/providers/theme_mode_controller.dart`. **`lib/core/config/app_config.dart`/`AppConfigController` and the reactive Dio-rebuild-on-config-change wiring were deliberately left in place** — the Dio client still needs a base URL/timeout source, it's just no longer user-editable from this screen. If the user ever wants the network-config UI back, the `AppConfigController` API (`updateApiBaseUrl`, `updateTimeouts`, `updateRequestLogging`, `resetToDefaults`) is all still there and functional, just not surfaced.
4. **Dashboard/Payments self-scoping**: re-verified (already correct, not a bug) that `GET /payments` is filtered server-side to the logged-in user (`PaymentService.php` filters `user_id = actor.id` for member/customer role — see the API constraints section above), and the Flutter `PaymentsRepository`/`myMembershipSummariesProvider` never pass another user's ID. No code change was needed here, just confirmation.
5. **Google OAuth button icon replaced**: `Icons.g_mobiledata_rounded` (an Android data-status glyph, not a brand mark — looked like a placeholder) was swapped for a small custom `_GoogleGlyph` widget (a `ShaderMask`-colored "G" using Google's actual brand gradient) in `login_register_screen.dart`. Facebook's icon (`Icons.facebook_rounded`) was kept but recolored to the real Facebook blue (`#1877F2`).

### Round 3: Branding + platform scoping
1. **Logo/branding placeholder pipeline set up**: the user provided a real brand logo (blue→green gradient shield with a city skyline + wifi-arc motif, "Smart Cityzen" wordmark) as a pasted image, but **the actual PNG files were never saved to disk in this session** — pasted chat images aren't directly accessible as files to the tools available here, and the user declined to provide a file path when asked. To avoid blocking on that, a closely-matching **placeholder** logo was generated programmatically (Python/Pillow, script preserved at the path noted below) and wired into every slot the real logo will eventually occupy — swapping in the real files later requires zero code changes, just overwriting the same filenames:
   - `assets/images/app_icon.png` (1024×1024, opaque background) — used by `flutter_launcher_icons` for the Android/Web launcher icon.
   - `assets/images/splash_logo.png` (512×512, transparent) — used by `flutter_native_splash` for the native OS splash screen (pre-Flutter-engine-init).
   - `assets/images/splash_logo_android12.png` (480×480, more padding per Android 12's fixed splash-icon spec) — Android 12+ splash variant.
   - `assets/images/logo_mark.png` (256×256, transparent) — used directly in-app via `Image.asset(...)` on the Flutter splash screen (`lib/features/auth/screens/splash_screen.dart`) and the login/register screen header (`lib/features/auth/screens/login_register_screen.dart`).
   - **To swap in the real logo**: replace those 4 PNG files (matching filenames/sizes) in `assets/images/`, then re-run `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create` to regenerate the platform-specific icon/splash resources, then `flutter run`/`flutter build` as normal. No Dart code changes needed.
   - The placeholder-generation script lives at `/private/tmp/claude-501/.../scratchpad/gen_logo.py` (a session-scoped temp path — **copy it into the repo, e.g. `tool/gen_logo.py`, if you want to keep it for regenerating placeholders later**; it will not persist otherwise).
   - `pubspec.yaml` gained `flutter_launcher_icons: ^0.14.3` and `flutter_native_splash: ^2.4.4` as dev dependencies, plus `flutter.assets: [assets/images/]` and the corresponding `flutter_launcher_icons:`/`flutter_native_splash:` config blocks (Android + Web only — see next point).
2. **iOS removed from the project** (user's explicit ask, since iOS was never a target platform for this app): deleted the `ios/` platform folder entirely, and removed `ios: true` from the `flutter_launcher_icons` config and the `ios`/`macos` build targets from the launcher-icons block (kept Android + Web only, matching the app's actual scope; macOS/Windows/Linux desktop folders were left alone since removing them wasn't asked for). `flutter_native_splash:create` correctly auto-detected the missing `ios/` folder and skipped iOS splash generation without erroring. `flutter pub get` and `flutter analyze` both remain clean after this removal — the iOS-flavored transitive Dart packages (`google_sign_in_ios`, etc.) don't require the native folder to exist for non-iOS builds.
3. **Android build/APK readiness confirmed** (verified, NOT built — user explicitly asked to check readiness and get the steps, not to actually run the build):
   - `flutter doctor -v` shows the Android toolchain fully configured: SDK at `~/Library/Android/sdk`, platform android-37.0, build-tools 36.0.0, all licenses accepted, Java 25 (bundled with Android Studio). The only remaining `flutter doctor` complaint is Xcode/iOS simulators, which is irrelevant now that iOS is out of scope.
   - `android/local.properties` has both `flutter.sdk` and `sdk.dir` set correctly.
   - `android/app/build.gradle.kts`: **two pre-existing placeholders worth fixing before a real release** (not blockers for a debug/testing APK): `applicationId = "com.example.smartcityzenv2"` is still the `flutter create` default — should be changed to a real reverse-domain package name before any Play Store submission; and `buildTypes.release.signingConfig` is set to the **debug** signing config (`// TODO: Add your own signing config for the release build.` — this is Flutter's own template comment, not something introduced this session), meaning `flutter build apk --release` right now would produce an APK signed with the debug key, which is fine for sideloading/testing but must not be used for a Play Store release.
   - Gradle wrapper is on 9.1.0, `android.useAndroidX=true` is set, `org.gradle.jvmargs` has adequate heap (`-Xmx8G`).
   - **Exact steps to generate an APK** (debug, for sideloading/testing — no signing setup needed):
     ```
     cd /Users/abhishekgupta/Documents/flutters/smartcityzenv1/smartcityzenv2
     flutter pub get
     dart run build_runner build --delete-conflicting-outputs   # only needed if models/providers changed
     flutter build apk --debug --dart-define=API_BASE_URL=<your API base URL>
     ```
     Output lands at `build/app/outputs/flutter-apk/app-debug.apk`. For a release-profile APK (still debug-signed until a real signing config is added): swap `--debug` for `--release`. Install on a connected device/emulator with `flutter install` or `adb install build/app/outputs/flutter-apk/app-debug.apk`.
   - **Before a real Play Store release** (not needed for testing): (a) change `applicationId` in `android/app/build.gradle.kts` to a real package name owned by the developer, (b) generate a real upload keystore (`keytool -genkey ...`) and wire it into a `signingConfigs.release` block referencing a `key.properties` file (never commit the keystore or its passwords), (c) run `flutter build appbundle --release` for Play Store (App Bundle, not raw APK) once signed.
4. **Session handoff doc updated** — this section. The rest of this file (API contract, screen list, toolchain gotchas above) is still accurate and load-bearing; nothing in it was invalidated by this session's changes except where explicitly noted above (e.g. Settings scope, Exceptions/StaffView removal).
12. Verify with `flutter run -d chrome` (Android emulator not available on this machine yet — ANDROID_HOME/SDK needs setup separately).
