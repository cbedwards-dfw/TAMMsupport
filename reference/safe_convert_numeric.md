# Convert string of number to numeric

Helper function to check an atomic string and convert to numeric if it
contains a legal number.

## Usage

``` r
safe_convert_numeric(x)
```

## Arguments

- x:

  character string

## Value

Input formatted as character string or numeric

## Examples

``` r
safe_convert_numeric("AS20-BC2")
#> [1] "AS20-BC2"
safe_convert_numeric("10.5")
#> [1] 10.5
```
