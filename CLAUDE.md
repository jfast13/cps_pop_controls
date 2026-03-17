# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A GitHub Pages static site visualizing historical CPS (Current Population Survey) population control adjustments (1996–2026). Data was manually collected from [BLS CPS Technical Documentation](https://www.bls.gov/cps/documentation.htm#pop).

## Structure

- `index.html` — the entire site: Chart.js line charts with a toggle between Total / By Race / By Gender views
- `data/popcontrols_cps1996_2026.csv` — source CSV (data is embedded directly in `index.html` for simplicity)

## Key details

- **Missing years**: 2000–2002 have no published data; stored as `null` in the JS arrays so Chart.js renders a line gap
- **Census-switch years** (red dashed vertical lines): 2003, 2012, 2022, 2026 — controlled by the `CENSUS_SWITCH_YEARS` array in `index.html`
- **Sex breakdown caveat**: Male/Female values for 1999 and 2003–2011 cover persons aged 20+ only (noted in the About section)
- Dependencies loaded via CDN: Chart.js 4.4.0, chartjs-plugin-annotation 3.0.1

## GitHub Pages deployment

Enable under Settings → Pages → Source: `main` branch, `/ (root)`. The site will be served from `index.html` at the repo root.
