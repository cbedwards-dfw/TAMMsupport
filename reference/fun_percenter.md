# Format vector of mixed characters to present numbers as percents

Intended for internal use within formatting functions. Note that
percents in excel are read in as proportions in R – this makes them
percents to make saved files more readable.

## Usage

``` r
fun_percenter(x, percent_digits)
```

## Arguments

- x:

  Character vector, presumably containing some entries that are numbers
  in character form

- percent_digits:

  Number of digits to round to after converting to percents

## Value

character vector with individual entries converted to percentages and
rounded as appropriate.
