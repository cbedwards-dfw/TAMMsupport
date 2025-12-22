# Format chunks of dataframe to present as %s, round digits

Format chunks of dataframe to present as %s, round digits

## Usage

``` r
chunk_formater_percenter(df, block.ranges, percent.digits = 1)
```

## Arguments

- df:

  dataframe of sheet to apply formatting to.

- block.ranges:

  vector of characters specifying blocks of cells (in excel
  nomenclature) to format as %s

- percent.digits:

  Decimal place to round to in percent

## Value

Formatted version of `df`
