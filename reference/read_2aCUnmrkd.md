# read all info for 2aCUnmrkd and process it.

read all info for 2aCUnmrkd and process it.

## Usage

``` r
read_2aCUnmrkd(tamm_filepath, stock_cleanup = TRUE)
```

## Arguments

- tamm_filepath:

  Tamm filepath

- stock_cleanup:

  Logical, defaults to TRUE. Convert weird capitalization to lowercase?

## Value

a list, with \$aeq (the main parts of the table) and \$er (the very
bottom section)
