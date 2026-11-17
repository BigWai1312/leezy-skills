# Base Geography Preparation

Read this reference when inventorying, acquiring, or validating base geography.
It supports both checklist-only and execution requests; the user's current scope
determines whether downloads and processing are allowed.

## Scope And Inventory

Record the study area, intended map scale, reference year, required layers, local
search roots, and target extent. Use the defaults below when those details can be
reasonably inferred. Do not make a checklist an additional approval gate when the
user has already requested acquisition or map production.

Inspect files and usable metadata in the supplied project folders before fetching
anything. A README, filename, or prior completion claim is a lead, not proof that
a dataset is complete or fit for the new extent. Reuse adequate coverage; acquire
only missing layers or missing coverage. Do not overwrite raw data.

For each layer, record one status: `found_unverified`, `missing`, `downloaded`,
`validated`, `blocked`, or `not_needed`. Include the reason, coverage, source
version, and remaining checks. Never equate an HTTP success or a file count with
successful acquisition.

The base-data task excludes spatialized indicators, statistical joins, land-cover
analysis, imagery time series, and indicator recalculation unless requested.
Township boundaries, dense POIs, minor streets, protected areas, and basin datasets
are optional additions driven by the map's scale or subject.

Reusable base geography means datasets and individual editable layers, not a
finished regional overview image. Overview and thematic maps consume this data
independently. A thematic task need not generate an overview, download unused
terrain or inherit an overview's labels and layout; mark unnecessary layers
`not_needed`. A quick coverage QA image is not a final overview deliverable.

When preparation or mapping is requested and local base data are absent, carry
the work through acquisition and validation without requiring a second "download"
instruction. Obtain a credible study boundary first, calculate coverage, then
fetch missing required layers and make local derived copies. A shortlist of
providers or online layer URLs alone is not a delivered basemap. If the user
prohibits network access or downloads during execution, inventory local gaps
instead. Requiring an offline final project alone does not prohibit acquisition.

## Base-Layer Checklist

All context layers must support the same context square. Sparse vector features
need complete source coverage of that square, not an artificial feature in every
part of it. Preserve identifiers and native attributes alongside display fields.

| Layer | Contents and fields | Scope |
| --- | --- | --- |
| Study boundary and first-level subdivisions | Complete polygons; stable code, local-language name, parent code, source version and applicable year | Required; prefer a consistent source family for the outer boundary and subdivisions |
| Finer administrative boundaries | County/district or next-level polygons, names, codes, parent relationships | Recommended reserve for province/city base packages; display only at useful scales |
| Neighboring administrative geography | Surrounding province/region and city-level boundaries and names | Required for surrounding-context maps; preserve full source geometries separately from clipped display copies |
| Elevation | DEM raster, NoData definition, horizontal CRS, vertical units and datum when documented | Prefer a suitable approximately 30 m source for regional context; cover the square plus a small processing margin |
| River lines | Main rivers and useful tributaries; IDs, names, hierarchy/order, provenance of any derived cartographic rank | Required where present; preserve continuity across the study boundary |
| Water polygons | Lakes, reservoirs, and wide-river surfaces; ID, name, type, shoreline date or time basis | Required where present; distinguish permanent/generalized water from a particular year's observed extent |
| Major transport | Motorways, major national routes, railways and high-speed rail where relevant; name/reference, class, operational status, snapshot date | Prepare for general reference maps; omit if excluded by the user or unnecessary for the requested map |
| Place names and reference points | Administrative seats, selected towns, major rivers/lakes/mountains and neighboring cities; ID, name, type, coordinates, label priority, evidence | Check local-language spelling and duplicate names; keep physical locations separate from movable label anchors |
| Locator inset material | Suitable complete national/regional reference map and study-area location | Default for a new regional overview unless omitted; otherwise optional; independent of the main coverage, with its own source, extent and usage terms |

For a China province package, the first two administrative levels normally mean
province and prefecture/city/autonomous prefecture; retain counties as a finer
reserve. Adapt levels to the region rather than hard-coding Hunan or a fixed count.

Hillshade, simplified display boundaries, filtered roads, water styling ranks,
and label tables are derived outputs, not separate datasets to download again.

## Define The Context Square

Resolve a credible study boundary first. If it is missing, obtaining it is the
first acquisition step. Do not invent its extent from a place-name coordinate.

Use a projected CRS suitable for the whole region, with linear units in metres
and acceptable distortion. For a broad region, do not blindly choose one narrow
local projection zone. Record the CRS definition and any transformations.

For projected boundary bounds `(xmin, ymin, xmax, ymax)`:

