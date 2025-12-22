# Compare key sheets of Coho TAMM files

Compare key sheets of Coho TAMM files

## Usage

``` r
tamm_diff_coho(
  filename.1,
  filename.2,
  results.name,
  percent.digits = 2,
  numeric.digits = 1,
  numeric.digits.small = 4,
  dim.override = FALSE,
  wrap.text = FALSE
)
```

## Arguments

- filename.1:

  name of first TAMM file to compare. Include file path if file is not
  in working directory.

- filename.2:

  name of second TAMM file to compare. Include file path if file is not
  in working directory.

- results.name:

  name of output sheets. Include file path if save location is not in
  working directory.

- percent.digits:

  Number of decimals to round percentages to before comparing. Defaults
  to 1.

- numeric.digits:

  Number of decimals to round numbers to before comparing. Applied to
  cells which expect to be whole numbers (e.g. \#s of fish). Defaults to
  1.

- numeric.digits.small:

  Number of decimals to round numbers to before comparing. Applied to
  cells which expect to be small decimals. Defaults to 4.

- dim.override:

  Should we force comparisons even if one or more of the sheets don't
  have matching dimensions between the two files? Defaults to FALSE.

- wrap.text:

  Should specific cells with long contents (e.g., input "Fishery
  Description" cells) use text wrapping? Defaults to FALSE
