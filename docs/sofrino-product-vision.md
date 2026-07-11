# Sofrino — Complete Product Vision

*Version 1.0 | July 2026*

---

## 1. Product Vision

**One line:** The procurement OS that makes restaurant buying feel like consumer shopping.

Sofrino replaces the chaos of WhatsApp threads, phone calls, and paper invoices with a single app that a head chef opens at 10pm to place tomorrow's orders. It combines Noon's consumer-grade shopping UX with the commercial muscle of trade credit, cold-chain logistics, and VAT-compliant invoicing — purpose-built for the UAE food-service industry.

The product has two modes that share one codebase:

- **Production mode** — real Supabase backend, real suppliers, real money.
- **Investor demo mode** — seeded local data, zero network dependency, always works. A toggle, not a fork.

Sofrino wins by being the app that restaurant operators *want* to use, not the one they're forced to use. If the UX doesn't feel as good as ordering dinner on Noon, it ships again.

---

## 2. Product Principles

1. **Chef-speed, not enterprise-speed.** A reorder takes 8 seconds. Search results appear before the keyboard settles. Every screen loads in under 300ms or it's a bug.

2. **Trust is the product.** Verified suppliers, transparent pricing, visible trade licenses, cold-chain temperature logs. Trust isn't a feature — it's the reason restaurants leave WhatsApp.

3. **Credit unlocks GMV.** Small restaurants can't prepay for a week of supplies. BNPL isn't an add-on — it's the growth engine. Make credit approval feel instant and limits feel generous.

4. **Offline-aware, not offline-first.** Kitchens have greasy hands and spotty WiFi. Cart state persists locally. Orders queue when connectivity drops. The app never shows a blank screen.

5. **Supplier success = marketplace success.** If suppliers don't get orders and get paid fast, the catalog dies. Supplier tools are first-class, not an afterthought.

6. **Demo-grade = production-grade.** The investor demo isn't a separate app. It's the real app with seeded data. If the demo breaks, the product is broken.

7. **Arabic is not a translation — it's a layout.** RTL isn't a CSS flip. Every screen is designed for Arabic first, then adapted to English. Typography, reading flow, and iconography respect the script.

8. **Opinionated defaults, not configuration screens.** Smart defaults for delivery windows, payment terms, and reorder thresholds. Settings screens are where products go to die.

---

## 3. Target Users

### Primary: Restaurant Buyer (the "Chef-Manager")

- **Who:** Head chef, restaurant manager, or owner of an independent restaurant (1-5 locations). 70% of UAE's 25,000+ restaurants.
- **Age:** 28-50. Male-skewed (85%+). Mix of South Asian, Arab, and Western operators.
- **Tech comfort:** Uses Noon, Talabat, Instagram daily. Comfortable with mobile shopping but not with enterprise procurement software.
- **Pain:** Spends 2-3 hours/day on procurement across 12-20 supplier WhatsApp threads. No price comparison. No credit history. No order records beyond chat screenshots.
- **Job to be done:** "I need tomorrow's supplies ordered before I leave the kitchen tonight, at the best price, on credit, with reliable delivery by 6am."
- **Device:** iPhone (60% in UAE food-service) or Android. Often used one-handed, in a kitchen, with wet or greasy hands.

### Secondary: Supplier Sales Manager

- **Who:** Sales/operations lead at a food distributor (10-500 employees). Manages 50-200 restaurant accounts.
- **Pain:** Manual order entry from WhatsApp. Payment collection is a full-time job. No visibility into demand trends. Discovery limited to cold calls and trade shows.
- **Job to be done:** "I need orders to come in digitally, fulfill accurately, and get paid on time without chasing invoices."

### Tertiary: Multi-Branch Procurement Manager

- **Who:** Procurement lead at a restaurant group (5-50 locations). Manages centralized purchasing.
- **Pain:** No consolidated view across branches. Can't enforce approved supplier lists or budget caps.
- **Job to be done:** "I need to see what every branch is ordering, enforce our supplier contracts, and get volume discounts."

### Internal: Sofrino Admin/Ops

- **Who:** Sofrino team members handling KYC, catalog quality, disputes, and analytics.
- **Job to be done:** "I need to verify suppliers fast, maintain catalog quality, resolve disputes, and report metrics to leadership."

---

## 4. Core User Journeys

### Journey 1: First Order (Restaurant Buyer)

```
Download app → Trade license upload → Instant provisional approval →
Browse categories (Noon-style tiles) → Add items to cart →
See total with VAT → Apply for BNPL (30-second approval) →
Place order → Receive confirmation with delivery ETA →
Track driver → Receive delivery → Rate supplier
```

**Critical metric:** Time from app install to first order < 15 minutes.

### Journey 2: Daily Reorder (Restaurant Buyer)

