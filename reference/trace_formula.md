# Trace the calculations of a cell recursively through all referenced cells

**\[experimental\]**

## Usage

``` r
trace_formula(
  path,
  cell.start,
  max.it = 5000,
  verbose = TRUE,
  split.ranges = FALSE
)
```

## Arguments

- path:

  Filepath of an excel file

- cell.start:

  Character string of intiial cell in excel format. MUST include sheet
  name (e.g. "SPS!AS20", not "AS20")

- max.it:

  Maximum iterations; used as a failsafe to ensure function eventually
  in case of circular error. Defaults to 5000; increase if actual
  dependency network is likely to have more than 5000 nodes.

- verbose:

  Print cell addresses to console during tracing? Logical, defaults to
  `FALSE`.

- split.ranges:

  When encountering a reference that includes a cell range, trace
  backwards for all cells (TRUE) or just the first cell in the range
  (FALSE)? Logical, defaults to `FALSE`. This option was added because
  sometimes formulas include sums across large ranges, ballooning the
  size of the resulting network. For building understanding, it is
  sometimes sufficient to trace only a representative from each
  referenced range, leading to smaller and simpler plots.

## Value

"trace object" – list defining the dependency network.

- `$cells`:

  tibble summarizing each of the cells in the dependency network,
  starting with the `cell.start`. Within this, `$id` is an index;
  `$label` is the cell address; `$formula` is the formula in that cell
  if there is a formula, otherwise it is the contents of the cell,
  `$contents` is the non-formula cell contents (i.e., if a formula is
  present, `$contents` will be the results of the formula);
  `$is.formula` is a logical identifying if this cell contains a
  formula, or is purely a numeric / string / etc contents;
  `$addresses.referenced` is a character vector of all excel addresses
  in `$formula`, and `sheet` is the sheet associated with the current
  cell.

- `$references`:

  is a tibble summarizing each of the edges of the dependency network –
  that is, all of the references in one cell to another. `$from` is the
  index of the cell that is referenced; `$to` is the index of the cell
  that is doing the referencing; `$from_name` and `$to_name` are the
  excel addresses of the same.

- `$raw.tracing`:

  list created during tracing that forms the backbone of
  `trace_formula`. Intended for internal use; `$cells` and `$references`
  contains the important results here.

## Examples

``` r
if (FALSE) { # \dontrun{
trace_network = trace_formula(path = "NOF material/NOF 2024/NOF 2/Chin1624.xlsx",
 cell.start = "SPSmrkd!AS20")
} # }
```
