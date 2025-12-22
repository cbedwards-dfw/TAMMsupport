# List cells and contents from traced objects

Helper function to parse list created within trace_formula into a tibble
with each cell represented by a row. Called in
[`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md)
to generate the `$cells` component of the output.

## Usage

``` r
make_tracer_nodes(address_list)
```

## Arguments

- address_list:

  The `$raw.tracing` component of the results of a
  [`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md)
  call.

## Value

tibble summarizing each cell in the tracing. See
[`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md)
for details.
