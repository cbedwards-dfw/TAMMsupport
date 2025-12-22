# Parse excel address including sheet

Helper function to parse full excel address into sheet, row, column.
Removes `'` from sheet names. If given a cell range, returns only the
address of the first cell.

## Usage

``` r
address_parser(address)
```

## Arguments

- address:

  Character string of excel address, including sheet.

## Value

list, with `$sheet` giving sheet name, `$rows` givng the row number,
`$cols` giving the column number.

## Examples

``` r
address_parser("SPS!AS3")
#> $sheet
#> [1] "SPS"
#> 
#> $rows
#> [1] 3
#> 
#> $cols
#> [1] 45
#> 
address_parser("'Input Page'!$B$30")
#> $sheet
#> [1] "Input Page"
#> 
#> $rows
#> [1] 30
#> 
#> $cols
#> [1] 2
#> 
```
