# Generates clean read of TAMM limiting stock sheet

Effectively a wrapper function for read_limiting_stock with some
formatting added in. Filters to unmarked naturals, just present ER
values.

## Usage

``` r
clean_limiting_stock(filename)
```

## Arguments

- filename:

  Name (and path) for TAMM files

## Value

dataframe
