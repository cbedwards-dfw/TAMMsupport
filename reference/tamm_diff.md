# Compare key sheets of TAMM files

Compare key sheets of TAMM files

## Usage

``` r
tamm_diff(
  filename.1,
  filename.2,
  results.name,
  percent.digits = 1,
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

## Details

If TAMM formatting is changes (e.g. the addition of rows, etc), make
changes in the following areas:

- `read_key_tamm_sheets_SPECIES()`: The `range` argument in each
  `read_excel` call should change to match the new dimensions of each
  sheet.

- `format_key_tamm_sheets_SPECIES()`: These functions designate groups
  of cells to be Depending on the sheets that change, any amount of the
  content here may need to change. In the case of the inputs tab
  section, the cell ranges can be reported directly. Remember that we
  are separately designating cells which should be rounded to the
  nearest `numeric.digits` (generally measures of fish) and those that
  should be rounded to the nearest `numeric.digits.small` (generall
  proportions and rates; typically values that are less than 1.). Note
  that the earlier code was written before the more flexible
  `chunk_formater_percenter` and `chunk_formater_rounder` had been
  developed. If rewriting, lean into those tools, as they will
  streamline designating regions of cells for the various rounding
  criterion.

- `tamm_format_SHEETNAME()` (for the sheet formatting functions relevant
  to that species): each individual sheet has custom formatting to
  generally match the corresponding TAMM sheets. If the locations of
  cells move, the changes to font size, addition of borders, etc, will
  also need to move. Note that `tamm_format_limiting` and
  `tamm_format_overview` were written before the development of the more
  flexible `add_cell_borders`, or the combined use of
  [`purrr::map`](https://purrr.tidyverse.org/reference/map.html) and
  `cell_range_translate`. Look to `tamm_format_input` for relatively
  inputting of formatting. Consider developing other helper functions as
  needed (esp for merging).

## Examples

``` r
if (FALSE) { # \dontrun{
tamm_diff(
  filename.1 = here("FRAM/Chin1124.xlsx"),
  filename.2 = here("NOF 2/Chin2524.xlsx"),
  results.name = here("Chin 1124 vs Chin 2524.xlsx")
)
} # }
```
