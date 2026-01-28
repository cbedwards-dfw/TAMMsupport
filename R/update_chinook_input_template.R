
########################
#### Main Function #####
########################

## Function to do the updating.


#'  `r lifecycle::badge("experimental")`
#' Update Chinook input template with values from the final TAMM of the previous year
#'
#'  Takes (a) file path for the final run from the previous year (to take values FROM),
#' (b) the file path for the old template (to take formatting and non-changing cells FROM),
#' and (c) the filepath for the new template
#'
#' Optionally, `debug_mode` can be set to TRUE. This will (a) print out the sheet and "to" addresses of each
#' transfer as they happen, and (b) highlight each cell in the template whose values are copied from `last_year_final_run`
#' in blood red, making it easy to check that the correct sections are being updated.
#'
#' @param last_years_final_run filepath to last year's final run
#' @param old_template filepath to old template file
#' @param new_template_name filepath to save new template file
#' @param debug_mode Should updated cells be highlighted, and update regions be printed to console? Logical, defaults to FALSE.
#'
#' @return nothing
#' @export
#'
#' @examples
#' \dontrun{
#' chinook_input_template_updater(last_years_final_run = here("Chin2225_final.xlsx"),
#'        old_template = here("Chinook_TAMM_Fishery_Input_Template_20241.xlsx"),
#'        new_template_name = here("Chinook_TAMM_Fishery_Input_Template_2025- CHECK.xlsx"),
#'                                debug_mode = TRUE)
#' chinook_input_template_updater(last_years_final_run = here("Chin2225_final.xlsx"),
#'        old_template = here("Chinook_TAMM_Fishery_Input_Template_20241.xlsx"),
#'        new_template_name = here("Chinook_TAMM_Fishery_Input_Template_2025.xlsx"))
#'
#' }

