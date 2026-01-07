# Generate summary comparison of any number of TAMM files

Intended use case is to compare low, mid, and high ocean option.

## Usage

``` r
tamm_compare(
  tamm_names,
  tamm_path = getwd(),
  fisheries = NULL,
  clean = TRUE,
  overwrite = TRUE
)
```

## Arguments

- tamm_names:

  character vector of the three tamm files to compare (including .xlsx
  suffix).

- tamm_path:

  Absolute path to directory containing the tamm file. `here::here()`
  can be useful in identifying appropriate path. Character atomic;
  defaults to current working directory.

- fisheries:

  Optional, numeric vector of fishery IDs to filter to before plotting
  fishery-specific ER for each stock. Defaults to NULL (no filtering).

- clean:

  Should the intermediate .qmd files used to make the report be deleted
  afterwards? Logical, defaults to `TRUE`. Set to `FALSE` to explore the
  .qmd files underlying the report.

- overwrite:

  Should the intermediate .qmd files or the final report be overwritten
  if those files already exist?; Logical, defaults to `TRUE`.

## Value

Nothing

## Examples

``` r
if (FALSE) { # \dontrun{
tamm_path <- "C:/Users/edwc1477/Documents/WDFW FRAM team work/NOF material/NOF 2024/FRAM"
tamm_names <- c("Chin1024.xlsx", "Chin1124.xlsx", "Chin1224.xlsx")
tamm_compare3(tamm_names = tamm_names, tamm_path = tamm_path)
} # }
```
