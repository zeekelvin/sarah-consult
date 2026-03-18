# Lessons Learned — SarahConsult Project

## SVG / Logo

- **Arc text clipping**: Using a 290° arc spreads text too far down the sides of the seal.
  Fix: strict 180° top-half arc `M 54,250 A 196,196 0 0,1 446,250` with font-size ≤ 12.5 and
  letter-spacing ≤ 2.5. Text occupies ~55% of arc → no clipping, no side wrap.
- **`text-anchor="middle"` + `startOffset="50%"` on textPath**: Works in Chrome when the arc
  is the correct half-circle. Does NOT work reliably with large/unusual arc paths.
- **SVG ID conflicts in HTML**: Every inline SVG on a page shares the global DOM namespace.
  Give each arc path a unique id (e.g. `nav-arc`, `ft`, `arc-top`).
- **ICC acronym**: The correct acronym is **ICC** (Integrity Compliance & Consulting), not IC.
  Monogram layout: "I" on top, horizontal divider with diamond tips, "C C" below.

## Git / Workflow

- Repo: `https://github.com/zeekelvin/sarah-consult.git` — branch `main`
- Always stage specific files; never `git add -A` (avoids committing secrets/zips/images).
- Line-ending warnings (LF → CRLF) on Windows are expected and harmless.

## Website

- Built as a single-page HTML file: `integrity-compliance-website-v2.html`
- Color palette: deep forest green `#252B1A`, sand gold `#C4A882`, warm cream `#EDE8D0`
- Typography: Cormorant Garamond (headings/logo), Jost (body/labels)
- Logo appears in 3 places: nav (80×80 viewBox), footer (100×100 viewBox), favicon (SVG)
- Favicon uses inline SVG data URI in `<link rel="icon">` tag

## PNG Exporter

- `export-logo-png.html` — standalone tool, builds SVG via JS, draws to canvas, exports PNG
- The `buildSVG()` function must mirror the standalone SVG exactly (same arc path, same fonts)
- Google Fonts `@import` inside SVG `<defs><style>` does NOT load in canvas `drawImage()`;
  fonts fall back to Georgia/sans-serif in exports — this is expected behaviour.

## Client Notes

- Client: **Sarah Powell** — Integrity Compliance & Consulting LLC, NJ DDD compliance
- Sign all comms as **Kelvin** (not Calvin)
- Available evenings after 5 pm weekdays and weekends
- Do not reference her employer or 9-5 work hours
