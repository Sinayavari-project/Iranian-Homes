# Sofrino Home Screen — Complete Design Specification

*Version 1.0 | July 2026*

---

## Design Intent

Most B2B apps open to a dashboard — tables, KPIs, sidebar navigation. Most consumer apps open to a feed — content cards stacked vertically. Sofrino's home screen is neither.

It is a **living surface** — a single scrollable canvas where every element is aware of time, context, and urgency. The screen reorganizes itself based on what matters right now. At 6am it surfaces today's incoming deliveries. At 10pm it becomes a rapid ordering surface. At month-end it highlights spending trends and credit utilization. The chef never has to think about where to go. The home screen already knows.

The visual language draws from three spatial concepts:

1. **The Table** — content is laid out like items on a well-set restaurant table. Cards float at varying depths with deliberate asymmetry. Nothing is locked to a rigid grid.
2. **The Morning Brief** — information is presented in the order a chef thinks about it: what's arriving, what's urgent, what to order, what's changing, what's new.
3. **The Living Kitchen** — the screen breathes. Subtle ambient motion signals that data is live. Nothing is static. Nothing is dead.

---

## Screen Architecture

The home screen is a single continuous scroll with no pagination, no tabs within the page, and no collapsible sections. Content flows in this fixed order:

```
┌─────────────────────────────────┐
│  Status Bar (system)            │
│─────────────────────────────────│
│  Navigation Bar (transparent)   │
│  ┌─ Section Switcher ─────────┐│
│  └─────────────────────────────┘│
│─────────────────────────────────│
│                                 │
│  ░░░ Animated Hero ░░░░░░░░░░░ │
│  ░░░ (Time-Aware Greeting) ░░░ │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                 │
│  ┌─ Urgent Ribbon ────────────┐ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ Today's Deliveries ──────┐ │
│  │  (Horizontal timeline)    │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ Live Market ─┐ ┌─ Spend ─┐ │
│  │  Pulse        │ │  Trend  │ │
│  └───────────────┘ └─────────┘ │
│                                 │
│  ┌─ Price Movements ─────────┐ │
│  │  (Stacked ticker cards)   │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ Reorder Surface ─────────┐ │
│  │  (Your last order)        │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ Trending Products ───────┐ │
│  │  (Floating card carousel) │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ Recommended Suppliers ───┐ │
│  │  (Depth-stacked cards)    │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ AI Procurement Card ─────┐ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ Weekly Recap Orb ────────┐ │
│  └────────────────────────────┘ │
│                                 │
│  (80pt bottom padding)         │
│                                 │
└─────────────────────────────────┘
```

Total scroll depth: approximately 2,800pt of content on a typical data-populated account. First-time users with no data see a compressed version (~1,400pt) with empty states replaced by onboarding prompts.

---

## Section 1: Navigation Chrome

### Navigation Bar

- **Initial state:** Fully transparent. No background, no border. Status bar content over the hero.
- **On scroll (past hero):** Glass material fades in over 20pt of scroll distance (opacity 0→1). Section-tinted ultra-thin material. Top border: 0.5pt `neutral-200` at 20% opacity.
- **Left element:** Sofrino wordmark, 20pt height, `neutral-900`. Fades to compact "S" monogram (16pt) when glass activates.
- **Right elements:** Two icon buttons, 44pt touch targets.
  - Notification bell — SF Symbol `bell.fill` when unread, `bell` when clear. Unread count badge (red, 18pt circle). Bell has a subtle 2-degree rotation animation (pendulum, 2s cycle) when there are unread notifications. Stops when read.
  - Profile avatar — 28pt circle, user's uploaded photo or initials on section-accent gradient. 2pt white border.

### Section Switcher

- **Position:** Below navigation bar, horizontal center, 36pt height.
- **Visual:** Three-segment pill on `neutral-100` background, 18pt fully-rounded corners.
- **Segments:** "Restaurant" (Emerald) / "Imports" (Blue) / "Market" (Amber).
- **Active indicator:** Filled pill slides between segments. Spring animation: `response: 0.4, dampingFraction: 0.75` — slightly bouncy, noticeable but not playful.
- **Color transition:** When switching sections, four things happen simultaneously over 300ms:
  1. Active pill slides to new position
  2. Pill fill color cross-fades to new section accent
  3. Tab bar glass tint cross-fades
  4. Hero gradient shifts to new section palette (see Hero section)
- **Haptic:** `UISelectionFeedbackGenerator` — one tick per segment crossed.
- **Scroll behavior:** Pins to top of screen (below navigation bar glass) when hero scrolls out. Snaps into pinned position with a subtle 1pt downward settle (spring, 150ms) that makes it feel like it landed.

---

## Section 2: Animated Hero — "The Dawn Surface"

This is the signature element. No other B2B app has anything like it.

### Concept

The hero is not an image carousel. It is not a banner ad. It is a **living gradient surface** that responds to time of day, tells the chef what kind of day it's going to be, and contains an AI-generated contextual greeting. The surface feels like looking through a window at the sky above a kitchen — abstract, warm, shifting.

### Dimensions

- **Height:** 280pt (measured from top of safe area to bottom of hero)
- **Width:** Full bleed, edge to edge, extends behind status bar and navigation bar
- **Bottom edge:** Asymmetric curve, not a straight line. A gentle sine-wave clip path with 16pt amplitude, creating a soft organic edge that the next section content tucks under.