chinook_input_template_updater <- function(last_years_final_run,
                                           old_template,
                                           new_template_name,
                                           debug_mode = FALSE
){

  if(!rlang::is_installed("excelsior")){
    cli::cli_abort("This function requires the excelsior package. Install with `pak::pak(\"cbedwards-dfw/excelsior\")`.")
  }


  ## Validation for inputs: are the filepaths single strings that end in .xlsx?
  validate_character(last_years_final_run, n = 1)
  if (!stringr::str_ends(last_years_final_run, ".xlsx")) {
    cli::cli_abort("Argument `last_years_final_run` must be a single character string ending in '.xlsx'")
  }

  validate_character(old_template, n = 1)
  if (!stringr::str_ends(old_template, ".xlsx")) {
    cli::cli_abort("Argument `old_template` must be a single character string ending in '.xlsx'")
  }

  validate_character(new_template_name, n = 1)
  if (!stringr::str_ends(new_template_name, ".xlsx")) {
    cli::cli_abort("Argument `new_template_name` must be a single character string ending in '.xlsx'")
  }
  validate_flag(debug_mode)



  input_sheet = readxl::read_excel(last_years_final_run,
                           sheet = "Input Page",
                           col_names = FALSE,
                           .name_repair = "unique_quiet")




  out <- openxlsx2::wb_load(old_template)

  ## Skagit - TR -----------------------------------
  cur_sheet = "Skagit - TR"
  out <- out |>
    ## big block stuff
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B102:B116",
                 to_address = "B5:B19",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D101",
                 to_address = "D4",
                 sheet = cur_sheet,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D109:D110",
                 to_address = "D12:D13",
                 sheet = cur_sheet,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E102:F108",
                 to_address = "E5:F11",
                 sheet = cur_sheet,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G102:H116",
                 to_address = "G5:H19",
                 sheet = cur_sheet,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## river test fishery hrs
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "J117:L117",
                 to_address = "A23:C23",
                 sheet = cur_sheet,
                 check_row_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G117:H117",
                 to_address = "D23:E23",
                 sheet = cur_sheet,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## cascade fisheries
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "M103:M105",
                 to_address = "B26:B28",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "R108:R109",
                 to_address = "B29:B30",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "S108:S109",
                 to_address = "C29:C30",
                 sheet = cur_sheet,
                 numeric_flag = FALSE,
                 check_col_offset = 2,
                 debug_mode = debug_mode
    ) |>
    ## chin bycatch for cascades
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "O103",
                 to_address = "D27",
                 sheet = cur_sheet,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "P103:P105",
                 to_address = "E26:E28",
                 sheet = cur_sheet,
                 check_col_offset = 4,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )

  ## STL-Sno - TR -----------------------------------
  cur_sheet = "STL-Sno - TR"

  out <- out |>
    ## big block stuff
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B126:B140",
                 to_address = "B5:B19",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D126:F130",
                 to_address = "D5:F9",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G126:H140",
                 to_address = "G5:H19",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode

    )

  ## Skagit - NT Rec-----------------
  cur_sheet = "Skagit - NT Rec"

  out <- out |>
    ## big block stuff
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B249:B254",
                 to_address = "B3:B8",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D251:D253",
                 to_address = "D5:D7",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E249",
                 to_address = "E3",
                 sheet = cur_sheet,
                 check_col_offset = 2,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E254",
                 to_address = "E8",
                 sheet = cur_sheet,
                 check_col_offset = 2,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "F253",
                 to_address = "F7",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G249:H254",
                 to_address = "G3:H8",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )


  ## Skagit - NT Rec-----------------
  cur_sheet = "STL-Sno -NT Rec"
  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B260:B264",
                 to_address = "B4:B8",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D263:D264",
                 to_address = "D7:D8",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G260:H264",
                 to_address = "G4:H8",
                 sheet = cur_sheet,
                 check_col_offset = 4,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "J260",
                 to_address = "J4",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )


  ## Hood Canal - TR-----------------
  cur_sheet = "Hood Canal - TR"

  cli::cli_alert("`NOA Treaty Troll` row of sheet 'Hood Canal - TR' does not have a corresponding row in the inputs sheet")
  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B153:B163",
                 to_address = "B5:B15",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D153:F155",
                 to_address = "D5:F7",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D161:F162",
                 to_address = "D13:F14",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G153:H163",
                 to_address = "G5:H15",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "I153:I163",
                 to_address = "I5:I15",
                 sheet = cur_sheet,
                 check_col_offset = 8,
                 debug_mode = debug_mode
    )

  ## Hood Canal - NT Rec-----------------
  cur_sheet = "Hood Canal - NT Rec"

  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B267:B270",
                 to_address = "B3:B6",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "C267",
                 to_address = "C3",
                 sheet = cur_sheet,
                 check_col_offset = 2,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E267:F267",
                 to_address = "E3:F3",
                 sheet = cur_sheet,
                 check_row_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G267:H270",
                 to_address = "G3:H6",
                 sheet = cur_sheet,
                 check_col_offset = 7,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )

  ## Mid-South Sound - TR-----------------
  cur_sheet = "Mid-South Sound - TR"

  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B176:B178",
                 to_address = "B5:B7",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    ## treaty and nontreaty block
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D180:F191",
                 to_address = "D9:F20",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G180:H191",
                 to_address = "G9:H20",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## Treaty freshwater block
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B193:B204",
                 to_address = "B22:B33",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D201",
                 to_address = "D30",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E199:E201",
                 to_address = "E28:E30",
                 sheet = cur_sheet,
                 check_col_offset = 4,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G193:H204",
                 to_address = "G22:H33",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## Additional nisqualy inputs
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "AB198:AC201",
                 to_address = "B39:C42",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 check_row_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "AD198:AD201",
                 to_address = "D39:D42",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## nisq hatch-selective fishery
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "X208:X209",
                 to_address = "B48:B49",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "AC208",
                 to_address = "G48",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )


  ## Mid-South Sound - NT Rec-----------------
  cur_sheet = "Mid-South Sound - NT Rec"

  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B273:B275",
                 to_address = "B3:B5",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B281:B287",
                 to_address = "B11:B17",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E276",
                 to_address = "E6",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D277:D280",
                 to_address = "D7:D10",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D281",
                 to_address = "D11",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E281:F282",
                 to_address = "E11:F12",
                 sheet = cur_sheet,
                 check_row_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G273:H287",
                 to_address = "G3:H17",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## fiddly bit on right
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "L278:O278",
                 to_address = "L8:O8",
                 sheet = cur_sheet,
                 check_row_offset = 1,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )


  ## Nooksack-Samish - TR -----------------
  cur_sheet = "Nooksack-Samish - TR"

  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B213",
                 to_address = "B6",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G213:H214",
                 to_address = "G6:H7",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B220:B225",
                 to_address = "B13:B18",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G220:H225",
                 to_address = "G13:H18",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B230",
                 to_address = "B23",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G230:H230",
                 to_address = "G23:H23",
                 sheet = cur_sheet,
                 check_row_offset = 18,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    ## MSF tangle net chunk
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "J213:K213",
                 to_address = "A29:B29",
                 sheet = cur_sheet,
                 check_row_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "J215:K215",
                 to_address = "A31:B31",
                 sheet = cur_sheet,
                 check_row_offset = 1,
                 debug_mode = debug_mode
    )

  ## Marine Rec NT -----------------
  cur_sheet = "Marine Rec NT"

  out <- out |>
    ## Stilly/Snoh section
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B142",
                 to_address = "B10",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G142:H142",
                 to_address = "G10:H10",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B142",
                 to_address = "B10",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    ## mid/south
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D183:F183",
                 to_address = "D5:F5",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G183:H183",
                 to_address = "G5:H5",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>

    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D186:F186",
                 to_address = "D6:F6",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G186:H186",
                 to_address = "G6:H6",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )

  ## Nooksack-Samish NT -----------------
  cur_sheet = "Nooksack-Samish NT"

  out <- out |>
    ## Stilly/Snoh section
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B290:B293",
                 to_address = "B3:B6",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D292:D293",
                 to_address = "D5:D6",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E291",
                 to_address = "E4",
                 sheet = cur_sheet,
                 check_col_offset = 4,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "F292:F293",
                 to_address = "F5:F6",
                 sheet = cur_sheet,
                 check_col_offset = 5,
                 debug_mode = debug_mode
    )  |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G290:H293",
                 to_address = "G3:H6",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 check_row_offset = 1,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )

  ## JDF - TR -----------------
  cur_sheet = "JDF - TR"

  cli::cli_alert("Sheet {cur_sheet} has a section copied from the FRAM database. This function
               does not handle that.")

  out <- out |>
    ## Stilly/Snoh section
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B236:B242",
                 to_address = "B5:B11",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    ## I think the color here was a mistake, but just going to update anyways
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "C236",
                 to_address = "C5",
                 sheet = cur_sheet,
                 check_col_offset = 2,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G236:H242",
                 to_address = "G5:H11",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 check_row_offset = 1,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode
    )
  ## FRAM based input section

  ## JDF - NT Rec -----------------
  cur_sheet = "JDF - NT Rec"

  cli::cli_alert("Sheet {cur_sheet} has a section copied from the FRAM database. This function
               does not handle that.")


  out <- out |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B297:B299",
                 to_address = "B4:B6",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode
    ) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G297:H299",
                 to_address = "G4:H6",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode)

  ## Commercial NT -----------------
  cur_sheet = "Commercial NT"
  out <- out |>
    ## Skagit net
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B119:B120",
                 to_address = "B5:B6",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "E119:F120",
                 to_address = "E5:F6",
                 sheet = cur_sheet,
                 check_col_offset = 4,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G119:H120",
                 to_address = "G5:H6",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode)|>
    ## stilly/snoh
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B141:B147",
                 to_address = "B10:B16",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode)|>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D145:F147",
                 to_address = "D14:F16",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode)|>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G141:H147",
                 to_address = "G10:H16",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    ## HC net
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B165:B170",
                 to_address = "B21:B26",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D165:F169",
                 to_address = "D21:F25",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G165:H170",
                 to_address = "G21:H26",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "I165:I169",
                 to_address = "I21:I25",
                 sheet = cur_sheet,
                 check_col_offset = 8,
                 check_row_offset = 1,
                 debug_mode = debug_mode) |>
    ## South PS Net
    # area 10/11 ntry
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D180:F180",
                 to_address = "D31:F31",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G180:H180",
                 to_address = "G31:H31",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    # deep sps ntry
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D188:F188",
                 to_address = "D32:F32",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G188:H188",
                 to_address = "G32:H32",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    # area 13a
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "D190:F190",
                 to_address = "D33:F33",
                 sheet = cur_sheet,
                 check_col_offset = 3,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G190:H190",
                 to_address = "G33:H33",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    ## Nooksack/Samish Net
    #jul-sep ntry
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B221",
                 to_address = "B39",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode)  |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G221:H221",
                 to_address = "G39:H39",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    # oct-aptr Ntrty
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B223",
                 to_address = "B40",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G223:H223",
                 to_address = "G40:H40",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    # area 7a extreme terminal impacts
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B231",
                 to_address = "B42",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G231:H231",
                 to_address = "G42:H42",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode) |>
    # JDF Net
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "B237",
                 to_address = "B46",
                 sheet = cur_sheet,
                 check_col_offset = 1,
                 debug_mode = debug_mode) |>
    excelsior::copy_section(from_df = input_sheet,
                 from_address = "G237:H237",
                 to_address = "G46:H46",
                 sheet = cur_sheet,
                 check_col_offset = 6,
                 numeric_flag = FALSE,
                 debug_mode = debug_mode)


  cli::cli_alert("Sheet 'Coastal (TR and NT)' has a section copied from the FRAM database. This function does not handle that.")

  openxlsx2::wb_save(out, file = new_template_name)
}




