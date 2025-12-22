# Convenience function for formatting TAMM management criterion chunks

Internal tool to simplify converting TAMM sheet to stock management
criterion lists. See
[`read_management_chin()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/read_management_chin.md)
for example use.

## Usage

``` r
reformat_management(
  df,
  cols.percent,
  rows.percent = NULL,
  rows.header = 2,
  notes = NULL
)
```

## Arguments

- df:

  dataframe trimmed from TAMM management page to just the relevant
  stock's criterion.

- cols.percent:

  Column numbers for columns that should be converted to percents.

- rows.percent:

  Character vector of row sub-stock names identifying rows (if any) that
  should be translated to percents. Defaults to NULL. Developed to
  accomodate "CERC (SUS)" in Snohomish.

- rows.header:

  How many rows are used to make up the header? Defaults to 2, but
  sometimes header block in TAMM is 1 row.

- notes:

  Optional. Character vector, each item of which is a separate note
  associated with this stock. Generally based on comments in excel doc,
  can also feed in "extra" rows from TAMM that contain caveats.

## Value

Stock management criterion list, containing dataframe extracted from
TAMM and notes hard-coded in based on TAMM cell comments.