```
Open app → Tap "Reorder" on home screen → See last order pre-filled →
Adjust quantities → Confirm → Done
```

**Critical metric:** Reorder completion in < 30 seconds, 3 taps.

### Journey 3: Supplier Discovery (Restaurant Buyer)

```
Search "organic chicken breast" → See ranked results with price,
MOQ, delivery time, supplier rating → Compare 3 suppliers side-by-side →
Add to cart from comparison → Checkout
```

### Journey 4: Supplier Onboarding

```
Download app → Upload trade license + food safety cert →
Enter catalog via CSV or photo scan (AI extraction) →
AI generates product images for items without photos →
Set pricing tiers and delivery zones →
Go live (pending KYC approval, < 24hrs)
```

### Journey 5: BNPL Credit Application

```
Restaurant places 3+ orders (builds transaction history) →
Prompted: "You qualify for Net-30 credit up to AED 15,000" →
Tap to apply → Instant decision → Credit line active →
Future orders show "Pay in 30 days" option at checkout
```

### Journey 6: Multi-Branch Management

```
Procurement manager opens dashboard → Sees all branches →
Sets approved supplier list per category →
Sets monthly budget cap per branch →
Branch managers order within constraints →
Consolidated invoice at month-end
```

### Journey 7: Investor Demo

```
Open app with demo flag → See fully populated marketplace →
Browse categories, add to cart, checkout → See order tracking →
Switch to supplier view → See orders, analytics →
Switch to admin → See KYC queue, metrics dashboard →
Everything works. No loading spinners. No errors. Ever.
```

---

## 5. Competitive Advantages

### 5.1 Structural Advantages

| Advantage | Why it matters | Defensibility |
|---|---|---|
| **BNPL for restaurants** | Small operators can't prepay. Credit unlocks 40%+ of the market that competitors can't reach. | Underwriting model improves with transaction data — network effect on credit risk. |
| **Cold-chain logistics integration** | Competitors are marketplaces only. Sofrino owns the delivery experience for perishables. | 3PL partnerships + routing data create switching costs. |
| **Dual demo/production architecture** | Fundraising velocity. Every pitch meeting shows a flawless product. | Competitors demo staging environments that break. |
| **UAE-first, not UAE-adapted** | VAT compliance, trade license verification, AED-native — not a Western product localized. | Regulatory moat. Compliance is hard to bolt on. |
| **Section architecture (Restaurant/Imports/Supermarket)** | Expands TAM without diluting core B2B positioning. Each section unlocks a new revenue pool. | Platform breadth creates cross-sell lock-in. |

### 5.2 Experience Advantages

| Advantage | Competitor gap |
|---|---|
| Consumer-grade UX in a B2B context | Existing B2B platforms look like 2010 enterprise software. |
| 30-second reorder | Competitors require navigating a full catalog every time. |
| AI-powered catalog onboarding | Competitors require manual product photography and data entry. |
| Native iOS app (SwiftUI) | Competitors are web-first, mobile-second. |
| Arabic-first RTL design | Competitors treat Arabic as an afterthought translation layer. |

### 5.3 Data Advantages (compounding over time)

- **Pricing intelligence:** Sofrino sees every transaction. Can surface "you're paying 15% above market for tomatoes" to buyers.
- **Demand forecasting:** Aggregate order data predicts seasonal demand shifts before suppliers see them.
- **Credit scoring:** Transaction history within Sofrino becomes the best predictor of creditworthiness — better than any external bureau.
- **Supplier quality ranking:** Order fulfillment data, defect rates, and buyer ratings create a trust score no new entrant can replicate.

---

## 6. Product Roadmap

### Phase 0: Foundation (Weeks 1-3)

- SwiftUI project scaffold with TCA (The Composable Architecture)
- Design system: typography, color tokens (Emerald/Blue/Amber per section), spacing, components
- Supabase schema: users, roles, RLS policies, profiles, trade licenses
- Auth flow: phone + OTP (UAE numbers), trade license upload, role assignment
- Demo data seeding infrastructure
- CI/CD pipeline (Xcode Cloud + GitHub Actions)

### Phase 1: Supplier Portal (Weeks 4-7)

- Supplier onboarding: profile, trade license, food safety certs
- Master catalog: categories, subcategories, units, variants
- Supplier catalog management: add products, set pricing tiers, MOQs, delivery zones
- AI product image generation for items without photos
- CSV bulk upload
- Order management: incoming orders, accept/reject, fulfillment status
- Supplier wallet and payout tracking

### Phase 2: Restaurant Buyer Experience (Weeks 8-14)

