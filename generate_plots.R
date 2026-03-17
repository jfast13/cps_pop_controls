library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(svglite)

# ── Load data ─────────────────────────────────────────────────────────────────
df <- read_csv(
  "data/popcontrols_cps1996_2026.csv",
  col_names = c("year", "total", "white", "black", "hispanic",
                "male", "female", "change_census", "notes"),
  skip = 1,
  col_types = cols(
    year         = col_integer(),
    total        = col_double(),
    white        = col_double(),
    black        = col_double(),
    hispanic     = col_double(),
    male         = col_double(),
    female       = col_double(),
    change_census = col_integer(),
    notes        = col_character()
  )
)

# ── Constants ─────────────────────────────────────────────────────────────────
CENSUS_YEARS <- c(2003, 2012, 2022, 2026)

CAPTION <- paste0(
  "Red dashed lines mark years the CPS adopted a new Census population base.\n",
  "Source: BLS CPS Technical Documentation \u2014 https://www.bls.gov/cps/documentation.htm#pop"
)

SEX_NOTE <- "\nNote: 1999 and 2003\u20132011 values reflect persons aged 20 and older instead of persons 16 and older."

dir.create("plots", showWarnings = FALSE)

# ── Shared theme + geoms ──────────────────────────────────────────────────────
base_theme <- theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor  = element_blank(),
    panel.grid.major  = element_line(color = "gray92", linewidth = 0.4),
    plot.title        = element_text(size = 14, face = "bold", margin = margin(b = 4)),
    plot.subtitle     = element_text(size = 11, color = "gray40", margin = margin(b = 10)),
    plot.caption      = element_text(size = 8.5, color = "gray50", hjust = 0,
                                     margin = margin(t = 10)),
    axis.title.y      = element_text(size = 11, color = "gray35"),
    axis.text         = element_text(size = 10),
    legend.position   = "top",
    legend.title      = element_blank(),
    legend.key.width  = unit(1.6, "lines"),
    plot.margin       = margin(14, 18, 10, 14)
  )

vlines <- geom_vline(
  xintercept = CENSUS_YEARS,
  linetype   = "dashed",
  color      = "#dc2626",
  alpha      = 0.75,
  linewidth  = 0.75
)

hline0 <- geom_hline(yintercept = 0, color = "gray55", linewidth = 0.35)

x_scale <- scale_x_continuous(breaks = seq(1996, 2026, by = 2))

save_plot <- function(p, name, w = 9, h = 5.2) {
  ggsave(paste0("plots/", name, ".svg"), p, width = w, height = h, device = svglite)
  ggsave(paste0("plots/", name, ".png"), p, width = w, height = h, dpi = 150)
  message("Saved: ", name)
}

# ── 1. Total ──────────────────────────────────────────────────────────────────
p_total <- ggplot(df, aes(x = year, y = total)) +
  hline0 + vlines +
  geom_line(color = "#1d4ed8", linewidth = 0.9) +
  geom_point(color = "#1d4ed8", size = 2.2) +
  x_scale +
  labs(
    title    = "Total CPS Population Control Adjustment",
    subtitle = "Annual benchmark adjustment, 1996\u20132026 (thousands of persons)",
    x = NULL, y = "Adjustment (thousands)",
    caption  = CAPTION
  ) +
  base_theme

save_plot(p_total, "total")

# ── 2. By Race / Ethnicity ────────────────────────────────────────────────────
race_long <- df |>
  select(year, White = white, Black = black, Hispanic = hispanic) |>
  pivot_longer(-year, names_to = "group", values_to = "value") |>
  mutate(group = factor(group, levels = c("White", "Black", "Hispanic")))

p_race <- ggplot(race_long, aes(x = year, y = value, color = group)) +
  hline0 + vlines +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2.2) +
  scale_color_manual(values = c(White = "#0891b2", Black = "#16a34a", Hispanic = "#ea580c")) +
  x_scale +
  labs(
    title    = "CPS Population Control Adjustment by Race / Ethnicity",
    subtitle = "Annual benchmark adjustment, 1996\u20132026 (thousands of persons)",
    x = NULL, y = "Adjustment (thousands)",
    caption  = CAPTION
  ) +
  base_theme

save_plot(p_race, "race")

# ── 3. By Sex ─────────────────────────────────────────────────────────────────
sex_long <- df |>
  select(year, Male = male, Female = female) |>
  pivot_longer(-year, names_to = "group", values_to = "value") |>
  mutate(group = factor(group, levels = c("Male", "Female")))

p_gender <- ggplot(sex_long, aes(x = year, y = value, color = group)) +
  hline0 + vlines +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2.2) +
  scale_color_manual(values = c(Male = "#7c3aed", Female = "#db2777")) +
  x_scale +
  labs(
    title    = "CPS Population Control Adjustment by Sex",
    subtitle = paste0("Annual benchmark adjustment, 1996\u20132026 (thousands of persons)",
                      SEX_NOTE),
    x = NULL, y = "Adjustment (thousands)",
    caption  = CAPTION
  ) +
  base_theme

save_plot(p_gender, "gender")

# ── 4–8. Individual series ────────────────────────────────────────────────────
individuals <- list(
  list(col = "white",    label = "White",    color = "#0891b2", note = ""),
  list(col = "black",    label = "Black",    color = "#16a34a", note = ""),
  list(col = "hispanic", label = "Hispanic", color = "#ea580c", note = ""),
  list(col = "male",     label = "Male",     color = "#7c3aed", note = SEX_NOTE),
  list(col = "female",   label = "Female",   color = "#db2777", note = SEX_NOTE)
)

for (item in individuals) {
  p <- ggplot(df, aes(x = year, y = .data[[item$col]])) +
    hline0 + vlines +
    geom_line(color = item$color, linewidth = 0.9) +
    geom_point(color = item$color, size = 2.2) +
    x_scale +
    labs(
      title    = paste0("CPS Population Control Adjustment \u2014 ", item$label),
      subtitle = paste0("Annual benchmark adjustment, 1996\u20132026 (thousands of persons)",
                        item$note),
      x = NULL, y = "Adjustment (thousands)",
      caption  = CAPTION
    ) +
    base_theme

  save_plot(p, item$col)
}

message("\nDone. All plots written to plots/")
