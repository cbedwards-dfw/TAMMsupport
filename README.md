
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TAMMsupport

<!-- badges: start -->
<!-- badges: end -->

The goal of TAMMsupport is to provide R-based tools for working with and
interpreting Terminal Area Management Module files
(<https://framverse.github.io/fram_doc/calcs_glossary.html#Terminal_Area_Management_Module_(TAMM)>).

## Cheatsheet

I want to…

- Summarize and visualize key aspects of a Chinook TAMM? Use
  `tamm_report()`.
- compare two Chinook TAMM files to look for changes in inputs or
  results? Use `tamm_diff()`.
- compare three Chinook TAMM files (e.g. three ocean options) to see how
  ER varies by stock and fishery between the models? Use
  `tamm_compare3()`.
- extract the overview sheet info from a Chinook TAMM? Use
  `read_overview()` or `read_overview_complete()`.
- extract the limiting stock complete sheet from a Chinook TAMM? Use
  `read_limiting_stock()` or `clean_limiting_stock()`. If desired, use
  `filter_tamm_wa()` to then filter the results to just Washington
  fisheries.

## Installation

You can install the development version of TAMMsupport like so:

``` r
devtools::install_github("cbedwards-dfw/TAMMsupport)    
```

or

``` r
pak::pkg_install("cbedwards-dfw/TAMMsupport")
```

`TAMMsupport` depends on the `xldiff` package (which contains tools for
comparing excel files using R).

You can install the development version of `xldiff` like so:

``` r
devtools::install_github("cbedwards-dfw/xldiff)  
```

Or

``` r
pak::pkg_install("cbedwards-dfw/xldiff")
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
filenames should end in “.xlsx”. The following is an example use

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

Currently `tamm_diff()` only works when comparing Chinook TAMM files. In
the future we could extend this to also work for Coho TAMM files.

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
fisheries. This function can be included in a pipe, as in

``` r
clean_limiting_stock("Chin1224.xlsx") |> 
filter_tamm_wa() |> 
ggplot(STUFF)
```

## Tools in development

These tools are still in development/prototyping stages, but are
functional.

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
- modifying the .qmd and function to include optional additional
  user-provided child .qmd documents, so that individual entities (wdfw,
  tribes, etc) can systematically include additional visualizations or
  summaries that may not be relevant to other entities.

### `tamm_compare3()`

`tamm_compare3()` uses the same general approach as `tamm_report()`, but
creates a report to compare three TAMM files based off of Yi Xu’s
Rmarkdown report to compare exploitation rates for three ocean options.

Future goals include

- generalizing to compare N TAMM files (e.g., make sure it works if we
  only have 2 ocean options, or end up with four).
