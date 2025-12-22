# Format chunks of dataframe to round digits

Format chunks of dataframe to round digits

## Usage

``` r
chunk_formater_rounder(df, block.ranges, digits = 1)
```

## Arguments

- df:

  dataframe of sheet to apply formatting to.

- block.ranges:

  vector of characters specifying blocks of cells (in excel
  nomenclature) to format as %s

- digits:

  Decimal place to round to.

## Value

Formatted version of `df`
