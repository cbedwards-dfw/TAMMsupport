# Chinook timestep information stock information

Mapping of timestep numbers to dates in the year, taken from the
`TimeStep` table of the Chinook FRAM database

## Usage

``` r
timestep_chinook_fram
```

## Format

A data frame with 4 rows and 5 columns:

- species:

  Species name

- version_number:

- time_step_id:

  id number for the time step

- time_step_name:

  Span of each timestep. Timesteps start on the first of the month, and
  end on the last of the month. Note that `Oct-Apr-2` is highlighting
  that timestep 4 runs from October of the current year to April of the
  NEXT year (equivalent to timestep 1 of the following year).

- time_step_title:

  `time_step_name`, but months are written out

## Source

2024 Pre-Season Chinook DB.mdb
