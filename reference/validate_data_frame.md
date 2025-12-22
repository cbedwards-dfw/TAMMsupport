# Confirm object is dataframe

Confirm object is dataframe

## Usage

``` r
validate_data_frame(
  x,
  ...,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
)
```

## Arguments

- x:

  Object to check

- ...:

  additional arguments

- arg:

  name of argument in calling function, identified programmatically
  using rlang

- call:

  name of calling function, identified programmatically using rlang
