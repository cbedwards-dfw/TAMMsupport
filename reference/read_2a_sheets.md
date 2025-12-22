# Read and combine all 2a sheets from a TAMM file

Gathers and cleans the AEQ and ER information for tamm sheets `2aCmrkd`,
`2aCUnmkrd`, `2aCUandM`, and `2aCUandM_N`.

## Usage

``` r
read_2a_sheets(tamm_filepath, stock_cleanup = TRUE)
```

## Arguments

- tamm_filepath:

  TAMM filepath

- stock_cleanup:

  Clean up stock name capitalization? Logical, defaults to TRUE.

## Value

list, with \$aeq containing the primary information (AEQs of fishery
impacts on each stock) and \$er containing the ER information at the
bottom of the spreadsheets.

## Examples

``` r
if (FALSE) { # \dontrun{
library(here)
filepath <- here("tamms/Chin2025.xlsx")
res = read_2a_sheets(filepath)
jdf = read_jdf(filepath)
} # }
```
