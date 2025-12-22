# Read overview sheet from TAMM and return all stock

The stock column of the overview tab uses R-unfriendly approaches to
store season, overall stock name, and individual stocks in the `stock`
column of the TAMM. `read_overview_complete` splits these into separate
columns: `season`, `primary_stock`, and `stock`. For three stock (Green,
Puyallup, Skokomish), the tamm presents model predictions across two
rows with a single stock name due to merged cells. The `stock` column in
the output preserves this information; the entry corresponding to the
second row has the suffix "\_row2".

## Usage

``` r
read_overview_complete(path)
```

## Arguments

- path:

  filename (including path) to Chinook TAMM

## Value

Dataframe containing all infomration from cells A2:H34 of the
"ER_ESC_Overview_New" sheet.