### The Gradient System

The hero background is a multi-layered animated gradient. Three gradient layers composited together:

**Layer 1 — Time Gradient (base)**

Changes based on local time in UAE:

| Time | Left Color | Right Color | Feel |
|---|---|---|---|
| 5:00-7:00 | Warm peach `#FDDCB5` | Soft rose `#F5C6C6` | Dawn. The kitchen is waking up. |
| 7:00-11:00 | Cream `#FFF8E7` | Pale emerald `#D1FAE5` | Morning. Fresh produce arriving. |
| 11:00-15:00 | White `#FFFFFF` | Cool mint `#E0F7EF` | Midday. Clean, focused. |
| 15:00-18:00 | Warm gold `#FEF3C7` | Amber `#FDE68A` | Afternoon. Warm, energized. |
| 18:00-21:00 | Deep teal `#134E4A` | Dark emerald `#064E3B` | Evening. Time to order for tomorrow. |
| 21:00-5:00 | Near-black teal `#042F2E` | Charcoal `#1C1917` | Night. Subdued, focused. |

The transition between time bands is a 30-minute linear cross-fade. The user never sees a "switch" — colors drift imperceptibly, like a real sky.

**Dark mode override:** Evening and night gradients are used at all times. The time-based variation shifts within a darker, narrower range. Dawn/morning become muted navy/slate transitions.

**Layer 2 — Ambient Motion (midground)**

Two large, soft radial gradients (200pt radius, 0% opacity at edge) that drift slowly across the hero surface:

- Orb A: Section accent color at 15% opacity. Drifts on a Lissajous curve (period: 12s horizontal, 8s vertical). Amplitude: 40pt.
- Orb B: Complementary warm color at 10% opacity. Counter-phase to Orb A. Period: 10s horizontal, 14s vertical. Amplitude: 30pt.

These create a gentle, organic breathing motion. The hero never looks the same twice.

**Layer 3 — Noise Texture (foreground)**

A subtle static noise overlay at 3% opacity, blended `overlay`. This breaks the digital smoothness of the gradients and adds a tactile, almost paper-like quality. The noise is a pre-rendered 256×256 tileable texture — not generated at runtime.

### Section Color Influence

When the user switches sections, the gradient's accent orb (Layer 2, Orb A) shifts color:
- Restaurant: Emerald tones
- Imports: Blue tones
- Supermarket: Amber tones

The base time gradient (Layer 1) remains the same — anchoring the screen in real time regardless of section.

### AI Greeting

Positioned within the hero, vertically centered in the lower 60% of the hero area.

**Layout:**
- Greeting line: `display-xl` (34pt Bold), white (or `neutral-900` in daytime light themes)
- Context line: `body-lg` (17pt Regular), white at 80% opacity (or `neutral-600` in daytime)
- Left-aligned, 20pt left margin

**Greeting Content (AI-generated, examples):**

Morning, no pending orders:
> **Good morning, Chef Khalid**
> Your kitchen is fully stocked. 3 deliveries arriving by 8am.

Evening, reorder due:
> **Evening, Khalid**
> Chicken and dairy are running low based on your usual pace. Reorder?

First day of Ramadan:
> **Ramadan Kareem, Khalid**
> 4 suppliers have Ramadan specials live. Your iftar prep order is ready to review.

Payday week:
> **It's a strong month**
> You've saved AED 2,340 vs. last month by switching tomato suppliers. Nice move.

New user, first session:
> **Welcome to Sofrino**
> Let's set up your kitchen. It takes 3 minutes.

**Greeting rules:**
- Generated server-side by Claude API based on: user name, time of day, order history, pending deliveries, market events, cultural calendar (Ramadan, Eid, National Day).
- Falls back to a static time-based greeting if the API is unavailable: "Good morning" / "Good afternoon" / "Good evening" + user's first name.
- Maximum 2 lines. The greeting is a haiku, not a paragraph.
- **Never generic.** "Welcome back" is banned. Every greeting references something specific.
- Refreshes on app foreground. Does not refresh while the app is actively in use.

### Greeting Animation

- On appear: greeting text fades in (opacity 0→1, 400ms) with a slight upward drift (8pt over 400ms, ease-out). The greeting line appears first, context line follows 100ms later.
- On scroll: text parallaxes upward at 70% of scroll speed (moves out faster than the gradient, creating depth separation). Fades to 0 opacity by the time the hero is 50% scrolled off.
- The gradient surface itself parallaxes at 40% of scroll speed — it moves the slowest, feeling like a distant sky.

### Hero Interaction

- **Tap on greeting context line** (when it contains an actionable suggestion like "Reorder?"): The greeting card gently pulses (scale 1.0→1.02→1.0, 200ms) and navigates to the relevant screen (reorder flow, specials page, etc.). Haptic: `.light`.
- **Long-press on hero surface:** A subtle radial ripple emanates from the touch point — the ambient orbs briefly pull toward the finger like a gravity well (300ms, spring back over 500ms). This is pure delight. No function. It rewards curiosity.

---

## Section 3: Urgent Ribbon

### Concept

A narrow, attention-grabbing horizontal strip that only appears when there is something time-sensitive. If nothing is urgent, this section doesn't render — no empty state, no placeholder. It simply doesn't exist, and the deliveries section moves up.

