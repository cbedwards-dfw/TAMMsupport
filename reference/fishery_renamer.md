# relabel inconsistent fishery names in FRAM/TAMM

With argument `sep = TRUE`, will return data frame with separate columns
for the area and the the "class" (Net, Troll, Sport)

## Usage

``` r
fishery_renamer(x, sep = FALSE)
```

## Arguments

- x:

  character vector of fishery names from TAMM or FRAM

- sep:

  Should we return a dataframe with separate column for class of
  fishing? Defaults to FALSE

## Value

\#vector with cleaned fishery names OR dataframe with cleaned name
(`$full`), area without fishery type (`$area`) and type of fishery
(`$class`).
