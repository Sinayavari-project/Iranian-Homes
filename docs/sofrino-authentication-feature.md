# Sofrino Authentication Feature

*Version 1.0 | July 2026*

The first feature built on top of the Sofrino iOS architecture (`docs/sofrino-ios-architecture.md`). This document covers what it does, why it's shaped the way it is, and what's deliberately left for later.

---

## Flow

```
PhoneEntryView
      │  requestOTP(phoneNumber) succeeds
      ▼
OTPVerificationView
      │  verifyOTP(phoneNumber, code) succeeds → AuthSession
      │
      ├── user.role == nil ──────────────────► RoleSelectionView
      │                                              │  selectRole(.restaurant)
      │                                              ▼
      │                                        (restaurant → done, enters app)
      │
      │                                              │  selectRole(.supplier)
      │                                              ▼
      ├── user.role == .supplier                TradeLicenseUploadView
      │   && kycStatus.isActionable ────────────────►│  submitTradeLicense(...)
      │                                              ▼
      │                                        (done, enters app — KYC review
      │                                         happens on the Admin console,
      │                                         BRD §5, not blocking here)
      │
      └── otherwise ─────────────────────────► done, enters app
```

Restaurant buyers reach the home screen in two screens (phone → OTP → role). Suppliers add one more (→ trade license). Returning users with a completed profile skip straight from OTP verification into the app — the coordinator (`AuthCoordinator.swift`) makes this decision once, right after `verifyOTP` returns, by inspecting the returned `AuthUser`.

## Why phone + OTP, no password

BRD §8.1 scopes Authentication as phone-first with no separate "sign up" flow — `requestOTP` creates the Supabase Auth user on first verification. This matches Design Principle 1, "Chef-speed, not enterprise-speed": a manager standing in a kitchen mid-shift should not be inventing and remembering a password. The UAE mobile-first market (BRD §2.1) also makes phone number the one identifier every restaurant operator already has memorized.

## Screens

### Phone Entry (`Presentation/PhoneEntry/`)

- Formats input live as a national UAE number (`50 123 4567`) via `UAEPhoneNumber`, which is the single validation source shared with the repository's E.164 conversion — the field can never accept something the network call would reject.
- The submit button disables itself the instant `Reachability` reports no connection, rather than letting the chef tap it and wait out a doomed request.

### OTP Verification (`Presentation/OTPVerification/`)

- A dedicated `SofrinoOTPField` (added to the Design System in this feature — `Components/SofrinoOTPField.swift`) renders six digit boxes backed by one hidden text field, so the keyboard, autofill (`textContentType: .oneTimeCode`, which surfaces the SMS code from iOS's system suggestion bar), and paste all work through the platform's native mechanisms.
- Auto-submits the instant the sixth digit lands — no separate "Verify" button to tap. A wrong code clears the field, shakes it (`sofrinoShake`, also new in the Design System this feature), and shows an inline message; the chef immediately sees where to re-enter without hunting for an error banner elsewhere on screen.
- Resend has a 60-second cooldown, displayed as a live countdown, to avoid hammering the SMS provider.

### Role Selection (`Presentation/RoleSelection/`)

- Two `SofrinoSelectionCard`s (also new in the Design System) — Restaurant vs. Supplier, per BRD §8.1's three-role platform (Admin is provisioned internally, never self-selected). Selection state is communicated through border color, background tint, and a checkmark — never color alone, satisfying the Design System's accessibility rule against color-only signaling.

### Trade License Upload (`Presentation/TradeLicense/`)

- Only reachable for suppliers. Captures a photo via `PhotosPicker` (compressed to JPEG at 0.6 quality client-side before upload — trade license photos are typically several MB straight off a phone camera, and BNPL/KYC review doesn't need full resolution), a 6-digit license number, and an expiry date.
- **This is the one screen in the feature built to work offline**, because it's the realistic failure mode: a supplier finishing onboarding from a warehouse or storeroom with poor signal. If `Reachability` reports offline at submit time, `OfflineQueuingAuthRepository` queues the operation to disk (`OfflineRequestQueue<TradeLicenseUploadOperation>`) and returns an optimistic "pending" result immediately — the supplier proceeds into the app rather than staring at a spinner or a dead end. The queue drains automatically the next time `Reachability` reports a connection, in the same order operations were queued, and survives a full app force-quit because it's persisted, not held in memory.

## Two repositories, one contract

`AuthRepository` (`Domain/AuthRepository.swift`) has exactly two conformances:

- **`SupabaseAuthRepository`** — talks to Supabase's Auth (`/auth/v1/otp`, `/auth/v1/verify`) and PostgREST (`/rest/v1/profiles`) REST APIs directly over `HTTPClientProtocol`, with no Supabase SDK dependency (see architecture doc for why). Trade license photos go to Supabase Storage (`/storage/v1/object/trade-licenses/{userID}/license.jpg`).
- **`DemoAuthRepository`** — an `actor` holding one seeded `AuthUser` in `OfflineCache`, with artificial latency so the demo's loading states are still visible. Accepts any 6-digit code (a fixed `111111` is also always accepted, for repeatable pitch rehearsals). This is what BRD §1's "investor-ready demo environment" means concretely: the same screens, the same animations, the same interaction code paths — just no dependency on Supabase or cellular signal being available in a pitch room.

Every view model is constructed with `any AuthRepository` by `AuthenticationContainer`, which is the only file that picks one based on `AppEnvironment`.

## What's intentionally not in this feature yet

- **Role is not editable after selection** (the copy on Role Selection says so explicitly) — changing roles post-onboarding is a support-assisted operation per BRD scope, not a self-service screen. Revisit if support volume justifies building one.
- **KYC verification UI belongs to the Admin console** (BRD §8.1, §5), not this app. A supplier's `kycStatus` sits at `.pending` after submission until an ops reviewer approves it elsewhere; this feature doesn't poll or notify on that transition yet — that's a natural fit for a push notification once the notifications feature exists.
- **Trade license renewal reminders** (BRD §10's expiry-tracking constraint) aren't built here — this feature only captures the expiry date. A background check + Urgent Ribbon entry (home screen spec §3) for "license expires in 6 days" is a home-screen-feature concern, not an auth-flow concern, since it needs to surface after the user is already inside the app.
- **`user_roles` table / `has_role()` RLS enforcement** (BRD §10 constraint) lives entirely server-side in Supabase migrations — nothing in this client codebase enforces authorization; it only reads the `role` field from `profiles` for onboarding/display routing, exactly as the constraint intends ("never role columns on profiles" for *authorization* — this client never uses it for that).

## Testing

`Tests/SofrinoAuthenticationTests/` covers every view model's validation rules and success/failure paths against `MockAuthRepository`, a fully scriptable double (see architecture doc's testing section). `UAEPhoneNumberTests` covers the phone validation/formatting edge cases (local format, spaced input, missing leading zero, landline prefixes, wrong length) that both the UI field and the repository's wire format depend on. `OfflineQueuingAuthRepositoryTests` exercises the offline decorator directly — online submissions pass straight through, offline submissions queue without touching the network and return an optimistic result, and a simulated connectivity change drains the queue automatically — the three behaviors that make trade license upload safe to use from a storeroom with poor signal.
