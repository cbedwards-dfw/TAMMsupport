# Compare differences in input sheets of two TAMM files

Summarizes the differences in input sheets and returns as a table.
Wrapper for
[`xldiff::excel_diff_table()`](https://cbedwards-dfw.github.io/xldiff//reference/excel_diff_table.html)

## Usage

``` r
compare_chinook_inputs(
  file_1,
  file_2,
  proportional_threshold = 0.001,
  absolute_threshold = NULL,
  digits_show = 6,
  trim_cols = TRUE,
  diff_only = TRUE
)
```

## Arguments

- file_1:

  Filename of first TAMM file

- file_2:

  Filename of second TAMM file

- proportional_threshold:

  Sets a threshold of proportional change below which differences should
  be ignored. For example, a value of 0.1 means any changes less than
  10% will not be flagged as having changed. `proportional_threshold`
  will override this value and behavior if it is provided. Numeric,
  defaults to 0.001 (0.1% change).

- absolute_threshold:

  Optional. Sets a threshold of absolute change below which differences
  should be ignored. For example, a value of 0.1 means any changes less
  than 0.1 will not be flagged as having changed. If provided, will
  override `proportional_threshold`. Numeric, defaults to NULL.

- digits_show:

  When there is a change in number values, how many digits should be
  shown in `## ---> ##`? Numeric, defaults to 6. Recommend not making
  this so small that flagged changes don't get printed (e.g., if this is
  2 and `proportional_threshold` is 0.001, 0.1% changes will get
  flagged, but only the first two digits will get shown).

- trim_cols:

  Should columns that contain no differences be cut from the results?
  Defaults to TRUE.

- diff_only:

  Should entries that do not contain differences be replaced by "" to
  help spot differences? Defaults to TRUE.

## Value

Tibble of differences in the input files; only rows with differences are
included. `row_name` variable gives the row name in the TAMM file, and
column names match excel column names.
