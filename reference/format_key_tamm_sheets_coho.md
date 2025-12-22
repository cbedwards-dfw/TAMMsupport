# Modify list of Coho TAMM spreadsheet dataframes to facilitate comparison.

Modify list of Coho TAMM spreadsheet dataframes to facilitate
comparison.

## Usage

``` r
format_key_tamm_sheets_coho(
  dat,
  percent.digits = 2,
  numeric.digits = 1,
  numeric.digits.small = 4
)
```

## Arguments

- dat:

  list of dataframes corresponding to the overview, limiting stock, and
  inputs tabs. Must be named `$overview`, `$limiting`, and `$input`

- percent.digits:

  Optional, number of decimal places to round percentages to before
  comparison. Defaults to 1.

- numeric.digits:

  Optional, number of decimal places to round non-percentage numerics to
  before comparison. Applied to numbers that are expected to have
  natural units of whole numbers (e.g. numbers of fish). Defaults to 1.

- numeric.digits.small:

  Optional, number of decimal places to round non-percentage numerics to
  before comparison. Applied to numbers that are expected to be small
  (e.g. rates, proportions) Defaults to 4.

## Value

list of dataframes with same structure as `dat`, contents modified.
