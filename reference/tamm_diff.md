# Compare key sheets of TAMM files

Compare key sheets of TAMM files

## Usage

``` r
tamm_diff(
  file_1,
  file_2,
  results_name,
  proportional_threshold = 0.001,
  absolute_threshold = NULL,
  extra_width = NULL
)
```

## Arguments

- file_1:

  name of first TAMM file to compare. Include file path if file is not
  in working directory.

- file_2:

  name of second TAMM file to compare. Include file path if file is not
  in working directory.

- results_name:

  name of output sheets. Include file path if save location is not in
  working directory.

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

- extra_width:

  How much extra width should be added to columns that changed? Helpful
  to improve readability, since changed cells have longer entries.
  Numeric, defaults to 0.4.

## Examples

``` r
if (FALSE) { # \dontrun{
tamm_diff(
  file_1 = here("FRAM/Chin1124.xlsx"),
  file_2 = here("NOF 2/Chin2524.xlsx"),
  results_name = here("Chin 1124 vs Chin 2524.xlsx")
)
} # }
```
