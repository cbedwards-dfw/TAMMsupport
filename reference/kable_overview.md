# Print table of overview using kable and kableExtra

Uses output of format_overview()

## Usage

``` r
kable_overview(dat.overview, ind.indent, col.bold)
```

## Arguments

- dat.overview:

  formatted data, first item of format_overview() output

- ind.indent:

  Vector of indices that need indenting to match TAMM overview
  formatting. Second item of format_overview() output

- col.bold:

  vector of names for bolding to match TAMM overview formatting. Third
  item of format_overview() output.

## Value

html table