```text
width = xmax - xmin
height = ymax - ymin
cx = (xmin + xmax) / 2
cy = (ymin + ymax) / 2
acquisition_factor = 1.4
display_factor = 1.2
acquisition_side = acquisition_factor * max(width, height)
display_side = display_factor * max(width, height)
acquisition_bounds = (cx - acquisition_side/2, cy - acquisition_side/2,
                      cx + acquisition_side/2, cy + acquisition_side/2)
display_bounds = (cx - display_side/2, cy - display_side/2,
                  cx + display_side/2, cy + display_side/2)
```

Require finite bounds, positive width/height, and a factor of at least 1 unless
the user deliberately wants to crop the study area. Honor explicit extents and
padding settings over this default.

The acquisition square provides processing and layout reserve; it need not all
appear in the final map. With factor 1.4, each end of the original longer
dimension gains 20% of that dimension; with factor 1.2, each end gains 10%.
The shorter dimension gains more to make a square. These factors refer to side
length, not area. Both squares are measured in the chosen projection, not in
angular degrees. Preserve wider coverage already downloaded when tightening the
display; do not reacquire or resample a DEM just because the map view changes.

Save the study boundary, acquisition square and display polygon separately, with each factor,
CRS, numeric bounds, and boundary source. For geographic download APIs, densify
the projected square edges before transforming, take a conservative geographic
envelope, and select all intersecting tiles. Mosaic and trim only derived copies.
For rotated or rectangular map frames, verify their actual footprint is covered.

## Source Selection And Acquisition

Prefer verified local data, then suitable official/public-authority sources,
then established open scientific or community sources with documented usage
terms. Select by coverage, scale, vintage, attributes, and license; "newest" alone
does not make a source appropriate for a historical map.

Useful discovery starting points, not fixed download URLs or promises of local
coverage:

- Administrative boundaries and names: relevant mapping, civil-affairs, and
  regional government data portals. Keep a standard reference map for checking
  depiction when appropriate; do not mistake a map image for an analytical
  polygon dataset.
- Elevation: the publisher's [NASA Earthdata catalog](https://www.earthdata.nasa.gov/)
  for SRTM/NASADEM, or another documented elevation product suited to the region.
  Verify terrain versus surface-model semantics, resolution, dates and access.
