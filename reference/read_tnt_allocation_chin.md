# **\[experimental\]**

Extract Treaty and Nontreaty numbers from "2A_CU&M_H+N" TAMM sheet. For
Elwha and Dungeoness, separate allocations are calculated using column O
of the JDF tab

## Usage

``` r
read_tnt_allocation_chin(xlsxFile)
```

## Arguments

- xlsxFile:

  Character vector. Filename (including path) for chinook TAMM

## Value

dataframe with the treaty and nontreaty mortalities at each stock.

## Details

Currently provides dataframe with `stock.original` column identifying
the stock based on their names in the TAMM, and `stock.clean` with more
human-readable names (which are generally consistent with other stock
names, like those used to label the management criterion).
