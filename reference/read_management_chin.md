# Extract and format management criterion from Chinook TAMM

Extract and format management criterion from Chinook TAMM

## Usage

``` r
read_management_chin(file)
```

## Arguments

- file:

  filename, including filepath if appropriate

## Value

Tibble, with `$management_name` giving the name of the management
criteria as specified in the TAMM, `$management_criteria` giving a list
of dataframes with the associated management criteria, formatted
appropriately, and `$notes` giving a list of character vectors with
notes (if any) to help interpret the criteria.

## Examples

``` r
if (FALSE) { # \dontrun{
cur.management = read_management_chin("Code Inputs/Pre-Season/TAMMs/2013_Final W_BP7.1.xlsx")
} # }
```
