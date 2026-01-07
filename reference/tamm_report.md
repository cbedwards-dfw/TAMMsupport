# Generate report of figures from TAMM file

Generate report of figures from TAMM file

## Usage

``` r
tamm_report(
  tamm_name,
  tamm_path = getwd(),
  clean = TRUE,
  overwrite = TRUE,
  additional_children = NULL,
  additional_support_files = NULL
)
```

## Arguments

- tamm_name:

  Name of tamm file (including .xlsx suffix). Character atomic

- tamm_path:

  Absolute path to directory containing the tamm file. `here::here()`
  can be useful in identifying appropriate path. Character atomic;
  defaults to current working directory.

- clean:

  Should the intermediate .qmd files used to make the report be deleted
  afterwards? Logical, defaults to `TRUE`. Set to `FALSE` to explore the
  .qmd files underlying the report.

- overwrite:

  Should the intermediate .qmd files or the final report be overwritten
  if those files already exist?; Logical, defaults to `TRUE`.

- additional_children:

  Optional argument with filepath(s) to additional quarto child
  documents (see `Details`). Defaults to `NULL`.

- additional_support_files:

  Optional argument with filepath(s) to additional files needed by
  additional quarto documents. Files will be copied into the same
  directory as the TAMM for easy reading/use by `additional_children`
  quarto files, and then deleted after the report is generated

## Value

Nothing

## Details

This function generates a summary report of a single chinook TAMM
([Terminal Area Management
Module](https://framverse.github.io/fram_doc/calcs_data_chin.html#5_Terminal_Area_Management_Module))
file. The common use case is to call this function for a tamm, and then
view the resulting html report (which will be generated in the same
folder as the TAMM). However, this function also provides substantial
flexibility in the form of optional user-created child quarto documents,
which requires some additional context to develop and use.

`tamm_report` is implemented using a parameterized quarto report and a
child quarto document, which are included in the package. The resulting
report includes some broadly useful content – currently, a replication
of the overview TAMM sheet and bar charts showing the breakdown of
exploitation rates by fishery for each stock listed in the
`limiting stock complete` TAMM sheet. However, individuals or
organizations may consistently want additional, specific visualizations
based on their own needs. For example, individual tribes may want to
visualize impacts on a single stock, but use AEQ instead of ER rates.
The `tamm_report` function is designed to integrate these extra
components with the `additional_children` argument.

The basic principle is that the individual or group can write a reusable
"child" .qmd file, [see this explanation using
Rmarkdown](https://bookdown.org/yihui/rmarkdown-cookbook/child-document.html)),
which will effectively be inserted into the main report. As an example,
we might create a simple additional child .qmd file called
`extra-tamm-child.qmd` to include a small table summarizing a few key
aspects of the Nooksack Earlies stock. The contents of that file are
provided in the example below.

When we call `tamm_report()`, we can include as an argument
`additional_children = ` with the file name (including file path) for
our new file. In this way we can easily include this extra content any
time we create a tamm report. If desired, multiple child files can be
created, and `additional_children` can take a character vector with each
child file name.

When writing child documents, formatting and chunks work akin to
copy-pasting a section of a quarto file out of the main file. (To easily
access the main quarto file, run tamm_report() with `clean = FALSE`,
which will leave `tamm-visualizer.qmd` and `tamm-visualizer-child.qmd`
files in the folder with the TAMM file). The child document will have
access to key objects

- `dat.all`: the output of
  [`read_limiting_stock`](https://cbedwards-dfw.github.io/TAMMsupport/reference/read_limiting_stock.md)
  with `longform = TRUE` called on the TAMM;

- `dat_overview`: the output of of
  [`read_overview`](https://cbedwards-dfw.github.io/TAMMsupport/reference/read_overview.md)
  called on the TAMM;

- and `dat`: the specific filtered and formatted version of the limiting
  stock data generated in the `limiting stock tab` chunk of
  `tamm-visualizer.qmd` and used in generating the unmarked natural
  stock exploitation rate figures. When developing a child document, it
  may be useful to create in the working environment versions of
  `dat.all` and `dat_overview` from an example TAMM to facilitate
  writing appropriate filters, plot-making code, etc. The primary quarto
  report loads in the tidyverse, framrsquared, kableExtra, and
  TAMMsupport packages, but you can include additional packages for the
  child documents as needed by adding `library(packagename` calls just
  like in any other context.

If the `additional_children` files need to read contents of additional
files (or call children .qmd files of their own to streamline looping
over stocks or fisheries), the file paths to these supplemental files
can be provided in the `additional.support files` argument. These files
will be copied into the same folder as the .qmd files, so the children
quarto files can be written to access the supplemental files without
dealing with file paths.

For questions/support in developing child documents to extend the
report, contact Collin Edwards at WDFW.

## Examples
