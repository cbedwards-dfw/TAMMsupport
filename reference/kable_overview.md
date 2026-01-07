# Print table of overview using kable and kableExtra

Uses output of format_overview()

## Usage

``` r
kable_overview(dat_overview, ind_ident, col_bold)
```

## Arguments

- dat_overview:

  formatted data, first item of format_overview() output

- col_bold:

  vector of names for bolding to match TAMM overview formatting. Third
  item of format_overview() output.

- ind_indent:

  Vector of indices that need indenting to match TAMM overview
  formatting. Second item of format_overview() output

## Value

html table