- Hydrography: [HydroRIVERS](https://www.hydrosheds.org/products/hydrorivers) and
  [HydroLAKES](https://www.hydrosheds.org/products/hydrolakes) are candidate river
  and lake products. Check their scale, feature thresholds, attributes and
  shorelines; do not assume complete small waters or local-language names.
- Roads, railways, water detail and places:
  [Geofabrik's OpenStreetMap extracts](https://download.geofabrik.de/) are a
  candidate source. Inspect the actual regional footprint and available formats;
  an extract named for the study province may omit needed neighboring coverage.
  Read the [OpenStreetMap usage and attribution terms](https://www.openstreetmap.org/copyright)
  before preparing reusable outputs.
- National locator: prefer suitable official reference material; established
  cartographic/community sources may be used for a documented research schematic.
  Inspect the whole national extent and islands, not just the study province.
  Keep its dataset, CRS and usage notices separate from the main-map clip.

At execution time, inspect the publisher's current catalog/documentation for the
actual version, download route and terms. Do not assume remembered endpoints or
credentials still work. Record which source governs each layer if sources differ.
Do not call an open or approximate administrative boundary authoritative merely
because it looks plausible. Do not combine incompatible snapshots without notes.

Use public downloads or existing authorized sessions without repeated permission
requests. New paid access, missing credentials, or a download restriction is a
specific blocker: seek a suitable permitted alternative, otherwise report the
affected layer and continue independent work. Do not bypass access controls or
publish private inputs to obtain public base data.

Estimate the download size and local working space before large acquisitions.
Use bounded requests, modest concurrency, resumable files and provider-aware
backoff. If two bounded retry attempts fail for the same source, record the
failure and assess an alternative; do not poll forever or repeatedly restart
completed downloads. Keep partial files visibly separate from usable data.

Check archives and read datasets with a GIS reader, then record file sizes and
SHA-256 hashes. Download only the needed tiles or bounded region when supported;
if a provider only offers a larger archive, preserve it and derive a local clip.

### DEM Must Be A Real Local Dataset

- Download and open actual elevation cells covering the acquisition square and
  processing margin. A hillshade image, web service connection, catalog link,
  partial archive or terrain screenshot does not satisfy a DEM request.
- Prefer a documented approximately 30 m product for regional terrain where
  available. If the user explicitly requires 30 m, a coarser preview does not
  complete that request. Use permitted alternate products after bounded failures;
  report any remaining resolution/coverage gap instead of claiming success.
- If no exact resolution was required, a coarser source may support a clearly
  identified preview when fit for the intended scale. Record native resolution,
  requested/export grid spacing and derived cell size separately. Service image
  pixel dimensions do not establish native terrain resolution; a 400–500 m
  export is not a 30 m DEM even when the service contains finer source data.
- Preserve original elevations and NoData. Reproject/mosaic derived copies,
  inspect holes and seams, check horizontal/vertical units, then create hillshade
  and tinted relief. Finer resampling or stronger shadows do not add information.
- Record the actual exaggeration and blend used in the map; name or key derivative
  caches by their inputs and rendering parameters so a style change cannot
  silently reuse an old hillshade or RGB raster.

## Preparation And Acceptance

Produce processed copies in a common working projection, preserving the original
CRS and raw files. Do not merely assign a CRS to move misaligned data. Investigate
datum, projection and provider-specific coordinate conventions when layers shift.
Retain full boundary geometry for analysis; simplification and label displacement
belong to separate cartographic layers.

Apply the following checks before marking a layer `validated`:

| Check | Required evidence |
| --- | --- |
| Coverage | DEM valid-data coverage across the context square, with unexplained holes reported; source footprints/tiles/queries establish vector coverage across it, not just feature bounding boxes |
| Geometry | Readable nonempty layers, geometry validity, duplicate IDs, unexpected overlaps/gaps, and agreement between parent/subdivision boundaries within a recorded scale-appropriate tolerance |
| Alignment | Known control locations and cross-layer overlays show no unexplained shifts; inspect cross-border road/river continuity without forcing unrelated features to snap |
| Elevation | Plausible values and units, NoData accounting, tile seams and vertical-reference consistency; terrain derivatives do not introduce a blank rim in the display footprint |
| Water and transport | Useful class/rank fields, main features present, line/polygon consistency, operational-status and shoreline-time caveats; inspect seams after mosaicking extracts |
| Names and attributes | Readable local-language names, code types, duplicates, nulls and parent links; unnamed features are flagged, not assigned guessed names |
| Provenance and reuse | Source, dataset version, actual reference period, download timestamp, CRS, scale/resolution, field definitions, license/attribution, hashes and local paths are recorded |

Maintain a small checked label table for priority administrative seats and major
water features: source ID, Chinese name, category, coordinate/CRS and label
priority. Preserve source water classes or record any derived cartographic rank;
separate main rivers, tributaries, lakes and reservoirs where the data support it.
Check the expected major rivers individually: a generalized dataset may be
readable and geometrically valid while omitting an important river. Do not fill
such a gap with a hand-drawn or invented line.

For locator imports, inspect mixed line/polygon records before conversion.
Retain island/sea-boundary lines as lines instead of discarding them as empty
polygons. If 64-bit feature IDs prevent a DBF QA report, use a compatible
geodatabase table rather than dropping the geometry check.

Measure and record results, tolerances, and unresolved exceptions. Unknown source
accuracy or unperformed external validation remains unknown even if geometry and
alignment checks pass. A prettier rendering is not evidence of analytical accuracy.

Inspect a lightweight QA overview of the complete context square and representative
seams/labels at the intended map scale. This can be a quick GIS render rather than
a final designed map or APRX. If rendering is unavailable, report visual QA as
unperformed instead of declaring the package fully checked.

## Offline Handoff

Follow project directory conventions: separate raw downloads, cache/intermediates,
reusable scripts, documentation, and dated final outputs. Use portable paths in
shared records; never include credentials, signed download URLs, or private local
paths in public skill repositories.

Hand off:

- Offline processed vectors and rasters (GDB or GeoPackage and GeoTIFF as supported
  by the target GIS), with required sidecars and preserved original data.
- Study boundary, acquisition square, display polygon when mapping, and extent metadata.
- A layer inventory/source manifest including status and field definitions; use
  UTF-8 with BOM for CSV intended for Excel when the project requires it.
- A QA record, available overview image, known limitations, and reproducible
  processing steps or scripts when needed.

Retain required visible attribution in produced maps; do not hide it solely in
metadata because the default layout prefers minimal notes. Keep raw downloads
locally, and check redistribution terms before bundling them for another user.
When acquisition is incomplete, list the missing layers explicitly; do not label
the package fully ready. Base-data-only work does not require thematic maps,
indicator calculations, or an ArcGIS Pro project.
