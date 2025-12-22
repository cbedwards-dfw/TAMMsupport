# Translate excel-style cell range to vector of cell addresses.

Primarily intended as a helper function for
[`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md),
but could be useful for other excel tasks. Drops `$` and `'` symbols
from addresses to simplify parsing.

## Usage

``` r
range_splitter(address)
```

## Arguments

- address:

  Character string of excel cell range, as in "B10:C15" or "'Input
  Sheet'!AS30:AS40"

## Value

vector of individual excel-style cell addresses within that range

## Examples

``` r
range_splitter("B10:C15")
#>  [1] "B10" "B11" "B12" "B13" "B14" "B15" "C10" "C11" "C12" "C13" "C14" "C15"
range_splitter("'Input Sheet'!$AS30:$AS40")
#>  [1] "'Input Sheet'!AS30" "'Input Sheet'!AS31" "'Input Sheet'!AS32"
#>  [4] "'Input Sheet'!AS33" "'Input Sheet'!AS34" "'Input Sheet'!AS35"
#>  [7] "'Input Sheet'!AS36" "'Input Sheet'!AS37" "'Input Sheet'!AS38"
#> [10] "'Input Sheet'!AS39" "'Input Sheet'!AS40"
```
