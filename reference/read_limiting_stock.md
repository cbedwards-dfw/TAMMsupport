# Read TAMM limiting stock complete tab

Reads in the table, adds fishery type information.

## Usage

``` r
read_limiting_stock(file, longform = FALSE)
```

## Arguments

- file:

  Tamm name (and path)

- longform:

  Should results be in long form (good for R stuff) (`TRUE`) or
  replicate the structure of the TAMM sheet (`FALSE`). Logical, defaults
  to `FALSE`.

## Value

data frame summarizing the TAMM limiting stock tab. The "block" of the
limiting tab is identified with column "stock_type". "first_section" is
the first section in the TAMM; this section is primarily natural fish
but includes some hatchery fish if they were included in management
objectives. "ALL_H" is all hatchery fish (in TAMM, block starts on row
81), "UM_H" is unmarked hatchery (in TAMM, starts on row 160), "UM_N" is
unmarked naturals (in TAMM, starts row 239), "AD_H" is marked hatchery
(in TAMM, starts row 318), and "AD_N" is marked naturals (unless
programs begin marking natural fish, this should always be all 0s; in
TAMM starts row 397).
