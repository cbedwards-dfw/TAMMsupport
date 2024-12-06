
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TAMMsupport

<!-- badges: start -->
<!-- badges: end -->

The goal of `{TAMMsupport}` is to provide R-based tools for working with
and interpreting Terminal Area Management Module files
(<https://framverse.github.io/fram_doc/calcs_glossary.html#Terminal_Area_Management_Module_(TAMM)>).

`{TAMMsupport}` is part of the [“framverse” R universe of
packages](https://framverse.r-universe.dev/packages).

## Cheatsheet

I want to…

- Summarize and visualize key aspects of a Chinook TAMM? Use
  `tamm_report()`.
- compare two Chinook TAMM files to look for changes in inputs or
  results? Use `tamm_diff()`. (Comparing Coho TAMM files is currently
  supported, but does not replicate Coho TAMM formatting)
- compare two or more Chinook TAMM files (e.g. look across three ocean
  options) to see how ER varies by stock and fishery between the models?
  Use `tamm_compare()`.
- extract the overview sheet info from a Chinook TAMM? Use
  `read_overview()` or `read_overview_complete()`.
- extract the limiting stock complete sheet from a Chinook TAMM? Use
  `read_limiting_stock()` or `clean_limiting_stock()`. If desired, use
  `filter_tamm_wa()` to then filter the results to just Washington
  fisheries.
- Trace the network of cells used by a formula in a TAMM (or other excel
  file)? Use `trace_formula()` to generate a dependency network, and
  `make_tracer_network()` to visualize it.

## Installation

You can install the compiled version of `{TAMMsupport}` through the
R-universe package repository:

``` r
install.packages("TAMMsupport", repos = "https://framverse.r-universe.dev")
```

If you have RTools installed, you can also install the development
version of TAMMsupport with `{devtools}` like so:

``` r
devtools::install_github("cbedwards-dfw/TAMMsupport")    
```

or with `{pak}` like so:

``` r
pak::pkg_install("cbedwards-dfw/TAMMsupport")
```

`TAMMsupport` depends on the `xldiff` package, which contains our
general tools for comparing excel files using R. `xldiff` should
automatically be installed when `TAMMsupport` is. `xldiff` and its
documentation can be found here:
<https://github.com/cbedwards-dfw/xldiff>.

With `TAMMsupport` installed, we can use functions from it by including
the library in our script, like so:

``` r
library(TAMMsupport)
```

## `tamm_diff()`

`tamm_diff()` facilitates comparing the outputs and inputs of two tamm
files by identifying changes in cell values in the overview, limiting
stock complete, and input sheets. `tamm_diff` then creates a “diff”
excel file that contains the contents of those three sheets,
highlighting the changed cells. The formatting of the diff file broadly
reflects that of the Chinook TAMM, but with simpler border and
highlighting choices.

`tamm_diff()` takes three arguments: the names of the first TAMM file,
the second tamm file, and the name to give the resulting file (in all
cases, the name should include filepath, if relevant). All three
filenames should end in “.xlsx”. The following is an example use:

``` r
cur.wd = getwd()
setwd("C:/Users/edwc1477/OneDrive - Washington State Executive Branch Agencies/Documents/WDFW FRAM team work/NOF material/NOF 2024")

tamm_diff(filename.1 = "FRAM/Chin1124.xlsx",
          filename.2 = "NOF 2/Chin2524.xlsx",
          results.name = "comparison of Chin 1124 vs 2524.xlsx"
)

setwd(cur.wd)
```

By default, `tamm_diff()` rounds percents and numbers of fish to the
nearest 0.1 (1 decimal place) before comparing, and rounds numbers that
are expected to be longer decimanls (e.g. rates, proportions) to the
nearest 0.0001 (4 decimal places). In some cases, we may want to solely
focus on larger changes (e.g. changes in whole fish). The optional
arguments `percent.digits`, `numeric.digits` and `numeric.digits.small`
control the decimal place rounding for percents, numbers of fish, and
numbers that are expected to be rates or proportions, respectively. To
highlight only larger changes, we might use

``` r
tamm_diff(filename.1 = "FRAM/Chin1124.xlsx",
          filename.2 = "NOF 2/Chin2524.xlsx",
          results.name = "comparison of Chin 1124 vs 2524.xlsx",
          percent.digits = 1, numeric.digits = 0, numeric.digits.small = 3
)
```

Note that since we typically manage ER to the nearest 0.1%, it is
unlikely that a percent.digits value of 0 would be useful.

Currently `tamm_diff()` only works well when comparing Chinook TAMM
files. Comparison of Coho TAMM files is in development – the comparison
itself works, but the output file does not replicate the formatting of
the Coho TAMM, which makes reading the file unpleasant.

## Working with limiting stock sheet

`read_limiting_stock()` reads in the limiting stock sheet of a TAMM file
and applies some minimal formatting and filtering (notably, combining
into a single table with variable `stock_type` to distingish hatchery
and natural, unmarked and natural; giving categorization of fisheries).

`clean_limiting_stock()` does everything read_limiting stock does, but
then filters to unmarked naturals, filters out AEQ entries, and provides
the results in a long-form table that is ready for plotting or analysis
of exploitation rates.

`filter_tamm_wa` filters a limiting stock dataframe (e.g. the output of
`read_limiting_stock or` `clean_limiting_stock`) to just Washington
fisheries. `filter_tamm_wa` looks for a `species` attribute in the
dataframe (in line with This function can be included in a pipe,
consistent with the filtering approaches in the `framrsquared package`.
Unless you add that attribute to your data frame, it makes more sense to
call `filter_tamm_wa_chin()` (for chinook TAMMs) or
`filter_tamm_wa_coho()` (for Coho tamms)

``` r
library(ggplot2)
library(dplyr)
clean_limiting_stock("Chin1224.xlsx") |> 
  filter_tamm_wa_chin() |> 
  filter(timestep == "yr")
  ggplot(aes(x = stock, y = er, fill = Fishery))+
    geom_bar(position="stack", stat="identity")
```

## Tools in development

These tools are functional, but still being developed.

### `tamm_report()`

`tamm_report()` summarizes key aspects of a single Chinook TAMM file in
an html report, which is generated in the same folder as the summarized
TAMM.

Under the hood, tamm_report() uses a template parameterized quarto
report and a child quarto file to help automate the creation of tabs for
each stock. To see the underlying quarto files used (e.g., to suggest
additional edits or features), set argument `clean = FALSE` when calling
`tamm_report()`. This will prevent the deletion of `tamm-visualizer.qmd`
and `tamm-visualizer-child.qmd`, which will be present in the same
folder as the TAMM and report.

Future goals include

- workshopping and adding additional summary information based on user
  needs

### `tamm_compare()`

`tamm_compare()` uses the same general approach as `tamm_report()`, but
creates a report to compare any number TAMM files based off of Yi Xu’s
Rmarkdown report to compare exploitation rates for three ocean options.
The optional argument `fisheries` takes a numeric vector of fishery IDs;
visualization of stock ERs will only plot those ERs. If `fisheries` is
not provided, for each stock `tamm_compare()` will create a figure of
impacts from all fisheries, and a separate plot of impacts from all SUS
fisheries.

## Stock, Fishery, and Timestep tables

FRAM and TAMM often use stock ID number, fishery ID number, and time
step number to represent stock, fishery, and timestep respectively.
TAMMsupport includes dataframe versions of the `Stock`, `Fishery`, and
`TimeStep` tables of the Coho and Chinook FRAM databases for easy
reference and to streamline merging human-readable names to dataframes
that have only id numbers. These dataframes are named
`fishery_chinook_fram`, `fishery_coho_fram`, `stock_chinook_fram`,
`stock_coho_fram`, `timestep_chinook_fram`, and `timestep_coho_fram`,
and have associated help files accessible with `?fishery_chinook_fram`
etc. The initial rows of these dataframes are shown below.

### `stock_chinook_fram`

``` r
knitr::kable(head(TAMMsupport::stock_chinook_fram, 5))
```

| species | stock_version | stock_id | production_region_number | management_unit_number | stock_name | stock_long_name |
|:---|---:|---:|---:|---:|:---|:---|
| CHINOOK | 5 | 4 | 1 | 6 | M-NK Sp Hat | Marked Nooksack Spr Hatchery |
| CHINOOK | 5 | 6 | 1 | 10 | M-NK Sp Nat | Marked Nooksack Spr Natural |
| CHINOOK | 5 | 8 | 2 | 2 | M-Skag FF | Marked Skagit Summer/Fall Fing |
| CHINOOK | 5 | 10 | 2 | 6 | M-SkagFYr | Marked Skagit Summer/Fall Year |
| CHINOOK | 5 | 12 | 2 | 10 | M-SkagSpY | Marked Skagit Spring Year |

### `stock_coho_fram`

``` r
knitr::kable(head(TAMMsupport::stock_coho_fram, 5))
```

| species | stock_version | stock_id | production_region_number | management_unit_number | stock_name | stock_long_name |
|:---|---:|---:|---:|---:|:---|:---|
| COHO | 1 | 1 | 1 | 1 | U-nkskrw | Nooksack River Wild UnMarked |
| COHO | 1 | 2 | 1 | 2 | M-nkskrw | Nooksack River Wild Marked |
| COHO | 1 | 3 | 1 | 3 | U-kendlh | Kendall Creek Hatchery UnMarked |
| COHO | 1 | 4 | 1 | 4 | M-kendlh | Kendall Creek Hatchery Marked |
| COHO | 1 | 5 | 1 | 5 | U-skokmh | Skookum Creek Hatchery UnMarked |

### `fishery_chinook_fram`

``` r
knitr::kable(head(TAMMsupport::fishery_chinook_fram, 5))
```

| species | version_number | fishery_id | fishery_name | fishery_title     |
|:--------|---------------:|-----------:|:-------------|:------------------|
| CHINOOK |              1 |         55 | Tr 6B:9Net   | Tr Area 6B:9 Net  |
| CHINOOK |              1 |         56 | A 10 Sport   | NT Area 10 Sport  |
| CHINOOK |              1 |         57 | A 11 Sport   | NT Area 11 Sport  |
| CHINOOK |              1 |         58 | NT10:11Net   | NT Area 10:11 Net |
| CHINOOK |              1 |         59 | Tr10:11Net   | Tr Area 10:11 Net |

### `fishery_coho_fram`

``` r
knitr::kable(head(TAMMsupport::fishery_coho_fram, 5))
```

| species | version_number | fishery_id | fishery_name | fishery_title               |
|:--------|---------------:|-----------:|:-------------|:----------------------------|
| COHO    |              1 |          1 | No Cal Trm   | No Calif Cst Terminal Catch |
| COHO    |              1 |          2 | Cn Cal Trm   | Cntrl Cal Cst Term Catch    |
| COHO    |              1 |          3 | Ft Brg Spt   | Fort Bragg Sport            |
| COHO    |              1 |          4 | Ft Brg Trl   | Fort Bragg Troll            |
| COHO    |              1 |          5 | Ca KMZ Spt   | KMZ Sport                   |

### `timestep_chinook_fram`

``` r
knitr::kable(head(TAMMsupport::timestep_chinook_fram, 5))
```

| species | version_number | time_step_id | time_step_name | time_step_title  |
|:--------|---------------:|-------------:|:---------------|:-----------------|
| CHINOOK |              1 |            1 | Oct-Apr        | October-April    |
| CHINOOK |              1 |            2 | May-June       | May - June       |
| CHINOOK |              1 |            3 | July-Sept      | July - September |
| CHINOOK |              1 |            4 | Oct-Apr-2      | October-April-2  |

### `timestep_coho_fram`

``` r
knitr::kable(head(TAMMsupport::timestep_coho_fram, 5))
```

| species | version_number | time_step_id | time_step_name | time_step_title    |
|:--------|---------------:|-------------:|:---------------|:-------------------|
| COHO    |              1 |            1 | Jan-Jun        | January - June     |
| COHO    |              1 |            2 | July           | July               |
| COHO    |              1 |            3 | August         | August             |
| COHO    |              1 |            4 | Septmbr        | September          |
| COHO    |              1 |            5 | Oct-Dec        | October - December |
