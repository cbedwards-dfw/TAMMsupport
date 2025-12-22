# Finishes a chunk after initial reading

Handles some of the repetitive tasks of processing individual chunks;
this part is generalized and does not need to be different for each
sheet. Lots of fiddliness in here because TAMM formatting is terrible

## Usage

``` r
chunk_read_finisher(
  sheet_name,
  table_name,
  raw,
  raw_titles,
  data_er,
  do_er = TRUE
)
```

## Arguments

- sheet_name:

  Name of sheet

- table_name:

  Name of table

- raw:

  .

- raw_titles:

  .

- data_er:

  .

- do_er:

  Should ER be done? If FALSE, skips ER (useful for processing sections
  with no ER.)

## Value

A list with \$aeq and \$er, each a dataframe