- Home screen: category tiles, sponsored banners, recently ordered, favorites
- Search: full-text with filters (category, supplier rating, delivery time, price range)
- Product detail: pricing, MOQ, supplier info, reviews
- Cart: multi-supplier cart with per-supplier subtotals and delivery fees
- Checkout: delivery address, time window, payment method, VAT breakdown
- Order tracking: real-time status, driver location, delivery confirmation
- Reorder: one-tap from order history
- Reviews and ratings
- BNPL credit application and checkout integration
- In-app messaging (buyer-supplier)
- Multi-branch support: branch selector, consolidated ordering
- Standing orders (recurring auto-orders)
- Delivery time guarantees

### Phase 3: Admin Console (Weeks 15-18)

- Web-based admin console (Next.js + shadcn/ui)
- KYC verification queue with document viewer
- Master catalog management
- User and role management
- Order dispute resolution
- Analytics dashboard: GMV, take rate, activation, retention, supplier health
- Price intelligence dashboard

### Phase 4: Polish + Demo (Weeks 19-21)

- Investor demo mode: local fixture toggle, curated demo data
- Performance optimization pass (< 300ms screen loads)
- Accessibility audit
- Arabic/RTL full pass
- App Store submission prep

### Phase 5: Launch (Weeks 22-24)

- TestFlight beta with 20 pilot restaurants + 10 suppliers
- Iterate on feedback
- App Store launch (UAE)
- Marketing site live
- Supplier concierge onboarding program begins

### Post-Launch (Month 7+)

- Android app (Kotlin)
- Global Imports section
- Supermarket section
- POS integrations
- Predictive reorder suggestions (ML)
- Group purchasing for small restaurants
- Recipe costing tool
- Waste reduction insights
- Kitchen display integration
- Seasonal calendar + pre-booking (timed to Ramadan 2027)

---

## 7. Recommended Tech Stack

### iOS Application

| Layer | Technology | Rationale |
|---|---|---|
| UI Framework | **SwiftUI** (iOS 17+) | Native performance, declarative UI, Apple-grade animations. iOS 17 minimum gives Observable macro, improved ScrollView, and SwiftData. |
| Architecture | **TCA (The Composable Architecture)** | Unidirectional data flow, testable, composable. Ideal for complex state like multi-supplier carts and BNPL flows. |
| Networking | **Supabase Swift SDK** + custom API client | Direct Supabase integration for auth, realtime, and storage. Custom client for Edge Function endpoints. |
| Local persistence | **SwiftData** + **GRDB** (search index) | SwiftData for model persistence and offline cart. GRDB for full-text product search with Arabic tokenization. |
| Image loading | **Nuke** | Async image loading with disk/memory caching. |
| Dependency injection | **swift-dependencies** (Point-Free) | Testable, swappable dependencies. Demo mode = swap live dependencies for mock ones. |
| Push notifications | **APNs** + Supabase Edge Functions | Order updates, delivery tracking, BNPL reminders. |
| Analytics | **PostHog** or **Mixpanel** | Event tracking for activation funnels, reorder frequency, conversion. |
| Crash reporting | **Sentry** | Production crash tracking with SwiftUI stack traces. |
| Payments | **Stripe Connect** (UAE) or **Tap Payments** | AED processing, split payments to suppliers. |
| Maps | **MapKit** | Delivery tracking, branch location management. |
| Localization | **String Catalogs** (Xcode 15+) | Native Apple localization. English + Arabic. |

### Backend

| Layer | Technology |
|---|---|
| Database | **Supabase (PostgreSQL)** with RLS |
| Auth | **Supabase Auth** (phone OTP) |
| Realtime | **Supabase Realtime** (order status, messaging) |
| Storage | **Supabase Storage** (product images, trade licenses) |
| Edge Functions | **Deno (TypeScript)** — business logic, BNPL decisioning, webhooks |
| AI | **Claude API** — catalog data extraction, product image generation prompts, buyer assistant |
| Search | **PostgreSQL full-text search** (V1), **Meilisearch** if needed |

### Admin Console

| Layer | Technology |
|---|---|
| Framework | **Next.js 15** (App Router) |
| UI | **shadcn/ui + Tailwind CSS** |
| Backend | Same Supabase instance, admin role RLS |

### Infrastructure

| Layer | Technology |
|---|---|
| Hosting | **Supabase Cloud** (database, auth, storage, functions) |
| Admin hosting | **Vercel** |
| CI/CD | **Xcode Cloud** (iOS) + **GitHub Actions** (backend/admin) |
| Monitoring | **Sentry** + **PostHog** + **Supabase Dashboard** |

---

## 8. Risks

### Risks identified in the BRD (validated, expanded)

