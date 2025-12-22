# Calculate and format edges from traced objects

Helper function to find all references in list created within
tracer_formula, and create a simple dataframe representing all the
"edges" of the traced network (that is, all the connections between
cells). Gets called in
[`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md)
to generate the `$references` component of the output.

## Usage

``` r
make_tracer_edges(address_list)
```

## Arguments

- address_list:

  The `$raw.tracing` component of the results of a
  [`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md)
  call.

## Value

tibble. `$from` is the index of the cell that is referenced, `$to` is
hte index of the cell that is doing the referencing `$from_name` and
`$to_name` are the excel addresses of the same.
