---
name: leezy-mapcraft
description: Prepare and validate offline GIS basemaps, automatically acquire missing base geography for requested data preparation or mapping, and create editable ArcGIS Pro overview and thematic maps.
metadata:
  author: BigWai1312
  source: https://github.com/BigWai1312/leezy-skills/tree/main/skills/leezy-mapcraft
  version: "1.2.0"
---

# LEEZY MapCraft

> LEEZY Skills | Author: [BigWai1312](https://github.com/BigWai1312) | [Canonical source](https://github.com/BigWai1312/leezy-skills/tree/main/skills/leezy-mapcraft)

The author credit identifies this skill, not the author of the user's data or maps. Keep the supplied copyright and attribution files with redistributed skill copies. Do not add a visible LEEZY watermark to user maps unless requested. If requested, use `LEEZY MapCraft | BigWai1312 | github.com/BigWai1312/leezy-skills` in a small, editable layout text element without covering map content.

For installation and invocation, see [README.md](README.md). For input templates and expected outputs, see [examples.md](examples.md). This skill provides guidance rather than a bundled ArcPy program; runtime tools and licensed GIS software must be available separately.

Use this skill for base-data checklists, offline basemap preparation, and analytically readable, editable ArcGIS Pro maps. It covers DEM, hillshade, water, roads, administrative boundaries, place names, thematic layers, and report-ready layouts.

## Working Principles

- Read the actual source data and the current project before editing. Do not reuse a map image or styling from an unrelated report as a substitute for the current data.
- Make the map express one clear spatial conclusion. A map is not complete merely because it displays numeric values.
- Preserve source data, indicator values, codes, geometry, and class fields. Put processed layers and exports in a separate output folder or GDB.
- Prefer local data and offline projects. Do not add online basemaps or web layers to a deliverable that must run on a production computer without internet.
- Produce an editable ArcGIS Pro project plus exported images when the user asks for a map. Do not insert images into a DOCX unless explicitly requested; provide Markdown links or a separate map folder first.
- For revisions, preserve the accepted composition and change only the requested properties. Back up the current outputs, update the reproducible script and affected derivatives, and refresh the APRX, exports, provenance and QA together.

## Task Scope And Missing Base Data

- Checklist or advice only: inspect relevant local sources if useful and list requirements, existing evidence, gaps, and priorities. Do not download datasets, derive layers, or start mapping in this mode; honor any request to wait for later collection.
- Base-data preparation: inventory, acquire missing required base geography, prepare offline layers, and validate them. Stop at the base-data handoff unless maps are also requested.
- Map production: reuse validated local layers first, automatically obtain missing required base layers within the authorized task, then draw the map. A request to prepare a basemap or make an overview map includes obtaining its necessary base geography, even when the user provides no data. Do not stop at a download checklist or repeatedly ask for permission already provided by the request or session.
- A request only to edit this skill, review a map, write a tutorial, or restyle an existing project does not authorize data collection.
- If the user will supply spatialized indicators, keep indicator retrieval, spatialization, land-cover analysis, and thematic recalculation outside the base-data task. Missing thematic values must not be fabricated.

Before listing, acquiring, or validating base data, read [Base Geography Preparation](references/base-geography.md). It defines the layer checklist, source selection, extent, offline handoff, and acceptance checks, including actual DEM download and fallback limits. Search the supplied local folders first; automatically fill real gaps with suitable public or already-authorized sources when acquisition is in scope. Report source-specific blockers and continue independent work; do not silently substitute unverified data.

## Data And Scale

Before symbolizing, identify the intended scale and the feature that carries the conclusion:

- Province, city, or county scale: show the complete study boundary and its surrounding terrain, major rivers, roads, and neighboring spatial relationships.
- Town or planning-zone scale: retain the town/planning-zone code, name, indicator value, class code, and geometry in the output table. Use projected polygons for thematic results.
- Village scale: use village points when the source is point data. Treat placeholder points as placeholders and keep the source identifier for later spatial linking.
- Use one suitable projected coordinate system for the main map, preferably CGCS2000 where appropriate. A national locator uses its own suitable broad-area projection. Reproject derived layers or display them with verified transformations; do not modify the original files.
- Check geometry validity, coverage, field types, null values, duplicate codes, and the relationship between the indicator field and the class field before drawing.

### Surrounding Basemap Extent

Separate acquisition coverage from the displayed view. Unless specified otherwise, prepare base geography for a square of side `1.4 * max(width, height)`, but display a new regional overview in a tighter square of side `1.2 * max(width, height)`. Center both on the study boundary's projected bounding box in a suitable metric CRS. The wider coverage is processing and layout reserve, not a requirement to show excess surroundings.

An expansion of 20% means a 1.2 factor on the longest dimension, not 20% more area or 20% padding on every side. Never treat longitude and latitude degrees as equal lengths. Explicit user extents override these defaults; retain a wider view when requested. Do not download a wider reserve merely for an existing map's local style adjustment.

Keep the exact study boundary, acquisition square, and final map-frame extent separate. Terrain, water, transport and neighboring boundaries must support the acquired surroundings, not stop at the study boundary. Acquire a small extra DEM processing margin for hillshade or reprojection. The final map frame must stay within validated coverage; extend acquisition when authorized if its aspect ratio or rotation exposes additional ground.

## Basemap Construction

Build a quiet, complete background that supports orientation without competing with the thematic result.

Recommended drawing order from background to foreground:

1. Full-frame DEM with no uncovered raster edge inside the map frame.
2. Light DEM tint and hillshade, with moderate cartographic exaggeration where useful.
3. Optional pale outside mask and a separate decorative boundary shadow above it.
4. Thematic polygons, points, or analysis result.
5. Roads, water, administrative boundaries, labels, and other reference elements with restrained symbols.

Default visual treatment:

- DEM: pale gray-green or pale green, low contrast, about 5–15% transparency after testing the exported image.
- Hillshade: neutral gray-green, usually 5–15% transparency for a clean report map. Increase darkness only when terrain is not legible at final output size.
- Regional relief: start around a 3-fold exaggeration; about 3.5 can be a useful moderate preview, not a fixed value for every DEM. Tune exaggeration and blend contrast together. If relief looks too strong, reduce both in small steps; do not jump to a strong 5-fold treatment by default. Check horizontal/vertical units and never multiply the original elevations. Save parameters with derived rasters and invalidate stale hillshade/RGB caches when they change.
- Water: blue. Use blue for rivers, lakes, and water bodies so the thematic palette remains distinguishable.
- Roads: light gray or muted gray-brown, with major roads wider than secondary roads. Use a casing/core double-line symbol where the scale supports it.
- Boundary hierarchy: emphasize the study outline, then prefecture/city boundaries, then county/township boundaries. For a roughly 30 cm province overview, about 1.5–2 pt for the outline and 0.8–1 pt for prefecture lines are useful starting points. County boundaries use a lighter dash-dot line and township boundaries are finer; adapt widths to output size.
- Main rivers: approximately 1.2–1.5 pt; tributaries: approximately 0.5–0.7 pt; adjust for map scale.
- Labels: only label the administrative units, major rivers, roads, or points needed for interpretation. Do not turn on every label.

## Thematic Symbolization

- Choose a classification method from the actual data distribution. Do not force equal intervals, natural breaks, or unique values merely because the software default is convenient.
- Use sequential or diverging colors that match the meaning of the indicator. Avoid rainbow ramps and excessive high-saturation colors.
- When water features are blue, avoid blue for the thematic result. For water-resource abundance indicators, use a light-to-dark green sequence; darker green means greater abundance.
- Do not encode a larger value as a red warning color unless the indicator is explicitly a risk, pressure, or deficit measure. For example, a high production-water modulus means more water resources per unit area; it is not automatically a water-supply risk.
- Rename fields and class labels into readable Chinese. Do not leave `GRIDCODE`, raw field names, unexplained 1–5 values, or per-class counts in the final legend unless requested.
- Keep the thematic layer visually dominant. Lower the contrast of DEM, hillshade, roads, boundaries, and surrounding context before increasing thematic saturation.

## Layout Standard

Use a compact map page without a large empty side panel. Choose the framing for the requested purpose.

- Keep the complete study boundary visible within the chosen framing, with room for geographic ticks. Preserve surrounding geography when it is part of the requested view.
- The main map frame should occupy most of the page, with only enough outer margin for readable coordinates. For a new overview, the 1.2 display factor makes the boundary's longest dimension about 83% of the square side. For a close thematic view, roughly 85–95% can be useful when geometry allows. Preserve explicitly requested context instead of forcing an occupancy target.
- A new province or regional overview includes a simple national locator by default unless the user omits it or an equivalent locator already exists. Use a small independent editable map frame, a solid white background, a thin border and a distinct study-area fill. Prefer the lower-left corner above the main scale bar when clear of the study boundary and its shadow; choose another free corner if necessary. Do not confuse it with a central-city detail inset, which is optional.
- Use suitable complete national material, independent of the main-map clip. For China, check Taiwan, offshore islands and South China Sea depiction against a suitable reference; a community dataset is not an approved standard map. Prefer official standard-map material when appropriate and preserve required notices. Do not invent boundary segments or present a partial locator as complete. If only a licensed reference image is usable, retain it with provenance and disclose that its geography is not editable.
- A central-city detail inset, when requested, may use the upper-left free area with its own nearby heading and scale. Do not add a second detail inset simply because the layout allows one.
- Put the north arrow at the upper right. Use the native `ArcGIS 指北针 2` style when available.
- Put the legend at the lower right, far enough right and down to clear the study area and its shadow while remaining inside the frame. Use two columns: thematic classes and reference features for thematic maps; balanced boundary/place and water/transport groups for an overview without thematic classes.
- Create one white or very pale translucent panel enclosing all legend content. Leave visible inner padding, typically about 12 pt horizontally and 10 pt vertically at the reference page size. Check the full padded panel, not just text bounds, for overlap. ArcGIS CIM `backgroundGapX/Y` are points, not page inches; convert units when calculating the panel footprint.
- Put the title, legend, scale bars, north arrow, and other required layout elements inside the map frame/page composition. Remove unnecessary outer page rectangles; retain the inner map-frame boundary.
- Keep internal figure codes, optional source/projection notes, processing subtitles, and long estimation explanations outside the exported image unless requested. Always retain any attribution or notices required by the selected data license, in the required location. Put the indicator unit directly in the legend title.

## Coordinate Frame And Typography

- Use a geographic graticule around the map frame so the four sides show longitude/latitude coordinates. Keep interior grid lines invisible or very light.
- For province-wide or similarly broad extents, start with whole-degree ticks and labels, omitting half-degree/minute subdivisions. At smaller extents use 30-minute or finer intervals only where useful. Labels should include `E` and `N`, omit zero minutes/seconds and remain readable on all four sides.
- Chinese text: `SimSun` / 宋体. English letters and numbers: `Times New Roman`.
- At a roughly 30 cm overview page, start with a 28–30 pt bold title and a subtle 2–3 pt white halo over terrain; use about 16 pt city labels, 18–20 pt neighboring-region names and 12–14 pt major water labels. Scale to the final reproduction size rather than copying points blindly.
- Legend title: SimSun, bold, about 20–22 pt; labels about 16–18 pt. Use SimSun for Chinese labels and Times New Roman for Latin text and numeric values.
- Scale bars: two divisions, `km`, Times New Roman, bold, about 16–18 pt. Remove unnecessary subdivisions.
- Keep font families consistent after reopening the project; do not assume that a screen preview proves the font was saved.

## Optional Floating Shadow

For a presentation-style floating city effect, create a separate decorative shadow layer rather than altering the study geometry:

- Duplicate the study boundary, offset it slightly toward the lower-right, and use one or more buffers to create a soft, middle, and edge shadow. Subtract the true study polygon so the shadow stays outside it.
- A longer, darker effect can start around 2–3 km of offset, with buffer distances around 0.8–1.8 km. Tune the values against the map scale and keep the shadow outside the true boundary.
- Use dark gray or dark gray-green with transparency. The shadow should be visible along the edge but never compete with the thematic colors, labels, rivers, or legend.
- Export shadow-on and shadow-off previews separately when the user is deciding on the final style.
- Record that the shadow is decorative and does not change the indicator geometry, spatial statistics, or analytical result.

## Export And Validation

For base-data-only work, use the handoff in [Base Geography Preparation](references/base-geography.md); APRX and final map exports are not required. Follow the project's folder conventions and preserve raw inputs separately from processed data.

For a map delivery, package the editable outputs with their required local data and provenance in a clearly named folder:

- Editable `.aprx` with all paths local and relative where practical.
- File geodatabase containing processed vectors and rasters, with all required sidecars preserved for Shapefiles.
- PNG preview for quick review.
- JPEG at 600 dpi or higher when requested for reports or printing.
- PDF for vector-preserving delivery. EPS is optional for English journal workflows when the target software accepts it.
- A short JSON or Markdown QA record describing source data, projection, classification, layer counts, export settings, and known limitations.

Before reporting completion, reopen the exported project and check:

- No broken layers, online layers, missing rasters, or uncovered DEM area inside the map frame.
- Base-data QA covers the displayed surroundings as well as the study area; any unresolved source, coverage, alignment, or label issues remain explicit.
- The city/study boundary is fully visible and occupies the intended frame.
- Thematic values and class codes match the source table; no values were silently rounded, recoded, sorted, or dropped.
- The legend panel is below all legend content, encloses both columns with visible padding, and has no overflow.
- The locator background is opaque in the actual export, not merely in a settings object; in ArcGIS check the saved map background and frame `useMapBackgroundColor`. Reopen and check every map/frame, including the national locator, for missing sources and clipped extent.
- The inset, padded legend, title, north arrow and scale bars do not cover the study boundary, decorative shadow or one another. Recheck river/lake labels near the title and north arrow after extent changes; suppress or move conflicting labels without deleting their geographic features.
- County boundary dash pattern, water blue, non-blue thematic colors, font families, two scale-bar divisions, graticule labels, and export DPI match the requested style.
- The final raster dimensions and embedded DPI are correct, and the preview is inspected at the intended report size.
- QA records the actual rendered exaggeration, blend settings, acquisition/display factors and unresolved data gaps. Set visual review to pending after each export and mark it passed only after inspecting that version. An old successful review does not validate a new render.

## ArcMap Compatibility

ArcGIS Pro is the primary production environment for this skill. When the target computer uses ArcMap 10.2, keep the same data, field names, colors, layout positions, and cartographic specifications, but implement symbols and layout elements with ArcMap-compatible manual settings. Do not rely on ArcGIS Pro CIM-only edits, Pro-only project files, or online services for the old production computer.