| Risk | Mitigation |
|---|---|
| Slow supplier onboarding | Concierge onboarding team + CSV bulk upload + AI image generation. Target 10-15 anchor suppliers before buyer launch. |
| BNPL default rate | Partner with licensed UAE lender (Tabby, Tamara). Sofrino facilitates, doesn't lend directly. Underwrite via trade license + transaction history. |
| RLS misconfiguration | Mandatory RLS template per migration. Supabase linter in CI. Security-definer `has_role()` function. |
| Demo instability during investor pitch | Demo routes use local fixtures only. Zero network dependency. Tested in CI before every release. |
| Generic AI-looking UI | Section-specific color accents (Emerald/Blue/Amber). Noon/Okala visual references in design system. Native SwiftUI animations. |

### Additional risks beyond the BRD

| Risk | Severity | Mitigation |
|---|---|---|
| **Marketplace cold-start** | Critical | Launch with 10-15 anchor suppliers pre-loaded. Free BNPL credit for first 50 restaurants. Concierge-place orders on behalf of early restaurants. |
| **Native iOS limits Android reach** | High | 60% of UAE food-service decision-makers use iPhone. iOS first, Android within 6 months. Web ordering as interim bridge. |
| **Supabase scaling limits** | Medium | Pro plan handles 10K+ concurrent connections. Monitor connection pooling. Migration path to self-hosted Supabase if needed. |
| **BNPL regulatory risk** | High | UAE Central Bank regulates credit. Partner with licensed lender. Sofrino is the marketplace layer, not the lender. |
| **Supplier catalog quality** | High | AI-assisted onboarding. Dedicated catalog QA for first 6 months. Minimum image/data quality threshold to go live. |
| **Chef adoption resistance** | Medium | WhatsApp is entrenched. Sofrino must be easier, not just better. Reorder in 3 taps vs. typing a WhatsApp message. |
| **Arabic/RTL complexity** | Medium | Design Arabic-first from day one. Budget 20% more QA time. Use SwiftUI's native RTL support. |
| **Price war with funded competitor** | Medium | Defensibility is credit data + logistics, not price. Double down on BNPL and cold-chain if competitor launches. |

---

## 9. Improvements Beyond the Business Plan

### 9.1 Standing Orders (Subscription Ordering)

Restaurants set recurring orders (e.g., "20kg chicken breast every Tuesday and Friday") that auto-place unless modified. Increases order frequency without requiring daily app opens. Reduces churn. Suppliers get predictable demand. **Include in V1.**

### 9.2 Smart Reorder with Predictive Suggestions

ML model analyzes order history and suggests a pre-filled cart: "Based on your last 4 Mondays, here's your likely order." Reduces cognitive load. Increases basket size. **Post-launch (needs 3+ months of data).**

### 9.3 Price Intelligence Dashboard

Show buyers: "You paid AED 45/kg for lamb last month. Market average is AED 41/kg. 3 suppliers offer it at AED 39/kg." Builds trust through transparency. Drives switching to competitive suppliers. **Phase 3.**

### 9.4 Group Purchasing Organizations (GPOs)

Small restaurants in the same area form buying groups to unlock volume pricing. Levels the playing field vs. chains. Creates community lock-in. **Post-launch V2.**

### 9.5 Recipe Costing Tool

Chef inputs a dish recipe. Sofrino calculates ingredient cost based on current supplier prices. Suggests cheaper alternatives. Ties procurement directly to profitability. **Post-launch V2.**

### 9.6 Waste Reduction Insights

Compare ordered quantities vs. historical usage. Flag potential over-ordering. Reduces food waste (ESG angle for investors). Saves restaurants money. **Post-launch (needs data).**

### 9.7 Supplier Financing (Reverse Factoring)

Sofrino pays suppliers immediately (at a discount). Collects from restaurants on Net-30/60 terms. Suppliers get instant cash flow. Sofrino earns the spread. **Phase 3+ (requires lending partner).**

### 9.8 Kitchen Display Integration

API connects to kitchen display systems to auto-trigger reorders when prep lists are generated. Eliminates manual ordering for routine items. **V2+ (requires POS partnerships).**

### 9.9 Delivery Time Guarantees with Penalties

Suppliers commit to delivery windows. Late deliveries trigger automatic credits to the buyer. Reliability is the #1 complaint in manual procurement. **Include in V1 (even if soft/manual initially).**

### 9.10 Seasonal Calendar + Pre-Booking

Surface upcoming seasonal ingredients (Ramadan dates, Eid lamb, summer mangoes) with pre-booking at locked prices. Helps restaurants plan. Creates engagement spikes around cultural moments. **Post-launch, timed to Ramadan 2027.**

---

## Document Control

This product vision is the strategic companion to the Sofrino BRD v1.0 (June 2026). It supersedes BRD decisions on tech stack (native SwiftUI replaces Capacitor) and adds product improvements not covered in the original document. All feature scope remains governed by the BRD unless explicitly overridden here.
