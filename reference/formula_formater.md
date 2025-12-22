# Add spaces to excel formulas for readability

Helper function to add spaces to excel formulas to improve readability.
Can also add newlines based on a character or regular expression

## Usage

``` r
formula_formater(x, newline_breakpoint = NULL)
```

## Arguments

- x:

  Character string containing an excel formula

- newline_breakpoint:

  Pattern to identify locations for newlines. Could be a single
  character (e.g. `"/"`) or a more complex regular expression (e.g.,
  `"[)][*-+/]"` to add a newline after a combination of an end
  parathesis and an operator).

## Value

character string

## Examples

``` r
formula_formater("(SUM(A1:A4)*5/11)/(B3-B4)")
#> [1] "( SUM( A1:A4 ) * 5 / 11 ) / ( B3 - B4 )"
formula_formater("(SUM(A1:A4)*5/11)/(B3-B4)", newline_breakpoint = "/")
#> [1] "( SUM( A1:A4 ) * 5 / \n11 ) / \n ( B3 - B4 )"
formula_formater("(SUM(A1:A4)*5/11)/(B3-B4)", newline_breakpoint = "[*-+/]")
#> [1] "( SUM( A1:A4 ) * \n5 / \n11 ) / \n ( B3 - B4 )"
```