### Dimensions

- **Height:** 52pt
- **Width:** Full width minus 16pt margins (screen-inset card)
- **Corner radius:** 12pt
- **Vertical position:** 20pt below the hero's curved bottom edge. The card tucks slightly under the hero curve, creating a layered depth effect.

### Visual Design

- **Background:** `error-subtle` (light) / dark red-tinted surface (dark). A 1pt left border in `error` color — the urgency bar.
- **Layout:** Leading icon (SF Symbol `exclamationmark.triangle.fill`, `error` color, 18pt) → message text (`body-md`, `neutral-800`) → trailing action text (`label-md`, `error`, acts as button) → trailing chevron.
- **Shadow:** `depth-raised` — this card floats above the hero's trailing edge, catching light.

### Content Examples

| Trigger | Message | Action |
|---|---|---|
| Unconfirmed order from supplier | "Al Madina hasn't confirmed your 6am delivery" | "Contact" |
| BNPL payment due tomorrow | "AED 3,200 payment due tomorrow" | "Pay now" |
| Supplier price increase >10% | "Emirates Dairy increased milk price by 14%" | "Review" |
| Delivery missed ETA | "Your 7am meat delivery is 45 min late" | "Track" |
| Trade license expiring in 7 days | "Your trade license expires in 6 days" | "Renew" |

### Multiple Urgencies

If more than one urgent item exists:
- The ribbon becomes a horizontally-paging carousel, 52pt height maintained.
- A page indicator: 3 dots, `neutral-300` inactive, `error` active, centered below, 4pt dot diameter, 6pt gap.
- Auto-advance every 5s. Pauses on touch.
- Maximum 3 items. If more than 3, the third reads: "2 more urgent items" → tapping opens a full list.

### Ribbon Animation

- **On appear (scroll into view):** Slides in from the trailing edge (right in LTR) with spring animation (250ms, damping 0.8). The urgency icon has a single shake animation on appear (rotate -5°→5°→0°, 300ms).
- **Dismiss:** Swipe right (LTR) / left (RTL) to dismiss. Card slides out with velocity-matched spring. Dismissed items don't reappear for 4 hours.
- **Haptic:** `.warning` notification feedback on first appear. No haptic on subsequent views in the same session.

---

## Section 4: Today's Deliveries — "The Timeline"

### Concept

Not a list. Not a table. A **horizontal timeline** that visualizes the day's deliveries as events on a time axis. The chef sees at a glance: what's coming, when, and from whom. This is the first thing that matters each morning.

### Dimensions

- **Total height:** 180pt
- **Section header:** "Today's Deliveries" — `title-lg` (20pt Semibold), left-aligned, 16pt left margin. Right-aligned: "See all" tertiary button.
- **Timeline area:** 140pt height, horizontally scrollable

### Timeline Structure

**Time axis:**
- A horizontal line, 1pt thick, `neutral-200`, positioned at 100pt from the section top (60% down the timeline area).
- Time labels below the line: `mono-sm` (13pt), `neutral-400`. Spaced at 2-hour intervals: "6am · 8am · 10am · 12pm · 2pm".
- A "now" indicator: vertical dashed line, section accent, 2pt wide, with a small filled circle (8pt) on the time axis. "Now" label below in `label-sm`, accent color. This indicator is fixed relative to the current time — the timeline scrolls behind it.

**Delivery nodes:**
- Each delivery is a card floating above the timeline, connected to its time slot by a thin vertical line (1pt, `neutral-200`).
- Card dimensions: 140pt wide × 80pt tall, 10pt corner radius.
- Card content:
  - Supplier logo: 24pt circle, top-left of card, 8pt inset.
  - Supplier name: `label-md`, 1-line truncate, right of logo.
  - Item count: `body-sm`, `neutral-500`. "8 items".
  - Status pill: bottom of card, full-width, 20pt height. Color-coded:
    - Confirmed: `success-subtle` bg, `success` text, "Confirmed ✓"
    - In Transit: `info-subtle` bg, `info` text, "In Transit →"
    - Delivered: `neutral-100` bg, `neutral-500` text, "Delivered ✓"
    - Delayed: `warning-subtle` bg, `warning` text, "Delayed 45m"
- Card shadow: `depth-subtle` for future deliveries. `depth-raised` for the "next" delivery (nearest in time).

**The "next delivery" card:**
- The delivery nearest in the future is visually elevated: scale 1.05, `depth-raised` shadow, and a subtle pulsing border (section accent at 30% opacity, pulsing to 60% and back over 3s).
- This card is auto-scrolled into view on screen load.

### Timeline Interaction

