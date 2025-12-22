# Filters a dataframe to Washington State fisheries.

Adapted from framrsquared::filter_wa(), but (a) only for Chinook (at
present), and (b) uses TAMM fishery ids, so includes ids 72 and 73.
Includes code for COHO based on FRAM ids. `filter_tamm_wa()` uses
attributes to specify chinook or coho. To directly filter for chinook or
coho, use `filter_tamm_wa_chin()` or `filter_tamm_wa_coho()`.

## Usage

``` r
filter_tamm_wa(.data)

filter_tamm_wa_chin(.data)

filter_tamm_wa_coho(.data)
```

## Arguments

- .data:

  Dataframe generated within this package

## Details

a `fishery_id` column name.

## Examples

``` r
if (FALSE) { # \dontrun{
fram_dataframe |> filter_wa()
} # }
```
