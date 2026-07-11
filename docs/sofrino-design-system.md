# Sofrino Design System

*Version 1.0 | July 2026*

The Sofrino design system exists to make B2B procurement feel like a luxury consumer experience. Every decision here serves one outcome: a chef in a hot kitchen, hands half-wet, places tomorrow's order in under 30 seconds and *enjoys doing it*.

---

## Design Philosophy

**Five words:** Precision. Warmth. Speed. Trust. Depth.

- **Precision** (from Linear, Stripe): Every pixel is intentional. Alignment is sacred. If two elements look like they might be aligned, they are aligned — or they are deliberately offset by exactly the spacing scale.
- **Warmth** (from Airbnb, Apple): B2B does not mean cold. Food is emotional. The palette is rich, the imagery is lush, the type is generous. This app handles produce, meat, spices — it should feel alive.
- **Speed** (from Linear, Arc): The UI responds before the finger lifts. Transitions are 200ms or less. Skeletons appear instantly. Nothing blocks. Speed is the most premium feature.
- **Trust** (from Stripe, Apple): Financial transactions require visual gravitas. Verified badges, consistent structure, clear hierarchy. When money moves, the UI communicates confidence.
- **Depth** (from Arc, Apple): Layered surfaces, subtle glass, parallax on scroll. The interface has physical presence — not flat, not skeuomorphic, but *spatial*.

### Design Axioms

1. **If it needs a label, redesign it.** Icons and layout should communicate before text does.
2. **Motion is information.** An element that slides in from the right came from the right. An element that scales up was selected. Animation is never decoration.
3. **Density is not clutter.** Show more information with better hierarchy, not bigger screens. A chef scanning a list of 40 products should find the one they need without scrolling.
4. **Color earns attention.** The base UI is near-monochrome. Color appears to signal: section identity, status, action, or delight.
5. **Touch targets are generous.** Minimum 44pt. Ideally 48pt. Chefs have large hands and imprecise grip. Miss-taps are the enemy.

---

## 1. Typography

### Typeface Selection

| Use | Typeface | Rationale |
|---|---|---|
| Primary (Latin) | **SF Pro** | Native iOS system font. Optical sizes, tabular figures, variable weight. Zero render cost. Apple-grade. |
| Primary (Arabic) | **SF Arabic** | Apple's matched Arabic companion. Same metrics, same weight range. True harmony in bilingual layouts. |
| Monospace | **SF Mono** | Order numbers, SKU codes, prices in tables. Tabular alignment is essential for procurement data. |
| Display (Marketing only) | **New York** | Serif accent for marketing headlines, investor decks, empty states. Warmth and editorial quality. Never in UI chrome. |

### Type Scale