- **Horizontal scroll:** Free scroll along the time axis. Momentum scrolling with rubber-band at edges.
- **Tap delivery card:** Card lifts (scale 1.0→1.03, shadow `depth-raised`→`depth-floating`, 150ms spring) then pushes to delivery detail screen via hero transition (card morphs into detail view header).
- **Long-press delivery card:** Haptic `.heavy`, card tilts slightly toward touch point (3D rotation, 2°), context menu appears above with options: "Track," "Contact Supplier," "View Order."
- **Parallax within scroll:** Delivery cards above the time axis move horizontally at 100% scroll speed. Time axis labels move at 85%. The "now" indicator stays pinned (0% — it doesn't scroll horizontally; instead, the timeline scrolls past it). This creates a layered depth effect within the horizontal scroll.

### Empty State (No Deliveries Today)

Timeline axis still renders, but no nodes. Center of timeline area shows:
- Icon: SF Symbol `shippingbox` (line art), 40pt, `neutral-300`
- Text: "No deliveries scheduled today" — `body-md`, `neutral-400`
- No CTA button — this isn't something to fix; it's informational.

---

## Section 5: Live Market Pulse + Spend Trend — "The Twin Orbs"

### Concept

Two square cards side by side, equal width, each containing a single data visualization. They provide ambient market intelligence — the kind of information that a chef absorbs at a glance without needing to analyze.

These cards have a unique visual treatment: **glass-morphic surfaces with subtle inner shadows**, making them feel like they're recessed into the page — the opposite of floating cards. This creates a visual rhythm: the hero floats above, the ribbon floats above, but these data surfaces feel embedded, like instruments in a dashboard.

### Dimensions

- **Layout:** 2-column, equal width, 12pt gap between cards
- **Card size:** (screen width - 16 - 16 - 12) / 2 = ~174pt each on iPhone 15. Aspect ratio: 1:1 (square).
- **Corner radius:** 16pt
- **Margins:** 16pt left and right screen margins

### Card A — Live Market Pulse

**Purpose:** Shows how active the market is right now. Is it a busy ordering day? Are suppliers getting slammed or is it quiet?

**Visual:**
- Background: `neutral-50` with a subtle inner shadow (inset 2pt, blur 8pt, `rgba(0,0,0,0.06)`)
- Center element: A radial pulse visualization — a series of concentric circles emanating from a center point, like sonar:
  - Center dot: 8pt, section accent, solid
  - Ring 1: 24pt diameter, section accent at 40% opacity, 1pt stroke
  - Ring 2: 48pt diameter, section accent at 25% opacity, 1pt stroke
  - Ring 3: 72pt diameter, section accent at 15% opacity, 1pt stroke
  - Rings animate outward in a continuous loop: each ring expands from the center dot size to its full diameter over 3s, fading as it grows. Rings are staggered 1s apart, so there's always a ring mid-expansion. Speed scales with market activity — busier = faster pulse (range: 2s to 5s cycle).
- Bottom label: "Market Activity" — `label-sm`, `neutral-500`, centered
- Top-right corner: activity level text — "High" / "Moderate" / "Quiet" — `label-md`, color-coded (`success` / `warning` / `neutral-400`)
- Below activity level: "342 orders/hr" — `mono-sm`, `neutral-500`

**Data source:** Aggregate anonymized order volume across the Sofrino marketplace. Updates every 60 seconds. The chef doesn't act on this — it's ambient. It makes the marketplace feel alive.

### Card B — Spend Trend

**Purpose:** Am I spending more or less than usual this month?

**Visual:**
- Background: same recessed glass treatment as Card A
- Center element: A sparkline area chart showing daily spend for the current month
  - X-axis: implied (no labels in this compact view). 30 data points, one per day.
  - Y-axis: implied. Area fill: section accent at 10% opacity. Line: 2pt, section accent.
  - Today's point: emphasized with a 6pt dot, section accent.
  - Previous month comparison line: 1pt dashed, `neutral-300`. Provides context without labeling.
- Top-left: "This Month" — `label-sm`, `neutral-500`
- Below it: "AED 24,850" — `display-md` (22pt Semibold), `neutral-900`
- Bottom-left: Trend indicator — "↑ 12% vs last month" — `body-sm`. Arrow and text color: `error` if spending up (red = spending more is bad), `success` if spending down. This is intentional — in procurement, spending less is the win.

### Twin Orbs Interaction

- **Tap Card A (Market Pulse):** Expands to a full-screen market dashboard (hero transition — the pulse visualization scales up and becomes the header of the detail screen).
- **Tap Card B (Spend Trend):** Expands to a full spending analytics screen with daily breakdown, category split, and supplier comparison.
- **3D tilt:** Both cards respond to device gyroscope with a very subtle parallax (the inner visualization shifts 2pt opposite to device tilt). Disabled when Reduce Motion is on. This makes the recessed "instrument" metaphor feel physical.
- **Scroll parallax:** Both cards scroll at 95% of content scroll speed (content above and below scrolls at 100%), creating a subtle "heavier" feel — like they have more mass.

---

## Section 6: Price Movements — "The Ticker"

### Concept

A vertical stack of compact price-change cards, inspired by stock market tickers but warmer and food-specific. The chef sees at a glance which ingredients are getting more expensive and which are dropping — without opening a separate analytics screen.

### Section Header

- "Price Movements" — `title-lg`, left-aligned
- Right side: "Last 7 days" — `body-sm`, `neutral-500` — acts as a filter button (tap to cycle: 7 days / 30 days / 90 days)
- 8pt below header: a horizontal rule, 1pt, `neutral-150`

### Ticker Card Design

Each card represents one product whose price has changed significantly (>5% in the selected period).

- **Height:** 64pt
- **Width:** Full width minus 32pt (16pt margins)
- **Corner radius:** 12pt
- **Background:** `neutral-0` (light) / `neutral-100` (dark)
- **Shadow:** `depth-subtle`
- **Layout:**
  - Left: Product thumbnail, 44×44pt, 8pt radius. If no image: category icon on `neutral-100` circle.
  - Center-left:
    - Product name: `title-sm` (15pt Medium), 1-line truncate. "Chicken Breast"
    - Category: `body-sm`, `neutral-500`. "Poultry · per kg"
  - Center-right:
    - Current price: `mono-lg` (17pt), `neutral-900`. "AED 32.50"
    - Previous price: `mono-sm` (13pt), `neutral-400`, strikethrough. "AED 28.00"
  - Right: Change badge
    - Up arrow + percentage: "↑ 16%" — `error` text on `error-subtle` background
    - Down arrow + percentage: "↓ 8%" — `success` text on `success-subtle` background
    - Badge dimensions: auto-width, 28pt height, 14pt corner radius (fully rounded)

### Stacking and Depth

Cards are stacked vertically with 8pt gap. But here's the distinctive detail: **cards are sorted by magnitude of change, and the visual depth decreases down the stack.**

- Card 1 (biggest change): Full opacity, `depth-raised` shadow, positioned at z-0.
- Card 2: 98% opacity, `depth-subtle` shadow, visually 1pt "further back" (scale 0.995).
- Card 3: 96% opacity, `depth-subtle` shadow, scale 0.99.
- Card 4+: Same as card 3. No further diminishing.

This creates a sense that the most volatile items are "jumping forward" to demand attention.

Maximum displayed: 5 cards. If more exist, a "See all price changes →" tertiary button appears below.

### Ticker Interaction

- **Tap card:** Hero transition to product detail, where a full price history chart is the first element. The price badge from the ticker card morphs into the chart header.
- **Swipe card left:** Reveals two action buttons (64pt each):
  - "Order" (section accent) — adds the product to cart at current price
  - "Alert" (info blue) — sets a price alert for when this product drops back below the previous price
- **On appear (scroll into view):** Cards stagger in from the trailing edge with 50ms delay per card. Spring animation: 250ms, damping 0.82. The change badges count up from 0% to their final value (number animation, 300ms, ease-out).
- **Haptic:** None on appear. Light tap on card press.

---

## Section 7: Reorder Surface — "One-Tap Replay"

### Concept

The single most important conversion element on the screen. This section shows the chef's most recent order and lets them place the same order again with a single tap. It eliminates the need to browse, search, or remember what was ordered.

The card is visually distinct from everything else on the screen — larger, more prominent, and treated with a premium material.

### Dimensions

- **Height:** 220pt (content-adaptive, max 260pt)
- **Width:** Full width minus 32pt margins
- **Corner radius:** 16pt — larger than standard cards, signaling importance
- **Shadow:** `depth-raised` in light mode. In dark mode, a 1pt border of `neutral-200` replaces the shadow.

### Visual Design

**Background:** A subtle gradient from `neutral-0` to `neutral-50` (top to bottom in light mode). In dark mode: `neutral-100` to `neutral-150`. This gradient is barely visible but gives the card a sense of internal depth.

**Header row (top of card):**
- Left: "Last Order" — `label-md`, `neutral-500`, uppercase
- Right: Date — `body-sm`, `neutral-400`. "Tuesday, July 8"

**Supplier row (below header, 12pt gap):**
- Supplier logo: 32pt circle
- Supplier name: `title-md` (17pt Semibold)
- Order number: `mono-sm`, `neutral-400`. "#4521"

**Items preview (below supplier, 16pt gap):**
- A horizontal row of product thumbnails, overlapping by 8pt (like stacked avatars):
  - Each thumbnail: 44×44pt, 8pt radius, 2pt white border
  - Maximum 5 thumbnails visible
  - If more items: the 5th position shows a `neutral-200` circle with "+3" in `label-sm`
  - Thumbnails have a slight upward stagger: each subsequent thumbnail is 2pt higher than the previous, creating a casual "spread on the table" feeling

**Total row (below items, 12pt gap):**
- Left: Item count — `body-md`, `neutral-600`. "8 items"
- Right: Total — `display-md` (22pt Semibold), `neutral-900`. "AED 1,847.50"

**Reorder button (bottom of card, full internal width, 16pt card padding):**
- Size: XL (56pt height), full internal card width
- Corner radius: 14pt
- Background: Section accent gradient (e.g., `emerald-500` to `emerald-600`, 45-degree angle)
- Label: "Reorder" — `label-lg` (15pt Medium), white. Leading icon: SF Symbol `arrow.clockwise` (14pt).
- This button has a special resting-state animation: a subtle shimmer passes across the gradient surface every 4 seconds — a 60pt-wide white highlight at 8% opacity sweeps left to right over 1.2s. This draws the eye without being aggressive. It signals: "This is the thing to tap."

### Reorder Interaction

- **Tap "Reorder" button:**
  1. Button press state: scale 0.97, opacity 0.85 (80ms)
  2. Haptic: `.medium` impact
  3. Spring back (200ms)
  4. A confirmation sheet slides up (half-detent):
     - Shows all items with current quantities
     - "Any changes?" header
     - Each item has an inline quantity stepper
     - "Place Order" primary button at bottom
     - Price is recalculated live if quantities change
  5. If the chef taps "Place Order" without changes: order submits optimistically. Sheet dismisses. Order confirmation celebration plays (see Microinteractions in design system).
  
- **Tap anywhere else on the card** (not the button): Pushes to the original order detail screen. The item thumbnails morph into the full order item list (hero transition).

- **Card 3D press:** On press-down, the card tilts subtly toward the touch point (max 2° rotation on each axis, `rotation3DEffect` with perspective 0.5). Combined with scale 0.98. Creates a physical "pressing into the table" feeling. Spring return on release.

### Empty State (No Previous Orders)

If the user has never ordered:
- Same card dimensions and background
- Center content:
  - SF Symbol `bag.fill.badge.plus`, 48pt, section accent at 30% opacity
  - "Place your first order" — `title-lg`, `neutral-800`
  - "Browse our catalog of verified suppliers" — `body-md`, `neutral-500`
  - Primary button: "Start Shopping" — standard LG size

---

## Section 8: Trending Products — "The Float"

### Concept

A horizontal carousel of product cards that feel like they're floating above the page. Each card has its own subtle shadow and a slight vertical offset variation — no two cards sit at the same y-position. This creates the "items spread on a table" effect mentioned in the Design Intent.

### Section Header

- "Trending This Week" — `title-lg`, left-aligned
- Subheading: "Popular with restaurants near you" — `body-sm`, `neutral-500`
- No "See all" link — the carousel itself is the discovery mechanism.

### Carousel Mechanics

- **Layout:** Horizontal scroll, snap-to-card behavior
- **Card width:** 200pt
- **Card height:** 260pt
- **Gap:** 16pt between cards
- **Leading inset:** 16pt (aligns first card to screen margin)
- **Trailing overflow:** The last card is partially visible (cut off at ~60%), signaling that more content exists. No pagination dots.

### Floating Card Design

Each card has a unique vertical offset within the carousel track:
- Card 1: y-offset 0pt (baseline)
- Card 2: y-offset -8pt (floats higher)
- Card 3: y-offset +4pt (sits lower)
- Card 4: y-offset -12pt (highest)
- Card 5: y-offset +2pt
- Pattern repeats with variation. The offsets follow no strict mathematical pattern — they are hand-tuned to feel organic, like items placed by hand.

**Card content:**
- **Image:** Top 60% of card (156pt height), edge-to-edge within card, 10pt top corner radius. High-quality product photography.
- **Content area:** Bottom 40% (104pt), 12pt horizontal padding.
  - Product name: `title-md`, 2-line max, truncate. "Wild-Caught Norwegian Salmon"
  - Price: `mono-lg`, `neutral-900`. "AED 89.00 / kg"
  - Trend indicator: small sparkline (32pt wide × 16pt tall), accent color, showing 7-day order volume trend. Positioned right of price.
  - Supplier: `body-sm`, `neutral-500`, 1-line. "Nordic Seafood Co."
- **Shadow:** `depth-raised`. Each card casts its own distinct shadow, and because of the y-offset variation, the shadows create a natural depth hierarchy.
- **Corner radius:** 14pt

### Float Interaction

- **Scroll:** Horizontal momentum scroll with card snapping. Deceleration is slightly slower than default — cards "glide" to their resting position, feeling weightier and more premium.
- **Active card:** The card nearest to horizontal center at rest gets a subtle scale-up (1.0→1.03, 200ms spring) and shadow intensification (`depth-raised`→`depth-floating`). Creates a "spotlight" feel.
- **Tap card:**
  1. Card lifts: scale 1.03→1.06, shadow intensifies (200ms)
  2. Hero transition to product detail: card image morphs into detail header image. Card body content cross-fades to detail content.
  3. Haptic: `.light`
- **Long-press card:** Context menu with quick actions: "Add to Cart," "Save to Favorites," "Compare Prices."
- **Parallax within carousel:** Product images have a subtle horizontal parallax during carousel scroll — the image pans 10pt within its frame as the card moves through the viewport. This creates a "looking through a window" effect. The image feels like it exists in a space behind the card frame.

---

## Section 9: Recommended Suppliers — "The Deck"

### Concept

Supplier cards stacked in a deck, overlapping vertically like a hand of cards fanned on a table. The top card is fully visible; cards behind it peek out, showing just enough (logo and name) to create curiosity. The user can swipe through the deck or tap to expand.

### Section Header

- "Recommended for You" — `title-lg`, left-aligned
- Subheading: "Based on your order history" — `body-sm`, `neutral-500`

### The Deck Layout

- **Container height:** 240pt
- **Cards in deck:** 5 supplier cards
- **Top card:** Fully visible, positioned at y: 0
- **Card 2:** Visible top 32pt (peeking behind card 1), y-offset: -16pt from bottom of card 1
- **Card 3:** Visible top 24pt, y-offset: -12pt from bottom of card 2
- **Card 4-5:** Visible top 16pt each, increasingly blurred (1pt → 2pt Gaussian blur)

Each peeking card shows just the supplier's logo (left) and name (right) in the visible strip — enough to identify who they are.

### Supplier Card Design (Expanded / Top of Deck)

- **Height:** 200pt
- **Width:** Full width minus 32pt margins
- **Corner radius:** 16pt
- **Background:** White (light), `neutral-100` (dark)
- **Shadow:** `depth-floating` for the top card

**Layout:**
- **Banner image:** Full-width, 80pt height, top of card. Shows the supplier's warehouse/storefront or a curated product collage. 16pt top corners rounded.
- **Verified badge:** If verified, a gold checkmark seal (24pt) positioned on the banner's bottom-right, overlapping the banner/content boundary.
- **Logo:** 48pt circle, 3pt white border, positioned left-aligned, overlapping the banner bottom edge by 24pt.
- **Content area (below banner, right of logo):**
  - Supplier name: `title-lg`. "Al Madina Foods"
  - Category: `body-sm`, `neutral-500`. "Meat & Poultry · Dairy"
  - Rating: Star icon (14pt, `amber-400`) + "4.8" (`body-sm`, `neutral-700`) + "(124 orders)" (`body-sm`, `neutral-400`)
- **Bottom row (20pt below content):**
  - Delivery badge: Truck icon + "Next-day delivery" — `label-md`, `success`, on `success-subtle` pill
  - Min order: "Min AED 500" — `label-md`, `neutral-500`
- **"View Catalog" button:** Right-aligned in bottom row, secondary style, SM size.

### Deck Interaction

- **Swipe up on top card:** Top card flies off-screen upward (spring, 300ms, scale 0.9, opacity→0). Next card springs forward to top position. Deck shuffles up. Haptic: `.light`.
- **Swipe down (when cards have been swiped away):** Brings back the last dismissed card from the top. It drops down with a slight bounce.
- **Tap top card:** Hero transition to supplier profile. Banner image morphs into profile header.
- **Tap a peeking card:** The tapped card springs to the top of the deck, pushing cards above it off to the side (they slide out trailing, 200ms). Haptic: `.light`.
- **Deck exhausted (all 5 swiped away):** Shows a simple reload state: "Load more suppliers" text button. Tapping it re-deals 5 new cards with a fanning animation (cards fly in from above, stagger 50ms, spring with slight bounce).

---

## Section 10: AI Procurement Assistant — "The Orb"

### Concept

A single, distinctive card that serves as the entry point to Sofrino's AI-powered procurement assistant. This is not a chatbot button. It's a living element that signals intelligence — it already knows what you might need and offers a preview.

### Card Design

- **Height:** 140pt
- **Width:** Full width minus 32pt margins
- **Corner radius:** 20pt — the largest radius of any card on the screen, making it feel distinctly different
- **Background:** A rich, dark gradient unique to this component:
  - Light mode: `#1A1A2E` (deep navy) to `#16213E` (dark blue-gray), 135-degree angle
  - Dark mode: `#0D0D1A` to `#121220`, same angle
  - This card is always dark — even in light mode. It signals "this is AI territory."
- **Border:** 1pt, `credit-purple` at 20% opacity. Barely visible. Premium.
- **Shadow:** `depth-floating` with a slight purple tint: `rgba(124, 58, 237, 0.08)` instead of black.

**Content layout:**

**Left side (60% width):**
- Label: "AI Assistant" — `label-sm`, `credit-purple` (light purple), uppercase, tracking +0.4
- Suggestion: `body-lg`, white. A contextual suggestion from the AI:
  - "You usually order dairy on Wednesdays. Want me to prepare your cart?"
  - "I found 3 suppliers for organic chicken below your usual price."
  - "Your tomato usage is up 20% — should I increase your standing order?"
- CTA text: "Ask Sofrino →" — `label-md`, `credit-purple`, acts as button

**Right side (40% width):**
- **The AI Orb:** A 72pt diameter sphere visualization, vertically centered
  - Base: radial gradient circle from `credit-purple` at center to transparent at edge
  - Ambient animation: The orb "breathes" — scale 0.95→1.05→0.95 over 4s, infinite loop, with opacity modulation (70%→100%→70%)
  - Orbiting particles: 3 small dots (4pt each, white at 40% opacity) orbit the sphere on different elliptical paths, different speeds (3s, 5s, 7s periods). They represent data points being processed.
  - When the AI has a new suggestion: orb briefly brightens (100% opacity, scale 1.1) and emits a single pulse ring (like the Market Pulse visualization). 500ms, then returns to ambient state.

### Orb Interaction

- **Tap card:** Full-screen AI chat interface slides up from the card (hero transition — the orb morphs into the chat header icon, the suggestion text morphs into the first message bubble). The dark gradient background of the card expands to fill the screen.
- **Long-press orb:** The orbiting particles accelerate and converge to the center (300ms), then burst outward (200ms), and the AI generates a new suggestion. Pure delight — rewards curiosity.
- **Haptic:** `.rigid` on tap. The distinct feel signals "this is different from tapping a product."

---

## Section 11: Weekly Recap — "The Closing Orb"

### Concept

The final element on the home screen. A compact, ambient card that summarizes the week's activity in a single glanceable visualization. It's the "sign-off" — the feeling of reaching the bottom of a well-curated morning brief.

### Card Design

- **Height:** 120pt
- **Width:** Full width minus 48pt margins (narrower than other cards — inset further, signaling "end of content")
- **Corner radius:** 20pt
- **Background:** `neutral-50` (light) / `neutral-100` (dark)
- **Border:** 1pt, `neutral-150`. Subtle.

**Layout:**

**Left half — Mini donut chart:**
- 64pt outer diameter, 40pt inner diameter
- 3 segments: Produce (section accent), Meat (warm coral), Dairy (cool blue)
- Center: Total order count this week — `display-md`, `neutral-900`
- Below donut: "This week" — `label-sm`, `neutral-400`

**Right half — Stats column:**
- Line 1: "12 orders · AED 8,450" — `body-md`, `neutral-700`
- Line 2: "4 suppliers · 98% on-time" — `body-sm`, `neutral-500`
- Line 3: Trend vs. last week: "↓ 8% spend" — `body-sm`, `success`

### Recap Interaction

- **Tap:** Pushes to a full weekly report screen with detailed breakdowns.
- **On appear:** Donut chart segments animate clockwise from 12 o'clock (500ms, ease-out, staggered 100ms per segment). Stats fade in simultaneously (300ms).

---

## Scroll Behavior — "The Breathing Scroll"

### Global Scroll Physics

The home screen uses a custom scroll behavior that makes it feel distinct from a standard iOS scroll view:

**Deceleration rate:** 0.994 (slightly slower than iOS default of 0.998 for paging, faster than 0.99). Content has weight but doesn't feel sluggish. The chef can flick and know roughly where it will land.

**Rubber-band:** Standard iOS rubber-band at top and bottom. At the top, over-pulling reveals more of the hero gradient — the gradient extends 80pt above its normal position for this purpose.

**Scroll-linked animations:**
1. **Hero parallax:** Gradient scrolls at 40%, greeting text at 70%, content at 100%.
2. **Navigation bar glass:** Fades in between scroll position 0-60pt.
3. **Section switcher pin:** Pins at scroll position where the switcher reaches the navigation bar bottom.
4. **Card entrances:** Each section's cards animate in when they cross the lower 20% of the viewport (entry trigger). Animation: fade in (opacity 0→1, 200ms) + slide up (12pt vertical offset, 250ms spring). Once animated in, the card stays. No re-animation on scroll-back.
5. **Twin Orbs gyro parallax:** Active only when the orbs are fully in viewport. Deactivates when scrolled away (saves battery).

### Snap Points

No full-screen snap points. The scroll is continuous. However, the section switcher pins to the top, creating a natural resting position where the first content section (Urgent Ribbon or Deliveries) is at the top of the visible area.

### Performance

- **Target:** 120fps on ProMotion devices, 60fps on standard. Zero dropped frames during scroll.
- **Technique:** All scroll-linked animations use `scrollTargetBehavior` and `visualEffect` modifiers in SwiftUI — these run on the render server, not the main thread.
- **Image loading:** Product images in the Trending carousel and Supplier deck use progressive loading: low-res placeholder (16×16 upscaled with blur) → full-res. Transition: 200ms cross-fade.

---

## Contextual Adaptation

### Time-of-Day Personality

The home screen is not the same at 7am and 10pm. Beyond the hero gradient, section ordering and emphasis shift:

| Time | Emphasized Section | De-emphasized | Greeting Tone |
|---|---|---|---|
| 5am-9am | Deliveries (today's arrivals) | Trending (smaller) | Operational: "3 deliveries arriving" |
| 9am-2pm | Price Movements, Market Pulse | Reorder (collapsed) | Informational: "Chicken prices dropped 8%" |
| 2pm-6pm | Trending, Recommended Suppliers | Deliveries (collapsed if all delivered) | Discovery: "New supplier added in your area" |
| 6pm-11pm | Reorder Surface (largest), AI Assistant | Market Pulse (smaller) | Actionable: "Ready to order for tomorrow?" |
| 11pm-5am | Reorder only, everything else minimal | Most sections collapsed | Brief: "Quick reorder before close?" |

"Collapsed" means the section renders at 60% of its normal height with a "Show more" expand button. The content is still there — it's just de-emphasized to push the time-relevant sections higher.

### First-Time User

For users with no order history:
- Hero greeting: welcome + setup CTA
- Urgent Ribbon: hidden
- Deliveries: hidden
- Market Pulse + Spend: hidden (no data)
- Price Movements: shown (market data doesn't require user history)
- Reorder: replaced with "Place your first order" empty state card
- Trending: shown (curated editorial picks)
- Recommended Suppliers: shown (algorithm uses registered category preferences from onboarding)
- AI Assistant: suggestion is "Tell me what cuisine you serve and I'll recommend suppliers"
- Weekly Recap: hidden

Total scroll depth for new users: ~1,400pt. The screen doesn't feel empty — it feels curated and inviting.

---

## Accessibility

- **VoiceOver reading order:** Linear, top to bottom: Greeting → Urgent items → Deliveries (as a group, "3 deliveries today, first arriving at 6am from Al Madina") → Market Pulse ("Market activity is high, 342 orders per hour") → Spend Trend → Price changes → Reorder → Trending → Suppliers → AI Assistant → Weekly Recap.
- **Reduce Motion:** All ambient animations stop (hero orbs, market pulse, AI orb, shimmer on reorder button). Parallax disabled. Card entrances become simple fades (150ms). Carousel snapping still works. Hero gradient remains static at its current time-band colors.
- **Dynamic Type at XXL:** Cards reflow to full-width stacks. Twin Orbs become single-column. Trending carousel cards become list items. Minimum touch target maintained.
- **VoiceOver custom actions:** "Reorder" card has a custom action: "Place same order again" that triggers the confirmation flow directly.
