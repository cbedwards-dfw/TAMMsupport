
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TAMMsupport

<!-- badges: start -->

[![R-CMD-check](https://github.com/cbedwards-dfw/TAMMsupport/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cbedwards-dfw/TAMMsupport/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/cbedwards-dfw/TAMMsupport/graph/badge.svg)](https://app.codecov.io/gh/cbedwards-dfw/TAMMsupport)
<!-- badges: end -->

The goal of `{TAMMsupport}` is to provide R-based tools for working with
and interpreting Terminal Area Management Module files
(<https://framverse.github.io/fram_doc/calcs_glossary.html#Terminal_Area_Management_Module_(TAMM)>).

`{TAMMsupport}` is part of the [“framverse” R universe of
packages](https://framverse.r-universe.dev/packages).

## Installation

You can install the compiled version of `{TAMMsupport}` through the
R-universe package repository:

``` r
install.packages(c("TAMMsupport", "xldiff"), repos = "https://framverse.r-universe.dev")
```

If you have RTools installed, you can also install the the package from
the github repository with

``` r
pak::pkg_install("cbedwards-dfw/TAMMsupport")

## OR

devtools::install_github("cbedwards-dfw/TAMMsupport")    
```

To install the development version, which may include new features that
have been added but may not be as thoroughly tested:

``` r
pak::pkg_install("cbedwards-dfw/TAMMsupport@dev")
```

## Cheatsheet

I want to…

- Summarize and visualize key aspects of a Chinook TAMM? Use
  `tamm_report()`. (OR, even better, check out the [crayolaTAMM
  package!](https://cbedwards-dfw.github.io/crayolaTAMM/))
- compare two Chinook TAMM files to look for changes in inputs or
  results? Use `tamm_diff()`.
- compare two or more Chinook TAMM files (e.g. look across three ocean
  options) to see how ER varies by stock and fishery between the models?
  Use `tamm_compare()`.
- extract the overview sheet info from a Chinook TAMM? Use
  `read_overview()` or `read_overview_complete()`.
- extract the limiting stock complete sheet from a Chinook TAMM? Use
  `read_limiting_stock()` or `clean_limiting_stock()`. If desired, use
  `filter_tamm_wa()` to then filter the results to just Washington
  fisheries.
- extract the ER and AEQ of the `2A_C*` and `JDF` tabs? Use
  `read_2a_sheets()` and `read_jdf()` respectively.
- Trace the network of cells used by a formula in a TAMM or other excel
  file? Use `trace_formula()` to generate a dependency network, and
  `make_tracer_network()` to visualize it.

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
tamm_diff(file_1 = "Chin1124.xlsx",
          file_2 = "Chin2524.xlsx",
          results_name = "comparison of Chin 1124 vs 2524.xlsx"
)
```

By default, `tamm_diff()` flags changes that were at least 0.1% of the
value in `file_1` (or, if that value was zero, to within an absolute
value of 0.001). In some cases, we may want to solely focus on larger
changes (e.g. changes in whole fish). We can change the minimum
threshold for proportional change with with the argument
`proportional_threshold`: a value of 0.1 would mean only flagging
changes of 10% or greater, and a value of 0.01 would flag change of 1%
or greater.

``` r
tamm_diff(file_1 = "Chin1124.xlsx",
          file_2 = "Chin2524.xlsx",
          results_name = "comparison of Chin 1124 vs 2524.xlsx",
          proportional_threshold = 0.01
)
```

Alternatively, we might want to use an absolute threshold (e.g., if we
were only interested in entries of fish, we might want to flag changes
of 1 or more fish). By providing a value to the optional argument
`absolute_threshold`, we override the use of `proportional_threshold`,
and the difference will flag any difference of absolute magnitude
`proprotional_threshold`. Here’s an example that flags changes of at
least 1:

``` r
tamm_diff(file_1 = "Chin1124.xlsx",
          file_2 = "Chin2524.xlsx",
          results_name = "comparison of Chin 1124 vs 2524.xlsx",
          absolute_threshold = 1
)
```

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

## Working with other Chinook sheets

- `read_2a_sheets()` parses the sheets “2A_Cmrkd”, “2A_CUnmrkd”,
  “2A_CUandM” and “2A_CUandM_N”, extracts the AEQs and ERs, and labels
  them with the appropriate stocks and fisheries. This makes it much
  easier to writes scripts that depend on these values. It returns a
  list with `$AEQ` (all the AEQ values in tabular form) and `$ER` (all
  the ER values in tabular form)
- `read_jdf()` is analogous to `read_2a_sheets()` but parses the AEQ
  information in the “JDF” sheet. For compatibility reasons it also
  returns a list with `$AEQ` and `$ER` like `read_2a_sheets()` does, but
  as there is not a bottom bar with ER values on the JDF sheet, the
  `$ER` entry is empty

## `tamm_report()`

`tamm_report()` summarizes key aspects of a single Chinook TAMM file in
an html report, which is generated in the same folder as the summarized
TAMM.

Under the hood, tamm_report() uses a template parameterized quarto
report and a child quarto file to help automate the creation of tabs for
each stock. To see the underlying quarto files used (e.g., to suggest
additional edits or features), set argument `clean = FALSE` when calling
`tamm_report()`. This will prevent the deletion of `tamm-visualizer.qmd`
and `tamm-visualizer-child.qmd`, which will be leftin the same folder as
the TAMM and report.

## `tamm_compare()`

`tamm_compare()` uses the same general approach as `tamm_report()`, but
creates a report to compare any number TAMM files based off of Yi Xu’s
Rmarkdown report to compare exploitation rates for three ocean options.
The optional argument `fisheries` takes a numeric vector of fishery IDs;
visualization of stock ERs will only plot those ERs. If `fisheries` is
not provided, for each stock `tamm_compare()` will create a figure of
impacts from all fisheries, and a separate plot of impacts from all SUS
fisheries.
