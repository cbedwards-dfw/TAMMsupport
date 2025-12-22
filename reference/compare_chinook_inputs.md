# Compare differences in input sheets of two TAMM files

Summarizes the differences in input sheets and returns them as a tibble.

## Usage

``` r
compare_chinook_inputs(
  file1,
  file2,
  digits.signif = 4,
  trim.cols = TRUE,
  diff.only = TRUE
)
```

## Arguments

- file1:

  Filename of first TAMM file

- file2:

  Filename of second TAMM file

- digits.signif:

  How many digits should be rounded to before looking for differences?
  Without this, miniscule excel numerical differences (e.g. differing by
  0.000000001) can get picked up and overwhelm the meaningful
  differences.

- trim.cols:

  Should columns that contain no differences be cut from the results?
  Defaults to TRUE.

- diff.only:

  Should entries that do not contain differences be replaced by "" to
  help spot differences? Defaults to TRUE.

## Value

Tibble of differences in the input files; only rows with differences are
included. `row_name` variable gives the row name in the TAMM file, and
column names match excel column names.
