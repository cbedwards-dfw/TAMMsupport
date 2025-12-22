# Identify all cells in Excel sheet or sheets with matching cell colors

Designed for tracking the status of TAMM inputs, which are typically
color coded. Searches through specified sheet or sheets, looking for
cells whose colors match the `target_cell` argument. Returns a condensed
list of those entries.

## Usage

``` r
find_color_matches(file, target_cell, sheets = "Input Page")
```

## Arguments

- file:

  Character string of excel file name, including path if relevant

- target_cell:

  Character string of excel address of cell with the cell shading of
  interest (e.g., "B4")

- sheets:

  character string or character vector of sheets to search through

## Value

tibble summarizing entries with the color of interest, including sheet,
row and column ids, and row name (entry of first column in sheet)

## Examples

``` r
if (FALSE) { # \dontrun{
file = "chin tamms/Chin2023_Final.xlsx"
find_color_matches(file, "B20")
} # }
```
