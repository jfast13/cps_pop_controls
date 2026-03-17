# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A GitHub Pages static site visualizing historical CPS (Current Population Survey) population control adjustments (1996–2026). Data was manually collected from [BLS CPS Technical Documentation](https://www.bls.gov/cps/documentation.htm#pop).

## Structure

- `generate_plots.R` — reads the CSV and writes all SVG + PNG chart files to `plots/` using ggplot2
- `plots/` — generated chart files (SVG used by the site, PNG used by README); **committed to the repo**
- `index.html` — GitHub Pages site; displays pre-generated SVGs with a JS toggle (no build step at serve time)
- `data/popcontrols_cps1996_2026.csv` — source data, manually collected

## Regenerating charts

```r
Rscript generate_plots.R
```

Requires R packages: `ggplot2`, `dplyr`, `tidyr`, `readr`, `svglite`.

## Key details

- **Missing years**: 2000–2002 have no published data; `df` simply has no rows for those years, causing a natural gap in ggplot2 line charts
- **Census-switch years** (red dashed vertical lines): 2003, 2012, 2022, 2026 — controlled by `CENSUS_YEARS` in `generate_plots.R`
- **Sex breakdown caveat**: Male/Female values for 1999 and 2003–2011 cover persons aged 20+ only
- Chart views: Total, By Race/Ethnicity, By Sex, White, Black, Hispanic, Male, Female

## GitHub Pages deployment

Enable under Settings → Pages → Source: `main` branch, `/ (root)`. The site is served from `index.html`; the `plots/` folder must be committed for the images to load.
