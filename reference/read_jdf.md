# Read in AEQ and ER information from the JDF sheet

Read in AEQ and ER information from the JDF sheet

## Usage

``` r
read_jdf(tamm_filepath, stock_cleanup = TRUE)
```

## Arguments

- tamm_filepath:

  TAMM filepath

- stock_cleanup:

  Clean up stock name capitalization? Logical, defaults to TRUE.

## Value

List, with \$aeq containing the combined AEQ information that is spread
across multiple chunks in the TAMM sheet. List also contains \$er =
NULL, to provide parallel outputs to `read_2a_sheets`, which *does* have
a non-null \$er item in the output list.

## Examples

``` r
if (FALSE) { # \dontrun{
library(here)
filepath <- here("tamms/Chin2025.xlsx")
jdf = read_jdf(filepath)
} # }
```
