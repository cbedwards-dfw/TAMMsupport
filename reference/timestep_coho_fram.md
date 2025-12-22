# Coho timestep information stock information

Mapping of timestep numbers to dates in the year, taken from the
`TimeStep` table of the Chinook FRAM database

## Usage

``` r
timestep_coho_fram
```

## Format

A data frame with 5 rows and 5 columns:

- species:

  Species name

- version_number:

- time_step_id:

  id number for the time step

- time_step_name:

  Span of each timestep. Timesteps start on the first of the month, and
  end on the last of the month.

- time_step_title:

  `time_step_name`, but months are written out consistently

## Source

2024NOF_CohoFRAMdatabase_distribution.mdb
