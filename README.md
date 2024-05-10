
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TAMMsupport

<!-- badges: start -->
<!-- badges: end -->

The goal of TAMMsupport is to provide R-based tools for working with and
interpreting Terminal Area Management Module files
(<https://framverse.github.io/fram_doc/calcs_glossary.html#Terminal_Area_Management_Module_(TAMM)>).

## Installation

You can install the development version of TAMMsupport like so:

``` r
devtools::install_github("cbedwards-dfw/TAMMsupport)    
```

or

``` r
pak::pkg_install("cbedwards-dfw/TAMMsupport")
```

## Quick guide

At present, the only function is `tamm_report()`. When provided a tamm
file name and the path to the directory (defaults to using the current
working directory), this generates an html report summarizing key
aspects of the TAMM. The report is given the same name as the TAMM with
the suffix “-Visualization”.

Under the hood, tamm_report() uses a template parameterized quarto
report and a child quarto file to help automate the creation of tabs for
each stock. To see the underlying quarto files used (e.g., to suggest
additional edits or features), set argument `clean = FALSE` when calling
`tamm_report()`. This will prevent the deletion of `tamm-visualizer.qmd`
and `tamm-visualizer-child.qmd`, which will be present in the same
folder as the TAMM and report.

## Devnotes to self

Still in the process of transfering experimental functions from NOF 2024
project. Files to look at:

- tamm-compare-functionalized.R
- excel-compare-sandbox.R