Based on a 1.200 minor third ratio, anchored at 17pt body (Apple's recommended iOS body size).

| Token | Size (pt) | Weight | Line Height | Tracking | Use |
|---|---|---|---|---|---|
| `display-xl` | 34 | Bold (700) | 40 | -0.4 | Marketing hero, onboarding titles |
| `display-lg` | 28 | Bold (700) | 34 | -0.4 | Section headers, empty state titles |
| `display-md` | 22 | Semibold (600) | 28 | -0.2 | Screen titles in navigation bar |
| `title-lg` | 20 | Semibold (600) | 26 | 0 | Card group headers, modal titles |
| `title-md` | 17 | Semibold (600) | 22 | 0 | Card titles, list section headers |
| `title-sm` | 15 | Medium (500) | 20 | 0 | Subheadings, form section labels |
| `body-lg` | 17 | Regular (400) | 24 | 0 | Primary body text, product descriptions |
| `body-md` | 15 | Regular (400) | 20 | 0 | Secondary body, list item text |
| `body-sm` | 13 | Regular (400) | 18 | 0 | Captions, metadata, timestamps |
| `label-lg` | 15 | Medium (500) | 20 | 0.2 | Button labels, tab labels |
| `label-md` | 13 | Medium (500) | 18 | 0.2 | Badge text, tag labels |
| `label-sm` | 11 | Medium (500) | 14 | 0.4 | Overlines, tiny metadata |
| `mono-lg` | 17 | Regular (400) | 22 | 0 | Order totals, prices |
| `mono-md` | 15 | Regular (400) | 20 | 0 | SKU codes, order numbers |
| `mono-sm` | 13 | Regular (400) | 18 | 0 | Table cell data, timestamps |

### Arabic Typography Rules

- Arabic text uses SF Arabic at the same token sizes. No scaling adjustment needed — Apple has matched the optical sizes.
- Arabic body text line height increases by +2pt over Latin (e.g., `body-lg` Arabic = 26pt line height). Arabic script has taller ascenders and deeper descenders.
- Minimum Arabic body size: 15pt. Never use `body-sm` (13pt) for Arabic body text — only for metadata.
- Numbers in Arabic context remain Western Arabic numerals (0-9), not Eastern Arabic (٠-٩), matching UAE business convention.
- Mixed Arabic/Latin lines: Latin fragments inherit the Arabic line height, never the reverse.

### Typography Behavior

- **Truncation:** Single-line truncation with `…` after 90% of available width. Never truncate prices, quantities, or status labels.
- **Dynamic Type:** Support all iOS Dynamic Type sizes. Test at accessibility XXL. Layout must not break — it reflows.
- **Tabular figures:** Always enabled for prices, quantities, and any numeric column. Prices must align vertically in lists.

---

## 2. Spacing

### Spacing Scale

A 4pt base unit. Every dimension in the system is a multiple of 4.

| Token | Value | Use |
|---|---|---|
| `space-0` | 0pt | |
| `space-1` | 2pt | Hairline gaps, icon-to-label in compact badges |
| `space-2` | 4pt | Inline element gaps, icon padding |
| `space-3` | 6pt | Tight list item internal padding |
| `space-4` | 8pt | Default internal padding, gap between related elements |
| `space-5` | 12pt | Card internal padding (compact), list item padding |
| `space-6` | 16pt | Card internal padding (standard), section gaps |
| `space-7` | 20pt | Card internal padding (spacious), form field spacing |
| `space-8` | 24pt | Section separation within a screen |
| `space-9` | 32pt | Major section separation |
| `space-10` | 40pt | Screen-level top/bottom padding |
| `space-11` | 48pt | Large empty state padding |
| `space-12` | 64pt | Marketing/hero spacing |

### Layout Grid

- **Screen margin:** 16pt (iPhone), 20pt (iPhone Max/Plus)
- **Card grid gutter:** 12pt
- **Minimum card width:** 160pt (for 2-column product grid on smallest iPhone)
- **Maximum content width:** 428pt (iPhone 16 Pro Max width). Content never stretches beyond this on larger displays.

### Spacing Principles

- **Proximity = relationship.** Elements 8pt apart are related. Elements 24pt apart are distinct groups. Never use ambiguous spacing.
- **Horizontal rhythm:** Left-align all content to the screen margin. Right-aligned elements (prices, chevrons) snap to the opposite margin. Center-alignment only for empty states and modals.
- **Vertical rhythm:** Every vertical gap must be a spacing token. No arbitrary values. If a gap "looks wrong," adjust the token — don't add a magic number.

---

## 3. Color System

### Foundational Palette

#### Neutral Scale (Base UI)

The neutral palette is warm-tinted, not pure gray. A subtle warm undertone (2% toward amber) prevents the clinical coldness of pure gray and connects to the food/hospitality context.

| Token | Light Mode | Dark Mode | Use |
|---|---|---|---|
| `neutral-0` | `#FFFFFF` | `#000000` | Page background (light), true black (dark) |
| `neutral-50` | `#FAFAF8` | `#0C0C0B` | Elevated background, card surface |
| `neutral-100` | `#F5F5F2` | `#161614` | Secondary background, input fill |
| `neutral-150` | `#EDEDEA` | `#1E1E1B` | Subtle borders, dividers |
| `neutral-200` | `#E2E2DE` | `#2A2A26` | Borders, separators |
| `neutral-300` | `#CDCDC8` | `#3D3D37` | Disabled state borders |
| `neutral-400` | `#A8A8A2` | `#5C5C55` | Placeholder text, disabled icons |
| `neutral-500` | `#82827C` | `#7A7A73` | Secondary text, metadata |
| `neutral-600` | `#5C5C56` | `#A3A39C` | Body text (secondary) |
| `neutral-700` | `#3D3D38` | `#C4C4BE` | Body text (primary) |
| `neutral-800` | `#1E1E1B` | `#E2E2DE` | Headings, high-emphasis text |
| `neutral-900` | `#0C0C0B` | `#F5F5F2` | Maximum contrast text |
| `neutral-950` | `#000000` | `#FFFFFF` | True black text (light), white (dark) |

#### Section Accent Colors

Each marketplace section has a dedicated accent. The accent color is used sparingly — navigation indicators, primary CTAs, category tile tints, and status highlights. The accent never fills large surfaces.

**Restaurant Section — Emerald**

| Token | Light Mode | Dark Mode |
|---|---|---|
| `emerald-50` | `#ECFDF5` | `#022C22` |
| `emerald-100` | `#D1FAE5` | `#064E3B` |
| `emerald-200` | `#A7F3D0` | `#065F46` |
| `emerald-300` | `#6EE7B7` | `#047857` |
| `emerald-400` | `#34D399` | `#059669` |
| `emerald-500` | `#10B981` | `#10B981` | ← shared midpoint
| `emerald-600` | `#059669` | `#34D399` |
| `emerald-700` | `#047857` | `#6EE7B7` |

**Global Imports Section — Blue**

| Token | Light Mode | Dark Mode |
|---|---|---|
| `blue-50` | `#EFF6FF` | `#172554` |
| `blue-100` | `#DBEAFE` | `#1E3A5F` |
| `blue-200` | `#BFDBFE` | `#1E40AF` |
| `blue-300` | `#93C5FD` | `#2563EB` |
| `blue-400` | `#60A5FA` | `#3B82F6` |
| `blue-500` | `#3B82F6` | `#3B82F6` |
| `blue-600` | `#2563EB` | `#60A5FA` |
| `blue-700` | `#1D4ED8` | `#93C5FD` |

**Supermarket Section — Amber**

| Token | Light Mode | Dark Mode |
|---|---|---|
| `amber-50` | `#FFFBEB` | `#451A03` |
| `amber-100` | `#FEF3C7` | `#78350F` |
| `amber-200` | `#FDE68A` | `#92400E` |
| `amber-300` | `#FCD34D` | `#B45309` |
| `amber-400` | `#FBBF24` | `#D97706` |
| `amber-500` | `#F59E0B` | `#F59E0B` |
| `amber-600` | `#D97706` | `#FBBF24` |
| `amber-700` | `#B45309` | `#FCD34D` |

#### Semantic Colors

| Token | Light Mode | Dark Mode | Use |
|---|---|---|---|
| `success` | `#16A34A` | `#4ADE80` | Delivered, approved, in-stock |
| `success-subtle` | `#F0FDF4` | `#052E16` | Success background tint |
| `warning` | `#CA8A04` | `#FACC15` | Expiring, low stock, pending review |
| `warning-subtle` | `#FEFCE8` | `#422006` | Warning background tint |
| `error` | `#DC2626` | `#F87171` | Failed, rejected, out-of-stock |
| `error-subtle` | `#FEF2F2` | `#450A0A` | Error background tint |
| `info` | `#2563EB` | `#60A5FA` | Informational, tips, updates |
| `info-subtle` | `#EFF6FF` | `#172554` | Info background tint |

#### Special Colors

| Token | Value | Use |
|---|---|---|
| `verified-gold` | `#D4A853` (light), `#E8C36A` (dark) | Verified supplier badge, premium tier indicator |
| `credit-purple` | `#7C3AED` (light), `#A78BFA` (dark) | BNPL credit line, payment terms |
| `fresh-green` | `#22C55E` (light), `#4ADE80` (dark) | Fresh/organic product indicators |
| `frozen-cyan` | `#06B6D4` (light), `#22D3EE` (dark) | Frozen/cold-chain product indicators |

### Color Application Rules

1. **80/15/5 rule.** 80% neutral surfaces. 15% subtle tints and secondary elements. 5% accent color for CTAs and highlights.
2. **Section accent only in section context.** The emerald accent appears only when the user is in the Restaurant section. Switching sections transitions the accent color with a 300ms cross-fade.
3. **Semantic colors override section accents** for status indicators. A delivery status is always `success` green, never section emerald — even in the Restaurant section. No ambiguity.
4. **Text on colored backgrounds** must meet WCAG 2.1 AA contrast (4.5:1 for body text, 3:1 for large text). The `-50` and `-100` tints are designed as backgrounds for `-700` text. Pre-validated.
5. **Gradients** are reserved for: hero marketing surfaces, the section switcher pill, and premium badges. Never on standard UI chrome. When used, gradients span two adjacent stops on the accent scale (e.g., `emerald-400` to `emerald-600`).

---

## 4. Dark Mode

Dark mode is not an inversion — it is a redesign.

### Surface Hierarchy (Dark Mode)

| Level | Color | Use |
|---|---|---|
| Base | `neutral-0` (`#000000`) | True black. OLED power savings. Status bar, behind scroll content. |
| Ground | `neutral-50` (`#0C0C0B`) | Primary content background. Scroll views, lists. |
| Elevated | `neutral-100` (`#161614`) | Cards, sheets, modals. |
| Overlay | `neutral-150` (`#1E1E1B`) | Dropdown menus, popovers, nested cards. |

### Dark Mode Rules

- **No pure white text.** Maximum text brightness is `neutral-900` (`#F5F5F2`). Pure white (#FFF) is reserved for active icon highlights and the cursor.
- **Borders lighten, not darken.** Borders use `neutral-200` (`#2A2A26`) — visible but never harsh.
- **Shadows disappear.** In dark mode, depth is conveyed by surface color difference (elevated = lighter), not by shadows. Shadows on dark backgrounds look like rendering artifacts.
- **Accent colors shift warmer.** The dark mode accent palette is tuned brighter and slightly warmer to maintain vibrancy on dark surfaces without appearing neon.
- **Images dim 5%.** Product images receive a subtle `brightness(0.95)` filter in dark mode to prevent them from blowing out the visual hierarchy.
- **Glass materials increase opacity.** Ultra-thin material in dark mode uses 70% opacity (vs. 50% in light mode) to maintain legibility.

---

## 5. Light Mode

### Surface Hierarchy (Light Mode)

| Level | Color | Use |
|---|---|---|
| Base | `neutral-0` (`#FFFFFF`) | Primary background. Scroll views, lists. |
| Raised | `neutral-50` (`#FAFAF8`) | Cards that sit above the base. Subtle lift. |
| Inset | `neutral-100` (`#F5F5F2`) | Input fields, search bars, code blocks. Recessed feel. |
| Overlay | `#FFFFFF` + shadow | Modals, sheets, dropdown menus. Elevation via shadow. |

### Light Mode Rules

- **Shadows convey elevation.** Three shadow levels:
  - `shadow-sm`: `0 1px 2px rgba(0,0,0,0.04), 0 1px 3px rgba(0,0,0,0.06)` — cards, list items
  - `shadow-md`: `0 4px 8px rgba(0,0,0,0.06), 0 2px 4px rgba(0,0,0,0.04)` — modals, popovers
  - `shadow-lg`: `0 12px 24px rgba(0,0,0,0.08), 0 4px 8px rgba(0,0,0,0.04)` — sheets, drawers
- **No gray borders on white.** Cards on white backgrounds use `shadow-sm` for separation, not borders. Borders are reserved for interactive elements (inputs, buttons) and dividers within cards.
- **Accent tint backgrounds** use the `-50` shade. Never apply full-saturation accent color as a background in light mode.

---

## 6. Buttons

### Button Hierarchy

| Variant | Surface | Text | Border | Use |
|---|---|---|---|---|
| **Primary** | Section accent (`-500`) | White | None | One per screen. The main action. "Place Order," "Add to Cart," "Confirm." |
| **Secondary** | `neutral-100` | `neutral-800` | `neutral-200` | Supporting actions. "Save Draft," "Add Note," "Filter." |
| **Tertiary** | Transparent | Section accent (`-600`) | None | Inline actions. "View All," "Edit," "Remove." |
| **Destructive** | `error` | White | None | Irreversible actions. "Cancel Order," "Delete." Always requires confirmation. |
| **Ghost** | Transparent | `neutral-600` | None | Navigation actions, less important options. "Skip," "Maybe Later." |

### Button Sizes

| Size | Height | Horizontal Padding | Font | Corner Radius | Use |
|---|---|---|---|---|---|
| XL | 56pt | 24pt | `label-lg` (15pt Medium) | 14pt | Primary CTA at bottom of checkout, onboarding. Full-width. |
| LG | 48pt | 20pt | `label-lg` (15pt Medium) | 12pt | Standard primary action. |
| MD | 40pt | 16pt | `label-md` (13pt Medium) | 10pt | Secondary actions, toolbar buttons. |
| SM | 32pt | 12pt | `label-sm` (11pt Medium) | 8pt | Compact actions in cards, table rows. |

### Button States

| State | Treatment |
|---|---|
| Default | As defined above. |
| Pressed | Opacity 0.7, scale 0.97. Transition: 80ms ease-out. Spring back: 200ms spring(0.5, 0.8). |
| Disabled | Opacity 0.4. No interaction. No cursor change. |
| Loading | Label replaced with a 16pt spinner (matching text color). Button width does not change. |
| Hover (iPad/Mac) | Surface lightens 5%. Subtle 100ms transition. |

### Button Rules

- **One primary button per screen.** If there are two equal actions, both are secondary.
- **Full-width buttons** are XL size, pinned to the bottom safe area with a 16pt margin and a subtle top-edge blur (glass material) so content scrolls beneath.
- **Icon + label buttons:** Icon leads on LTR, trails on RTL. 8pt gap. Icon size matches font x-height.
- **Icon-only buttons:** Minimum 44pt touch target. Always have an accessibility label. Use MD size (40pt visible, 44pt touch).
- **Loading buttons** are disabled. They cannot be tapped again. The spinner replaces the label — never shows both.
- **Destructive buttons** never appear as the first/top option. They require a confirmation sheet or are placed in a secondary position.

---

## 7. Cards

### Card Variants

**Product Card (Grid)**
- 2-column grid layout
- Image: aspect ratio 1:1, fills card width, 10pt top corner radius
- Content below image: 12pt padding
- Product name: `title-md`, 2-line max, truncate
- Supplier name: `body-sm`, `neutral-500`, 1-line truncate
- Price: `mono-lg`, bold, aligned bottom-left
- Unit: `body-sm`, `neutral-500`, inline after price (e.g., "/ kg")
- Add button: 32pt circular, accent fill, "+" icon, bottom-right of card
- Card: `shadow-sm` (light), `neutral-100` surface (dark), 12pt radius

**Product Card (List)**
- Horizontal layout, 80pt height
- Thumbnail: 64×64pt, 8pt radius, left-aligned
- Content: name (`title-md`), supplier (`body-sm`), price (`mono-md`)
- Quantity stepper: right-aligned, 32pt height
- Divider: 1px `neutral-150`, inset 16pt from left (below thumbnail)

**Order Card**
- Full-width, 16pt padding
- Header row: order number (`mono-md`), date (`body-sm`), status badge (right)
- Supplier row: supplier name (`title-sm`), logo (24pt circle)
- Items preview: "3 items" (`body-sm`) or first 2 item names truncated
- Total: `mono-lg`, bold, bottom-right
- Chevron: right edge, vertically centered, `neutral-400`
- Corner radius: 14pt. Shadow: `shadow-sm`.

**Supplier Card**
- Image banner: 3:1 aspect ratio, 12pt top radius
- Verified badge: gold checkmark overlapping banner bottom-right
- Name: `title-lg`
- Category tags: horizontal scroll, `label-sm` badges
- Rating: star icon + numeric (`body-sm`)
- Delivery info: truck icon + "Next day delivery" (`body-sm`)
- Min order: `body-sm`, `neutral-500`

**Summary Card (Dashboard)**
- Compact, no image
- Metric value: `display-md`, accent color
- Metric label: `body-sm`, `neutral-500`
- Trend arrow: up/down icon, `success`/`error` color
- Background: subtle accent `-50` tint
- Corner radius: 12pt

### Card Rules

- **Cards never nest.** A card inside a card is a list inside a card.
- **Corner radius:** 12pt standard, 14pt for large/prominent cards, 8pt for compact/inline cards.
- **Card press state:** Scale 0.98, `shadow-sm` → `shadow-md` on press start, spring back on release. 200ms spring animation.
- **Card swipe actions:** Right-to-left swipe reveals action buttons (reorder, delete). Maximum 2 actions. 64pt action button width. LTR swipe direction flips in RTL mode.

---

## 8. Inputs

### Text Input

- **Height:** 48pt (standard), 40pt (compact)
- **Corner radius:** 10pt
- **Background:** `neutral-100` (light), `neutral-100` (dark)
- **Border:** 1px `neutral-200` (idle), 2px section accent (focused), 2px `error` (error)
- **Padding:** 16pt horizontal, centered vertical
- **Font:** `body-lg` (17pt Regular)
- **Placeholder:** `neutral-400`
- **Label:** `label-md`, `neutral-600`, positioned 8pt above input
- **Helper text:** `body-sm`, `neutral-500`, 4pt below input
- **Error text:** `body-sm`, `error`, 4pt below input, replaces helper text
- **Clear button:** 20pt "x" circle, appears when field has content, right-aligned inside field

### Search Input

- **Height:** 44pt
- **Corner radius:** 22pt (fully rounded)
- **Background:** `neutral-100`
- **Border:** none (idle), 2px section accent (focused)
- **Icon:** magnifying glass, `neutral-400`, 16pt, 12pt left padding
- **Padding:** 40pt left (after icon), 16pt right
- **Placeholder:** "Search products, suppliers..." in `neutral-400`
- **Behavior:** Sticky to top of scroll view. Collapses into navigation bar on scroll down. Expands with spring animation on scroll up or tap.

### Quantity Stepper

- **Layout:** Horizontal, 3 segments — minus button, value, plus button
- **Height:** 36pt (standard), 28pt (compact in cart)
- **Width:** 112pt (standard), 96pt (compact)
- **Corner radius:** 10pt outer container
- **Buttons:** 36×36pt touch target, `neutral-200` background, `-`/`+` in `neutral-700`
- **Value:** center segment, `mono-md`, `neutral-900`
- **Dividers:** 1px `neutral-150` between segments
- **Long-press:** Holding +/- accelerates incrementing (1→2→5→10 per tick)
- **Haptic:** Light impact on each increment

### Dropdown / Picker

- **Trigger:** Same dimensions as text input. Chevron-down icon right-aligned.
- **Menu:** Appears as a sheet (iPhone) or popover (iPad). Never an inline dropdown that pushes content.
- **Options:** 48pt row height, `body-lg` text, checkmark on selected option.
- **Search:** If >10 options, include search field at top of sheet.

### Toggle

- **Size:** 51×31pt (Apple standard)
- **On color:** Section accent
- **Off color:** `neutral-200` (light), `neutral-300` (dark)
- **Animation:** 200ms spring

### Input Rules

- **All inputs have a visible label.** Placeholder text is not a label. The label persists above the input when focused and filled.
- **Error states** show immediately on field blur, not on form submit. The error message is specific: "Trade license number must be 6 digits," not "Invalid input."
- **Autofill:** Support iOS autofill for phone, email, address. Pre-populate from device where possible.
- **RTL inputs:** Text direction follows content language, not app language. An English product name in an Arabic-layout form remains LTR within the field.

---

## 9. Navigation

### Tab Bar (Bottom Navigation)

- **Height:** 49pt + safe area
- **Background:** Glass material (see Materials section). Ultra-thin material with section-tinted subtle gradient.
- **Items:** 5 tabs maximum
  - Home (house icon)
  - Categories (grid icon)
  - Orders (document icon)
  - Cart (bag icon, with badge count)
  - Profile (person icon)
- **Active state:** Section accent color, filled icon variant
- **Inactive state:** `neutral-400`, outline icon variant
- **Label:** `label-sm` (11pt), 2pt below icon
- **Badge (cart count):** 18pt red circle, white text, top-right of icon, max "99+"
- **Animation:** Active icon scales 1.0→1.1→1.0 with spring on selection. Icon morphs from outline to filled (300ms).

### Navigation Bar (Top)

- **Height:** 44pt (standard), 96pt (large title)
- **Background:** Transparent → glass material on scroll (crossfade at 20pt scroll offset)
- **Large title:** `display-md` (22pt Semibold), left-aligned, collapses on scroll
- **Inline title:** `title-md` (17pt Semibold), centered, appears as large title collapses
- **Back button:** Chevron-left + previous screen title (truncated), section accent color
- **Right actions:** Maximum 2 icon buttons, 44pt touch targets

### Section Switcher

- **Position:** Top of home screen, below navigation bar
- **Style:** Horizontal pill selector, 3 segments
- **Height:** 36pt
- **Corner radius:** 18pt (fully rounded)
- **Background:** `neutral-100`
- **Active segment:** Filled with section accent, white label, `shadow-sm`
- **Inactive segments:** Transparent, `neutral-600` label
- **Animation:** Active indicator slides between segments with spring animation (250ms, bounce 0.3). Section accent color cross-fades simultaneously.
- **Labels:** "Restaurant" / "Imports" / "Market"

### Sheet / Modal

- **Presentation:** iOS default sheet with detents (medium = 50%, large = 92%)
- **Corner radius:** 14pt top corners
- **Drag indicator:** 36×5pt, `neutral-300`, centered, 8pt from top
- **Background:** `neutral-0` (light), `neutral-50` (dark)
- **Dismiss:** Drag down past threshold, or tap outside (medium detent), or explicit close button

### Navigation Rules

- **Tab bar is always visible** except during checkout flow, onboarding, and full-screen media.
- **Depth limit:** Maximum 4 levels deep from any tab. If deeper is needed, rethink the information architecture.
- **Sheet vs. push:** Use sheets for self-contained actions (filters, add to cart, quick edit). Use push navigation for browsing deeper into content (product → supplier → reviews).
- **RTL navigation:** Back button chevron flips to right. Swipe-to-go-back gesture direction flips. Push transitions reverse.

---

## 10. Charts

### Chart Types

**Bar Chart (Horizontal)**
- Use for: comparing quantities across categories (top products, supplier ranking)
- Bars: 24pt height, 8pt gap, section accent fill, 6pt corner radius on trailing end
- Labels: `body-sm` left-aligned, values `mono-sm` right-aligned
- Grid: horizontal dotted lines at 25/50/75/100%, `neutral-200`

**Bar Chart (Vertical)**
- Use for: time series with discrete periods (daily orders, weekly GMV)
- Bars: flexible width (fill available / count), 8pt gap, 6pt top corner radius
- X-axis labels: `label-sm`, `neutral-500`, center-aligned below bars
- Y-axis labels: `mono-sm`, `neutral-500`, right-aligned to left of chart

**Line Chart**
- Use for: continuous trends (revenue over time, order frequency)
- Line: 2pt stroke, section accent, rounded line joins
- Area fill: section accent at 10% opacity, gradient to transparent at bottom
- Data points: 6pt circles on hover/tap, accent fill, white 2pt stroke
- Tooltip: appears above tapped point, shows value + date, `shadow-md`, 8pt radius

**Donut Chart**
- Use for: composition (category breakdown, supplier share)
- Outer radius: 80pt, inner radius: 52pt (65% ratio)
- Segment gap: 2pt
- Center label: primary metric value (`display-md`), metric name below (`body-sm`)
- Legend: below chart, horizontal wrap, colored dot (8pt) + label (`body-sm`) + value (`mono-sm`)

**Sparkline**
- Use for: inline trend in summary cards and table cells
- Height: 24pt, width: 64pt
- Line: 1.5pt stroke, section accent
- No axes, no labels, no grid
- End dot: 4pt circle, accent fill

### Chart Rules

- **Color:** Primary metric uses section accent. Secondary series use accent at 50% and 25% opacity. Maximum 4 series per chart. More than 4? Rethink the visualization.
- **Animation:** Charts animate in on appear. Bars grow from zero (300ms, ease-out). Lines draw left-to-right (400ms). Donuts rotate clockwise from 12 o'clock (500ms, spring).
- **Empty state:** If no data, show the chart frame with a centered message: "No data yet" + relevant illustration.
- **Interaction:** Tap-and-hold on any data point shows a tooltip. Drag across a line chart scrubs through time. Haptic tick on each data point crossing.
- **Dark mode:** Chart backgrounds are transparent (inherit card surface). Grid lines use `neutral-200`. Accent colors use dark-mode palette.
- **Accessibility:** Every chart has a text summary accessible via VoiceOver. "Bar chart showing top 5 products. Chicken breast leads with 340 orders."

---

## 11. Tables

### Table Structure

- **Header row:** 40pt height, `label-md`, `neutral-500`, uppercase, background `neutral-50` (light) / `neutral-100` (dark)
- **Data row:** 52pt height (standard), 44pt (compact)
- **Row padding:** 16pt horizontal
- **Dividers:** 1px `neutral-150`, full-width
- **Alternating rows:** None. Use dividers for separation. Alternating fills create visual noise.
- **Selected row:** Background `accent-50`. Left edge 3pt accent bar.
- **Font:** `body-md` for text cells, `mono-md` for numeric cells

### Column Types

| Type | Alignment | Font |
|---|---|---|
| Text | Leading | `body-md` |
| Numeric | Trailing | `mono-md` |
| Currency | Trailing | `mono-md`, bold for totals |
| Status | Leading | Badge component (see Badges) |
| Date | Leading | `body-sm`, `neutral-500` |
| Action | Trailing | Icon button or text link |
| Thumbnail | Leading | 32×32pt image, 6pt radius |

### Table Behavior

- **Sorting:** Tap header to sort. Arrow icon indicates direction. Active sort header uses `neutral-800` (not `neutral-500`).
- **Horizontal scroll:** If table exceeds screen width, first column pins and remaining columns scroll horizontally. Subtle shadow on pinned column edge.
- **Pull-to-refresh:** Standard iOS pull-to-refresh with section-accent spinner.
- **Infinite scroll:** Load 20 rows at a time. Skeleton rows (see Loading States) appear at bottom while loading.
- **Swipe actions:** Same as card swipe actions. Right-to-left reveals row actions.

### Table Rules

- **Tables are for data, not for layout.** If the "table" has only 2-3 rows, use a list or card instead.
- **Maximum 6 visible columns** on iPhone. More columns require horizontal scroll with pinned first column.
- **Touch targets:** Any tappable cell element must be 44pt minimum height (the standard 52pt row achieves this).
- **Empty table:** Show table header + empty state message in body area. Never show an empty frame.

---

## 12. Badges

### Badge Variants

**Status Badge**
- Height: 24pt
- Padding: 8pt horizontal
- Corner radius: 6pt
- Font: `label-md` (13pt Medium)
- Background: semantic subtle color (`success-subtle`, `warning-subtle`, `error-subtle`, `info-subtle`)
- Text: semantic color (`success`, `warning`, `error`, `info`)
- No border

| Label | Color | Use |
|---|---|---|
| Delivered | `success` | Order delivered |
| In Transit | `info` | Order in transit |
| Pending | `warning` | Awaiting confirmation |
| Cancelled | `error` | Order cancelled |
| Preparing | `info` | Supplier preparing order |
| Verified | `verified-gold` | Supplier verified |
| New | Section accent | New product/supplier |
| Fresh | `fresh-green` | Fresh produce indicator |
| Frozen | `frozen-cyan` | Frozen/cold-chain indicator |

**Count Badge**
- Size: 18pt diameter (1 digit), 24pt wide (2 digits), 30pt wide (3+ digits)
- Corner radius: fully rounded
- Background: `error` (for cart, notifications), section accent (for counts)
- Text: white, `label-sm` (11pt Medium)
- Position: top-right of parent element, offset -4pt x, -4pt y
- Max display: "99+"

**Tag Badge**
- Height: 28pt
- Padding: 10pt horizontal
- Corner radius: 14pt (fully rounded)
- Font: `label-md`
- Background: `neutral-100`
- Text: `neutral-700`
- Optional: leading icon (14pt), dismiss "x" button (trailing, 16pt)
- Use: category filters, search tags, product attributes

**Tier Badge**
- Height: 28pt
- Padding: 10pt horizontal, with leading icon
- Corner radius: 8pt
- Variants:
  - Bronze: `#CD7F32` text on `#FDF4E7` background
  - Silver: `#71717A` text on `#F4F4F5` background
  - Gold: `#92711F` text on `#FEF9E7` background
  - Platinum: `#334155` text on `#F1F5F9` background with subtle gradient border

---

## 13. Empty States

### Structure

Every empty state has exactly 3 elements, vertically centered:

1. **Illustration:** 120×120pt, line art style, section-accent tinted. Minimal, elegant — not cartoon. Think Apple's system empty states, not Dribbble illustrations.
2. **Title:** `display-lg` (28pt Bold), `neutral-800`. States the situation. "No orders yet."
3. **Subtitle + CTA:** `body-lg` (17pt Regular), `neutral-500`. Explains what to do. Below it, a primary button if there's an actionable next step.

### Empty State Inventory

| Screen | Illustration Concept | Title | Subtitle | CTA |
|---|---|---|---|---|
| Order history | Elegant receipt with dotted outline | No orders yet | Place your first order and it will appear here | Browse products |
| Cart | Minimalist shopping bag, open | Your cart is empty | Find products from verified suppliers | Start shopping |
| Search results | Magnifying glass over empty space | No results found | Try a different search term or browse categories | Browse categories |
| Favorites | Heart outline with subtle pulse | No favorites yet | Tap the heart icon on products you order often | (none) |
| Messages | Chat bubble, empty | No messages | Start a conversation with any supplier | (none) |
| Supplier orders | Clipboard with blank checklist | No incoming orders | New orders from restaurants will appear here | (none) |
| Analytics | Chart frame with flat line | Not enough data | Analytics will populate after your first 10 orders | (none) |

### Empty State Rules

- **Never show a raw empty list.** Every list, grid, and table has a designed empty state.
- **Illustrations are monochrome** + section accent. Two colors maximum. No full-color illustrations.
- **Animations:** Illustration has a subtle looping animation — a gentle floating motion (2s cycle, 4pt vertical range) or a slow pulse (opacity 0.8→1.0, 3s cycle). Never static.
- **The CTA is optional.** If there's nothing the user can do (e.g., "No incoming orders" for a new supplier), omit the button. Don't add buttons that go nowhere.

---

## 14. Loading States

### Loading Hierarchy

| Priority | Technique | Duration | Use |
|---|---|---|---|
| 1 | **Optimistic UI** | 0ms | Actions that usually succeed (add to cart, toggle favorite). Show the result immediately, revert on failure. |
| 2 | **Skeleton screens** | 0-300ms | Content loading. Show layout shape immediately, fill with data when ready. |
| 3 | **Inline spinner** | 300ms+ | When skeleton doesn't fit (button loading, pull-to-refresh). Section-accent color. |
| 4 | **Full-screen loader** | Never | Never block the entire screen. Find a way to show partial content. |

### Loading Rules

- **300ms rule:** If content loads in under 300ms, no loading indicator at all. The skeleton appears only if the load takes longer.
- **Stagger reveal:** When multiple items load (e.g., a product grid), items appear with a 50ms stagger (not all at once). Top-left to bottom-right reading order.
- **Pull-to-refresh:** Section-accent spinner, 24pt, centered above content. Content pushes down to make room. Spring back on release.
- **Pagination:** When loading more items at bottom, show 3 skeleton rows. No "Load more" button — infinite scroll only.
- **Retry:** If load fails, show inline error with "Retry" button. Never auto-retry more than once.

---

## 15. Skeletons

### Skeleton Construction

Skeletons mirror the exact layout of the content they replace. Every skeleton is built from two primitives:

**Skeleton Block**
- Corner radius: matches the element it replaces (text = 4pt, image = element radius, icon = circular)
- Color: `neutral-150` (light), `neutral-200` (dark)
- Animation: shimmer — a 45-degree linear gradient highlight sweeps left-to-right (RTL: right-to-left) over 1.5s, infinite loop. The highlight is `neutral-100` (light) / `neutral-150` (dark), 40% width of the block.

**Skeleton Circle**
- For avatars, icons, and circular thumbnails
- Same color and animation as blocks

### Skeleton Templates

**Product Card Skeleton**
- Image area: full-width block, 1:1 aspect ratio, 10pt top radius
- Title: 80% width block, 14pt height, 8pt below image
- Subtitle: 50% width block, 10pt height, 4pt below title
- Price: 30% width block, 14pt height, 8pt below subtitle

**Order Card Skeleton**
- Header: 40% width block (order number) + 60pt block right-aligned (status badge)
- Supplier: 24pt circle + 50% width block
- Items: 70% width block
- Total: 25% width block, right-aligned

**List Item Skeleton**
- Thumbnail: 64×64pt block, 8pt radius
- Title: 70% width block, 14pt height
- Subtitle: 45% width block, 10pt height
- Right element: 20% width block

### Skeleton Rules

- **Match the real layout exactly.** Skeleton width should approximate the average content width. Title skeletons are 70-80% width because most titles are that long.
- **Shimmer direction follows reading direction.** LTR in English, RTL in Arabic. This is a subtle detail that makes skeletons feel intentional.
- **3-skeleton limit for lists.** Show at most 3 skeleton list items. More than 3 looks like fake content and triggers uncanny valley.
- **Skeleton → content transition:** Content fades in (opacity 0→1, 200ms) as the skeleton fades out. No jarring pop-in.

---

## 16. Haptics

### Haptic Vocabulary

| Haptic | UIKit Generator | Use |
|---|---|---|
| **Tap** | `UIImpactFeedbackGenerator(.light)` | Button press, toggle, stepper increment, tab switch |
| **Select** | `UISelectionFeedbackGenerator` | Scrolling through picker values, crossing a chart data point, segment control switch |
| **Confirm** | `UINotificationFeedbackGenerator(.success)` | Order placed, item added to cart, payment confirmed |
| **Warn** | `UINotificationFeedbackGenerator(.warning)` | Approaching credit limit, low stock warning, form error |
| **Error** | `UINotificationFeedbackGenerator(.error)` | Order failed, payment declined, validation error |
| **Heavy** | `UIImpactFeedbackGenerator(.heavy)` | Long-press context menu open, swipe action threshold crossed |
| **Rigid** | `UIImpactFeedbackGenerator(.rigid)` | Drag-and-drop snap to position, sheet detent snap |

### Haptic Rules

- **Every state change has a haptic.** If the UI changes state (selected → deselected, added → removed), the user feels it.
- **Haptics match the action weight.** A cart addition is `.light`. An order placement is `.success`. A deletion is `.heavy`.
- **No haptic spam.** Scrolling through a long list does not generate haptics. Only meaningful interaction points.
- **Respect system settings.** If the user has disabled haptics in iOS Settings, respect that. Check `CHHapticEngine.capabilitiesForHardware()`.
- **Pair haptics with animation.** A haptic without visual feedback (or vice versa) feels broken. They fire simultaneously.

---

## 17. Icons

### Icon System

- **Source:** SF Symbols (Apple's system icon set). 5,000+ symbols, variable weight/size, and RTL-aware.
- **Why:** Zero asset management. Automatic Dynamic Type scaling. Native RTL mirroring. Accessibility labels built in.

### Icon Sizing

| Context | Size | SF Symbol Config |
|---|---|---|
| Tab bar | 24pt | `.font(.system(size: 24))`, weight: `.medium` |
| Navigation bar action | 20pt | `.font(.system(size: 20))`, weight: `.medium` |
| List item leading | 22pt | `.font(.system(size: 22))`, weight: `.regular` |
| Inline with text | Matches text x-height | `.imageScale(.medium)` |
| Category tile | 28pt | `.font(.system(size: 28))`, weight: `.medium` |
| Empty state | 48pt | `.font(.system(size: 48))`, weight: `.thin` |
| Button leading icon | Matches label x-height | `.imageScale(.small)` |

### Icon Color

| Context | Color |
|---|---|
| Active tab | Section accent |
| Inactive tab | `neutral-400` |
| List item | `neutral-500` |
| Action button | Section accent or `neutral-700` |
| Status | Matches semantic color |
| Destructive | `error` |

### Custom Icons

For product category tiles where SF Symbols lacks appropriate food/supply imagery, create custom symbols following Apple's Custom Symbols guidelines:

- Design on the SF Symbols grid (maintain cap height, baseline, margins)
- Export as SVG symbol with 3 weight variants (Regular, Medium, Bold)
- Include Ultralight and Black if used at display sizes
- Categories needing custom symbols: Fresh Produce, Meat & Poultry, Seafood, Dairy, Frozen, Bakery, Beverages, Spices, Cleaning Supplies

### Icon Rules

- **SF Symbols first.** Only create custom symbols when SF Symbols has no reasonable match.
- **RTL mirroring:** Enable automatic mirroring for directional icons (arrows, chevrons, share). Disable for non-directional icons (clock, heart, star).
- **Filled vs. outline:** Outline for inactive/unselected states. Filled for active/selected states. The morphing animation between outline → filled (300ms) reinforces the state change.

---

## 18. Accessibility

### WCAG 2.1 AA Compliance (Minimum)

| Criterion | Target | Implementation |
|---|---|---|
| Color contrast (text) | 4.5:1 minimum | All text/background combinations pre-validated. See Color System. |
| Color contrast (UI) | 3:1 minimum | All interactive element borders/fills meet 3:1 against adjacent colors. |
| Touch targets | 44×44pt minimum | All interactive elements, including icon buttons, meet this. Extend tap area with `contentShape` if visual size is smaller. |
| Text scaling | Up to 300% | Support all Dynamic Type sizes. Test at accessibility XXL. Layout reflows — never clips or overlaps. |
| Motion | Reducible | Respect `UIAccessibility.isReduceMotionEnabled`. Replace animations with cross-fades. Disable parallax, spring bounces, and shimmer. |
| Screen reader | Full VoiceOver support | Every element has a label, value, and trait. Custom components implement `UIAccessibility` protocol. |

### VoiceOver Design

- **Reading order:** Logical, top-to-bottom, leading-to-trailing. Not visual order. Test with eyes closed.
- **Product card announcement:** "Chicken breast, 45 dirhams per kilogram, from Al Madina Foods, 4.8 stars, add to cart button."
- **Order status:** "Order 4521, placed June 15, status: in transit, total 1,240 dirhams."
- **Quantity stepper:** "Quantity: 5. Adjustable. Swipe up to increase, swipe down to decrease."
- **Charts:** Provide text summary. "Bar chart: top 5 products this month. Chicken breast, 340 orders. Tomatoes, 280 orders." Etc.
- **Custom actions:** Use `accessibilityCustomAction` for swipe-to-reorder and other gesture-based actions.

### Accessibility Rules

- **Never use color alone** to convey information. Status badges include text labels and icons, not just color.
- **Focus management:** When a modal opens, focus moves to it. When it closes, focus returns to the trigger. Custom screens manage focus deliberately.
- **Error announcements:** When a form error appears, announce it via `UIAccessibility.post(notification: .announcement)`.
- **Reduce Transparency:** When `UIAccessibility.isReduceTransparencyEnabled` is true, replace glass materials with solid surfaces.

---

## 19. Animation Guidelines

### Timing

| Category | Duration | Curve | Use |
|---|---|---|---|
| Micro | 80-120ms | `easeOut` | Button press, toggle, opacity change |
| Standard | 200-250ms | `spring(response: 0.35, dampingFraction: 0.85)` | Screen transitions, card press, element appearance |
| Emphasis | 300-400ms | `spring(response: 0.5, dampingFraction: 0.7)` | Section switcher slide, drawer open, significant state change |
| Dramatic | 500-800ms | `spring(response: 0.6, dampingFraction: 0.75)` | Onboarding transitions, celebration moments (order placed), chart draw-in |

### Spring Parameters

Default spring: `response: 0.35, dampingFraction: 0.85`

This produces movement that feels quick and decisive with minimal overshoot — the Linear/Stripe feel. Bouncy springs (dampingFraction < 0.7) are reserved for celebration moments only.

| Feel | Response | Damping | Use |
|---|---|---|---|
| Snappy | 0.25 | 0.9 | Button press, toggle |
| Default | 0.35 | 0.85 | Most UI transitions |
| Smooth | 0.5 | 0.8 | Sheet presentation, section switch |
| Bouncy | 0.5 | 0.65 | Order confirmation, first-time celebrations |

### Animation Rules

- **Interruption:** Every animation is interruptible. If the user taps mid-animation, the current animation seamlessly transitions to the new target. No queuing.
- **Reduce Motion:** Replace all spring/slide animations with 150ms cross-fades. Remove parallax, shimmer, and floating animations entirely.
- **No animation for animation's sake.** Every animation must communicate: state change, spatial relationship, or hierarchy. If removing the animation loses no information, remove it.
- **Stagger formula:** When multiple elements animate in, each subsequent element delays by `50ms × index`. Maximum stagger: 200ms (4 items). After that, remaining items appear together.
- **Exit animations** are faster than enter animations. Enter: 250ms. Exit: 150ms. Things leave quickly to get out of the way.

---

## 20. Motion Principles

### Spatial Model

The Sofrino interface has an implied z-axis depth:

```
Z-depth (conceptual, not pixel values):

  [Toast notifications]      z: 4 — float above everything
  [Sheets / Modals]          z: 3 — overlay the content
  [Popovers / Menus]         z: 2 — contextual overlays
  [Navigation bar / Tab bar] z: 1 — chrome layer
  [Content]                  z: 0 — the ground plane
  [Backgrounds]              z: -1 — behind content
```

### Directional Semantics

- **Forward navigation** (deeper into content): New screen slides in from trailing edge (right in LTR, left in RTL). Previous screen slides out to leading edge at 30% speed (parallax).
- **Backward navigation:** Reverse of forward. Swipe-from-edge gesture drives the transition interactively.
- **Upward** (sheets, modals): Slides up from bottom. Communicates "temporary layer."
- **Downward** (dismiss): Slides or flings down. Gravity-consistent.
- **Scale up** (selection, zoom): Selected element scales from its position. Communicates "this is now the focus."
- **Scale down** (deselection, background): Element shrinks slightly and dims. Communicates "this is now secondary."

### Transition Types

**Hero transition (shared element)**
- Use for: Product card → product detail, supplier card → supplier profile
- The tapped element (image, title) morphs position and size to its location on the destination screen
- Duration: 350ms spring
- Background: previous screen scales to 0.92 and dims to 80% brightness

**Slide transition (push)**
- Use for: standard navigation stack pushes
- Duration: 300ms spring
- New screen slides in from 100% trailing offset
- Previous screen slides to -30% leading offset (parallax ratio)

**Sheet transition**
- Use for: modals, filters, detail panels
- Duration: 350ms spring(0.5, 0.8)
- Sheet slides up from below screen. Background dims to 60% brightness and scales to 0.95.
- Interactive dismissal via drag (velocity-sensitive fling detection)

**Cross-fade transition**
- Use for: tab switches, section switcher, content updates within the same container
- Duration: 200ms ease-in-out
- Old content fades to 0 while new content fades from 0 simultaneously

---

## 21. 3D Depth

### Depth Cues

Sofrino uses subtle 3D depth to create a spatial, premium feel — never for novelty.

**Shadow System (Light Mode)**

| Token | X | Y | Blur | Spread | Color | Use |
|---|---|---|---|---|---|---|
| `depth-subtle` | 0 | 1pt | 2pt | 0 | `rgba(0,0,0,0.04)` | Resting cards, list items |
| `depth-raised` | 0 | 4pt | 12pt | -2pt | `rgba(0,0,0,0.08)` | Pressed cards, active elements |
| `depth-floating` | 0 | 8pt | 24pt | -4pt | `rgba(0,0,0,0.12)` | Popovers, dropdowns |
| `depth-overlay` | 0 | 16pt | 48pt | -8pt | `rgba(0,0,0,0.16)` | Modals, sheets |

**Dark Mode:** Shadows are invisible. Depth is conveyed through surface brightness (elevated = lighter surface color). See Dark Mode section.

### Perspective Effects

**Card tilt on press**
- When a card is long-pressed, apply a subtle 3D rotation toward the press point
- Rotation: maximum 3 degrees on each axis
- Combined with scale 0.97 and `depth-raised` shadow
- Implementation: `rotation3DEffect` with `perspective: 0.5`
- Duration: 200ms spring. Returns to flat on release.

**Parallax scroll**
- Header images in supplier profiles and product detail scroll at 60% of content scroll speed
- Creates depth illusion: image feels "behind" the content
- Maximum parallax offset: 40pt
- Disabled when Reduce Motion is enabled

---

## 22. Glass Materials

### Material Definitions

Glass (frosted/translucent) materials are used for persistent chrome layers that content scrolls beneath.

**Ultra Thin Material**
- Use for: Tab bar, sticky search header
- Background: system ultra-thin material (`.ultraThinMaterial` in SwiftUI)
- Light mode: white at 50% opacity + 20pt Gaussian blur
- Dark mode: black at 70% opacity + 20pt Gaussian blur
- Border: 0.5pt `neutral-200` at 30% opacity on top edge

**Thin Material**
- Use for: Navigation bar on scroll, floating action buttons
- Background: `.thinMaterial` in SwiftUI
- Light mode: white at 60% opacity + 16pt Gaussian blur
- Dark mode: black at 75% opacity + 16pt Gaussian blur

**Regular Material**
- Use for: Sheet backgrounds when content should bleed through
- Background: `.regularMaterial` in SwiftUI
- Light mode: white at 75% opacity + 12pt Gaussian blur
- Dark mode: black at 80% opacity + 12pt Gaussian blur

### Section-Tinted Glass

The tab bar and navigation bar have a subtle section-tint gradient layered over the glass material:

- Restaurant section: `emerald-500` at 5% opacity
- Global Imports: `blue-500` at 5% opacity
- Supermarket: `amber-500` at 5% opacity

This tint is barely perceptible but subconsciously reinforces which section the user is in. It cross-fades (300ms) when switching sections.

### Glass Rules

- **Never use glass on top of glass.** If a popover appears over a glass navigation bar, the popover uses a solid surface, not additional blur.
- **Reduce Transparency:** When system setting is enabled, replace all glass materials with solid `neutral-0` (light) or `neutral-50` (dark) surfaces. No blur.
- **Performance:** Use SwiftUI's native `.material` modifiers. They leverage Metal and are GPU-accelerated. Do not implement custom blur — it will jank.
- **Content legibility:** Any text or icon over glass must meet contrast requirements against the *worst-case* content that could scroll beneath. Test with both light and dark content underneath.

---

## 23. Parallax

### Parallax Applications

**Screen header image**
- Context: Supplier profile, product detail (when product has a hero image)
- Behavior: Image scrolls at 60% of content scroll rate
- Image extends 40pt above its container to accommodate the parallax range
- On overscroll (pull down): image scales up proportionally (rubber-band), maxing at 1.15x

**Category tile hover (iPad/Mac Catalyst)**
- Context: Home screen category grid
- Behavior: Tile image subtly shifts based on pointer position within the tile
- Maximum shift: 4pt in any direction
- Response: 100ms ease-out
- Not applicable on iPhone (no pointer)

**Onboarding cards**
- Context: Onboarding flow carousel
- Behavior: Background illustration layers move at different rates as user swipes between cards
  - Background layer: 40% of swipe distance
  - Midground layer: 70% of swipe distance
  - Foreground layer: 100% (moves with content)
- Creates a theatrical depth effect for first impression

### Parallax Rules

- **Disabled when Reduce Motion is on.** Parallax elements become static (no movement). Images stay pinned, no rubber-band zoom.
- **Maximum parallax offset:** 40pt in any direction. More than this feels nauseating.
- **Frame rate:** Parallax must run at display refresh rate (120fps on ProMotion devices). If it drops below 60fps, simplify or remove.
- **No parallax on scrollable lists.** Parallax on list items during fast scrolling causes motion sickness. Reserve for header images and static decorative layers only.

---

## 24. Microinteractions

### Cart Interactions

**Add to cart**
- Trigger: Tap "+" button on product card
- Animation: Product image shrinks to 20pt thumbnail, arcs toward cart tab icon (250ms spring, dampingFraction 0.75)
- Cart icon: scales 1.0→1.2→1.0 (150ms spring)
- Cart badge: count increments with a vertical slide transition (old number slides up, new slides in from below)
- Haptic: `.light` impact
- Optimistic: Cart count updates immediately. No spinner.

**Remove from cart**
- Trigger: Tap "-" when quantity = 1, or swipe-to-delete
- Animation: Item collapses height to 0 (200ms ease-out), remaining items slide up to fill gap
- Haptic: `.light` impact
- Undo: Toast appears at bottom: "Item removed" + "Undo" button (5s timeout)

**Quantity change**
- Trigger: Tap +/- on stepper
- Animation: Number cross-fades with vertical direction (+ = new number slides in from below, - = from above)
- Price updates: inline animation, old price slides out, new price slides in (150ms)
- Haptic: `.light` impact per increment

### Favorite / Bookmark

- Trigger: Tap heart icon
- Animation (add): Heart icon morphs outline → filled, scales 1.0→1.3→1.0, color transitions to `error` red (250ms spring)
- Animation (remove): Heart morphs filled → outline, no scale, color transitions to `neutral-400` (150ms)
- Haptic: `.light` impact

### Pull to Refresh

- Trigger: Pull content down past 60pt threshold
- Phase 1 (0-60pt): Custom spinner icon rotates proportionally to pull distance
- Phase 2 (threshold crossed): Spinner animates continuously, haptic `.light`
- Phase 3 (loading): Spinner continues until data arrives
- Phase 4 (complete): Spinner scales to 0, content springs back (250ms spring)

### Order Placed Confirmation

- Trigger: Order successfully submitted
- Sequence (800ms total):
  1. Screen content fades to 70% brightness (100ms)
  2. Checkmark circle scales from 0 to 1.0 with spring bounce (300ms, damping 0.6)
  3. Checkmark draws on (stroke animation, 200ms)
  4. Confetti particles burst from checkmark center (200ms) — 12 particles, section-accent colored, gravity-affected, fade out over 500ms
  5. "Order Placed!" title fades in below (200ms)
- Haptic: `.success` notification
- Auto-dismiss to order tracking screen after 2s

### Swipe Actions

- Trigger: Swipe left on list item (right in RTL)
- Animation: Action buttons slide in from trailing edge with slight overshoot (spring, 250ms)
- Threshold: 80pt for first action, full-width for destructive action
- Full-swipe: If swiped past 70% of row width, the primary action executes automatically
- Haptic: `.rigid` impact when threshold is crossed
- Colors: Primary action uses section accent. Destructive action uses `error`.

### Section Switcher

- Trigger: Tap segment or swipe on home screen
- Animation: Active pill slides to new position (250ms spring). Accent color cross-fades (300ms). Home screen content cross-fades (200ms, 50ms delay after pill starts moving).
- Haptic: `.selection` feedback during slide
- Glass tint: Tab bar section tint cross-fades simultaneously

---

## Component Reusability Contract

Every component in this system is designed for reuse. To qualify as a Sofrino design system component, it must meet all of these criteria:

1. **Token-driven.** All colors, spacing, typography, and corner radii reference design tokens — never hardcoded values.
2. **Theme-aware.** Renders correctly in light mode, dark mode, and with increased contrast enabled.
3. **RTL-ready.** Layout mirrors correctly in Arabic. Directional icons flip. Text alignment follows content language.
4. **Accessible.** VoiceOver labels, Dynamic Type support, minimum touch targets, reduced motion fallback.
5. **State-complete.** Defines all states: default, pressed, disabled, loading, error, empty, selected.
6. **Composable.** Can be used standalone or nested in any layout container without breaking.
7. **Documentable.** Has a single source of truth in this design system — behavior, not just appearance.

---

## Token Naming Convention

All tokens follow this pattern: `{category}-{property}-{variant}-{state}`

Examples:
- `color-neutral-500` — neutral gray at 500 weight
- `color-emerald-500` — emerald accent at 500 weight
- `space-6` — 16pt spacing
- `type-body-lg` — large body text style
- `shadow-depth-raised` — raised elevation shadow
- `radius-md` — medium corner radius (10pt)
- `duration-standard` — 200-250ms animation duration
- `haptic-tap` — light impact haptic

This naming ensures tokens are searchable, scannable, and unambiguous across design files and Swift code.
