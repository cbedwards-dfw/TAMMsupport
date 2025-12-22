# Safely convert character numerics into numeric

Function to translate columns that "should" be numeric into numeric but
doesn't do so if that would mean converting a true character string to
NA.

## Usage

``` r
as_numeric_safe(x)
```

## Arguments

- x:

  Character vector

## Value

Either numeric vector of x or (if that is lossy) character returns
input.
