# **\[experimental\]** Read and combine aeq sections form tables 2a-2c

**\[experimental\]** Read and combine aeq sections form tables 2a-2c

## Usage

``` r
process_2ac_aeqs(tab_2a, tab_2b, tab_2c)
```

## Arguments

- tab_2a:

  the "Table 2a" section of one of the 2ac sheets, read in with a
  `chunk_reader_2A_*()` function

- tab_2b:

  same, but 2b

- tab_2c:

  same, but 2c

## Value

dataframe of AEQ values for each stock in longform
