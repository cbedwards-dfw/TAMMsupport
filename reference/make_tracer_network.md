# Visualize excel formula tracing

**\[experimental\]**

## Usage

``` r
make_tracer_network(tracer_list, save_path = NULL, newline_breakpoint = NULL)
```

## Arguments

- tracer_list:

  Output of a
  [`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md)
  call.

- save_path:

  Optional, defaults to NULL. Provide a file path + name to save an html
  of the visualization. Make sure file name ends in `.html`.

- newline_breakpoint:

  Optional character string used to add breakpoints to formulas to
  improve readability. Can be simple character or regular expression;
  See `formula_formater` for details and examples.

## Value

interactive visNetwork object

## Details

Render the dependency network created in
[`trace_formula()`](https://cbedwards-dfw.github.io/TAMMsupport/reference/trace_formula.md);
optionally save this to an interactive .html.

## Examples

``` r
if (FALSE) { # \dontrun{
trace_network = trace_formula(path = "NOF material/NOF 2024/NOF 2/Chin1624.xlsx",
cell.start = "SPSmrkd!AS20")
make_tracer_network(trace_network)
} # }
```
