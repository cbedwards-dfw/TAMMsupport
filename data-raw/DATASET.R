library(framrsquared)
library(tidyverse)
cli::cli_alert("Select full Chinook FRAM database to pull tables from")
path.chin = file.choose()
file.chin = gsub(".*[\\]", "", path.chin)
# path.chin = "C:\\Users\\edwc1477\\OneDrive - Washington State Executive Branch Agencies\\Documents\\WDFW FRAM team work\\NOF material\\NOF 2024\\NOF 2\\NOF2March21-1\\NOF2March21.mdb"
db = framrsquared::connect_fram_db(path.chin)
if(db$fram_db_type == "transfer"){
  cli::cli_abort("Database must be full FRAM database, not transfer.")
}
if(db$fram_db_species == "COHO"){
  cli::cli_abort("Database must be Chinook FRAM database, not Coho.")
}
stock_chinook_fram = fetch_table(db, "Stock")
comment(stock_chinook_fram) = c(description = paste0("`stock_chinook_fram` is a copy of the Stock table from a Chinook FRAM database (", file.chin, "), and can be used to map stock ID numbers to stock or vice versa. Note that TAMM and FRAM have slightly different stock ID numbers."))
fishery_chinook_fram = fetch_table(db, "Fishery")
comment(fishery_chinook_fram) = c(description = paste0("`fishery_chinook_fram` is a copy of the Fishery table from a Chinook FRAM database (", file.chin, "), and can be used to map fishery ID numbers to fisheries or vice versa. Note that TAMM and FRAM have slightly different fishery ID numbers."))
timestep_chinook_fram = fetch_table(db, "TimeStep") |>
  filter(species == "CHINOOK")
comment(timestep_chinook_fram) = c(description = paste0("`timestep_chinook_fram` is a copy of the TimeStep table from a Chinook FRAM database (", file.chin, ")."))
disconnect_fram_db(db)

cli::cli_alert("Select full Coho FRAM database to pull tables from")
path.coho = file.choose()
file.coho = gsub(".*[\\]", "", path.coho)
db = framrsquared::connect_fram_db(path.coho)
if(db$fram_db_type == "transfer"){
  cli::cli_abort("Database must be full FRAM database, not transfer.")
}
if(db$fram_db_species == "CHINOOK"){
  cli::cli_abort("Database must be Coho FRAM database, not Chinook.")
}
stock_coho_fram = fetch_table(db, "Stock") |>
  select(-stock_add)
comment(stock_coho_fram) = c(description = paste0("`stock_coho_fram` is a copy of the Stock table from a coho FRAM database (", file.coho, "), and can be used to map stock ID numbers to stock or vice versa. Note that TAMM and FRAM have slightly different stock ID numbers."))
fishery_coho_fram = fetch_table(db, "Fishery") |>
  select(-fish_add)
comment(fishery_coho_fram) = c(description = paste0("`fishery_coho_fram` is a copy of the Fishery table from a coho FRAM database (", file.coho, "), and can be used to map fishery ID numbers to fisheries or vice versa. Note that TAMM and FRAM have slightly different fishery ID numbers."))
timestep_coho_fram = fetch_table(db, "TimeStep") |>
  filter(species == "COHO")
comment(timestep_coho_fram) = c(description = paste0("`timestep_coho_fram` is a copy of the TimeStep table from a coho FRAM database (", file.coho, ")."))
disconnect_fram_db(db)

usethis::use_data(stock_chinook_fram, stock_coho_fram,
                  fishery_chinook_fram, fishery_coho_fram,
                  timestep_chinook_fram, timestep_coho_fram, overwrite = TRUE)
cli::cli_alert("Update @source in data.R documentation! Files used:")
cli::cli_alert(file.chin)
cli::cli_alert(file.coho)
