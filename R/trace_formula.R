#' Trace the calculations of a cell recursively through all referenced cells
#'
#' @param path Filepath of an excel file
#' @param cell.start Character string of intiial cell in excel format. MUST include sheet name (e.g. "SPS!AS20", not "AS20")
#' @param max.it Maximum iterations; used as a failsafe to ensure function eventually in case of circular error. Defaults to 5000; increase if actual dependency network is likely to have more than 5000 nodes.
#' @param verbose Print cell addresses to console during tracing? Logical, defaults to `FALSE`.
#' @param split.ranges When encountering a reference that includes a cell range, trace backwards for all cells (TRUE) or just the first cell in the range (FALSE)? Logical, defaults to `FALSE`. This option was added because sometimes formulas include sums across large ranges, ballooning the size of the resulting network. For building understanding, it is sometimes sufficient to trace only a representative from each referenced range, leading to smaller and simpler plots.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' @return "trace object" -- list defining the dependency network.
#' \describe{
#'       \item{`$cells`}{tibble summarizing each of the cells in the dependency network, starting with the `cell.start`. Within this,
#'       `$id` is an index; `$label` is the cell address; `$formula` is the formula in that cell if there is a formula, otherwise it is the
#'       contents of the cell, `$contents` is the non-formula cell contents (i.e., if a formula is present, `$contents` will be the results of the formula);
#'       `$is.formula` is a logical identifying if this cell contains a formula, or is purely a numeric / string / etc contents;
#'       `$addresses.referenced` is a character vector of all excel addresses in `$formula`, and `sheet` is the sheet associated with the current cell.}
#'       \item{`$references`}{is a tibble summarizing each of the edges of the dependency network -- that is, all of the references in one cell to another. `$from` is the index of the cell that is referenced; `$to` is the index of the cell that is doing the referencing;
#'       `$from_name` and `$to_name` are the excel addresses of the same.}
#'       \item{`$raw.tracing`}{list created during tracing that forms the backbone of `trace_formula`. Intended for internal use; `$cells` and `$references` contains the important results here.}
#'}
#' @export
#'
#' @examples
#' \dontrun{
#' trace_network = trace_formula(path = "NOF material/NOF 2024/NOF 2/Chin1624.xlsx",
#'  cell.start = "SPSmrkd!AS20")
#' }
trace_formula = function(path,
                         cell.start, ## MUST include sheet name! as in "SPSmrkd!AS20"
                         max.it = 5000, ##failsafe -- using a while loop, and it will stop after this many cell checks
                         verbose = TRUE, ##print each cell when checked?
                         split.ranges = FALSE){

  cells.sample = cell.start
  ## storing results
  res = list()
  ## starting iteration counter. Using a `while` loop, so I want a failsafe
  it.counter = 1
  cells.complete = NULL

  wb_formulas_list = list()
  wb_contents_list = list()



  while(length(cells.sample)>0 & it.counter < max.it){

    cell.cur = cells.sample[1]
    if(verbose){
      cli::cli_alert("Querying cell {cell.cur}.")
    }

    ## figure out what to read
    address.parsed = address_parser(cell.cur)

    sheet.cur = address.parsed$sheet

    ## if sheet hasn't been read yet, read sheet
    if(! sheet.cur %in% names(wb_formulas_list)){
      wb_formulas_list[[sheet.cur]] = openxlsx2::read_xlsx(path,
                                                           sheet = address.parsed$sheet,
                                                           show_formula = TRUE,
                                                           col_names = FALSE)
      wb_contents_list[[sheet.cur]] = openxlsx2::read_xlsx(path,
                                                           sheet = address.parsed$sheet,
                                                           show_formula = FALSE,
                                                           col_names = FALSE)
    }

    formula = wb_formulas_list[[sheet.cur]][address.parsed$rows, address.parsed$cols]
    formula = safe_convert_numeric(formula)
    contents = wb_contents_list[[sheet.cur]][address.parsed$rows, address.parsed$cols]
    contents = safe_convert_numeric(contents)

    if(!is.na(formula)){
      new.addresses = unlist(stringr::str_extract_all(formula, "[']?[ A-Za-z0-9_-]*?[']?[!]([$]?[A-Z]{1,3}[$]?[0-9]{1,7}(:[$]?[A-Z]{1,3}[$]?[0-9]{1,7})?)|([$]?[A-Z]{1,3}[$]?[0-9]{1,7}(:[$]?[A-Z]{1,3}[$]?[0-9]{1,7})?)"))
      if(split.ranges & any(grepl(":", new.addresses))){## if "split.ranges" flag is true, generate all the cells from a range. Otherwise, using only initial cell of range.
        addresses.clean = new.addresses[!grepl(":", new.addresses)]
        addresses.range = new.addresses[grepl(":", new.addresses)]
        new.addresses = c(addresses.clean, do.call(c, purrr::map(as.list(addresses.range), range_splitter)))
      }
      new.addresses.temp = new.addresses  ## storing for later comparisons
      new.addresses[!grepl("!", new.addresses)] = paste0(address.parsed$sheet, "!", new.addresses[!grepl("!", new.addresses)])
    }else{
      new.addresses = new.addresses.temp = NULL
    }


    formula.corrected = formula
    ## update formula to include sheets in all cases; this will simplify work down the road
    if(length(new.addresses.temp) > 0){
      for(i in length(new.addresses.temp)){
        formula.corrected = gsub(new.addresses.temp[i], new.addresses[i], formula.corrected)
      }
    }
    cell.cur.clean = gsub("'", "", cell.cur)
    cell.cur.clean = gsub("[$]", "", cell.cur)
    res[[cell.cur.clean]] = list(cell = cell.cur,
                                 formula = formula.corrected,
                                 contents = contents,
                                 is.formula = (formula != contents),
                                 formula.orig = formula,
                                 addresses = new.addresses)

    cells.complete = c(cells.complete, cell.cur)

    cells.sample = setdiff(c(cells.sample, new.addresses), cells.complete)
    it.counter = it.counter + 1
    if(it.counter >= max.it){
      cli::cli_alert_danger("Iteration counter greater than `max.it` argument ({max.it}), triggering failsafe exit. If you expect a large network, increase `max.it` argument.")
    }
  }


  return(list(cells = make_tracer_nodes(res),
              references = make_tracer_edges(res),
              raw.tracing = res))
}


## function to plot the network created by trace_formula()
##
## By default, just pushes to Viewer.
## To also save the network, provide a file path + name in the optional `save_path` argument.
## The saved object will be an html - make sure to include the .html suffix in `save_path`!
##
## Example use:
## trace_network = trace_formula(path = "NOF material/NOF 2024/NOF 2/Chin1624.xlsx",
##  cell.start = "SPSmrkd!AS20")
## make_tracer_network(trace_network)


#' Visualize excel formula tracing
#'
#' Render the dependency network created in `trace_formula()`; optionally save this to an interactive .html.
#'
#' @param tracer_list Output of a `trace_formula()` call.
#' @param save_path Optional, defaults to NULL. Provide a file path + name to save an html of the visualization. Make sure file name ends in `.html`.
#' @param newline_breakpoint Optional character string used to add breakpoints to formulas to improve readability. Can be simple character or regular expression; See `formula_formater` for details and examples.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' @return interactive visNetwork object
#' @export
#'
#' @examples
#' \dontrun{
#' trace_network = trace_formula(path = "NOF material/NOF 2024/NOF 2/Chin1624.xlsx",
#' cell.start = "SPSmrkd!AS20")
#' make_tracer_network(trace_network)
#' }
make_tracer_network = function(tracer_list, ## output object of `trace_formula`
                               save_path = NULL, ## provide filepath and name to save as an html.
                               newline_breakpoint = NULL){ ## character or regular expression to use as breakpoint when adding newlines to formulas
  node_list = tracer_list$cells

  if(!is.null(newline_breakpoint)){
    df$formula = formula_formater(df$formula, newline_breakpoint)
  }

  node_list = node_list |>
    dplyr::mutate(title = glue::glue("<p>{.data$label}</p>")) |>
    dplyr::mutate(linebreak = paste(rep("-", nchar(.data$label)[1]), collapse = "")) |>
    dplyr::mutate(label = glue::glue('<b>{.data$label}</b>\n{.data$linebreak}\n{.data$formula}')) |>
    dplyr::select("id", "title", "label", "sheet") |>
    dplyr::rename("group" = "sheet") |>
    dplyr::mutate(font = dplyr::if_else(.data$id == 1, "30px arial black", "14px arial black"))

  edge_list = tracer_list$references |>
    dplyr::select("to", "from")

  vis = visNetwork::visNetwork(node_list,
                   edge_list,
                   main = glue::glue("Tracing formulas for {tracer_list$cells$label[1]}")) |>
    visNetwork::visNodes(shape = "box", mass = 4, font = list(multi = "html")) |>
    visNetwork::visEdges(arrows = 'to') |>
    visNetwork::visLegend()
  if(!is.null(save_path)){
    vis |>
      visNetwork::visSave(file = save_path)
  }
  return(vis)
}


#' Parse excel address including sheet
#'
#' Helper function to parse full excel address into sheet, row, column. Removes
#' `'` from sheet names. If given a cell range, returns only the address of the first cell.
#'
#' @param address Character string of excel address, including sheet.
#'
#' @return list, with `$sheet` giving sheet name, `$rows` givng the row number, `$cols` giving the column number.
#' @export
#'
#' @examples
#' address_parser("SPS!AS3")
#' address_parser("'Input Page'!$B$30")
#'
address_parser = function(address){ #
  address.parsed = unlist(stringr::str_split(address, pattern = "!"))
  address.dims = xldiff::cell_range_translate(gsub("[$]", "", address.parsed[2]))
  return(list(sheet = gsub("'", "", address.parsed[1]),
              rows = address.dims$row[1],
              cols = address.dims$col[1]))
}


#' Convert string of number to numeric
#'
#' Helper function to check an atomic string and convert to numeric if
#'  it contains a legal number.
#'
#' @param x character string
#'
#' @return Input formatted as character string or numeric
#' @export
#'
#' @examples
#' safe_convert_numeric("AS20-BC2")
#' safe_convert_numeric("10.5")

safe_convert_numeric <- function(x){
  if(suppressWarnings(!is.na(as.numeric(x)))){
    x = as.numeric(x)
  }
  return(x)
}

## helper function to convert addresses that are cell ranges into a character vector of each individual cell
#' Translate excel-style cell range to vector of cell addresses.
#'
#' Primarily intended as a helper function for `trace_formula()`, but could be useful for
#' other excel tasks. Drops `$` and `'` symbols from addresses to simplify parsing.
#'
#' @param address Character string of excel cell range, as in "B10:C15" or "'Input Sheet'!AS30:AS40"
#'
#' @return vector of individual excel-style cell addresses within that range
#' @export
#'
#' @examples
#' range_splitter("B10:C15")
#' range_splitter("'Input Sheet'!$AS30:$AS40")
range_splitter = function(address){
  ## remove any $ from the address
  address = gsub("[$]", "", address)
  ## make reference of column labels in sequence
  all_cols = apply(tidyr::expand_grid(c("", LETTERS), LETTERS), 1, paste0, collapse = "")
  ## split up the address range
  ## if sheet is present, split it off; otherwise, make it blank for later
  if(grepl("!", address)){
    sheet = paste0(strsplit(address, "!")[[1]][1], "!")
    cell.range = strsplit(address, "!")[[1]][2]
  }else{
    sheet = ""
    cell.range = address
  }
  cell.range = strsplit(cell.range, ":")[[1]]
  range.cols = gsub("[0-9]*", "", cell.range)
  range.nums = as.numeric(gsub("[A-Z]*", "", cell.range))
  ind.cols = min(which(all_cols %in% range.cols)):max(which(all_cols %in% range.cols))
  cols.vec = all_cols[ind.cols]
  rows.vec = range.nums[1]:range.nums[2]
  all_addresses = apply(tidyr::expand_grid(sheet = sheet, col = cols.vec, row = rows.vec), 1, paste, collapse = "")
  return(all_addresses)
}

#' Add spaces to excel formulas for readability
#'
#' Helper function to add spaces to excel formulas to improve readability. Can also
#' add newlines based on a character or regular expression
#'
#' @param x Character string containing an excel formula
#' @param newline_breakpoint Pattern to identify locations for newlines. Could be a single character (e.g. `"/"`)
#'   or a more complex regular expression (e.g., `"[)][*-+/]"` to add a newline after a combination of an end parathesis and an operator).
#'
#' @return character string
#' @export
#'
#' @examples
#' formula_formater("(SUM(A1:A4)*5/11)/(B3-B4)")
#' formula_formater("(SUM(A1:A4)*5/11)/(B3-B4)", newline_breakpoint = "/")
#' formula_formater("(SUM(A1:A4)*5/11)/(B3-B4)", newline_breakpoint = "[*-+/]")
#'
formula_formater = function(x, newline_breakpoint = NULL){
  if(!is.null(newline_breakpoint)){
    x = gsub(glue::glue("({newline_breakpoint})"), "\\1\n", x)
  }
  x = gsub("[)]([^$])", ") \\1", x)
  x = gsub("([^^A-Z])[(]", "\\1 (", x)
  x = gsub("([^A-Z])[(]([^ ])", "\\1( \\2", x)
  x = gsub("([^^A-Z])[(]", "\\1 (", x)
  x = gsub("([^ ])([+*/^-])", "\\1 \\2", x)
  x = gsub("([*/^+-])([^ ])", "\\1 \\2", x)
  x = gsub("[(]([^ ])", "( \\1", x)
  x = gsub("([^ ])[)]", "\\1 )", x)
  x = gsub("  ", " ", x)

  return(x)
}


#' List cells and contents from traced objects
#'
#' Helper function to parse list created within trace_formula into a tibble with each cell represented by a row.
#' Called in `trace_formula()` to generate the `$cells` component of the output.
#'
#' @param address_list The `$raw.tracing` component of the results of a `trace_formula()` call.
#'
#' @return tibble summarizing each cell in the tracing. See `trace_formula()` for details.
#'
make_tracer_nodes = function(address_list){
  df = tibble::tibble(id = 1:length(address_list),
              label = gsub("'", "", names(address_list)),
              formula = purrr::map_chr(address_list, \(x) as.character(x$formula)),
              contents = purrr::map_chr(address_list, \(x) as.character(x$contents)),
              is.formula = purrr::map_lgl(address_list, \(x) x$is.formula),
              addresses.referenced = purrr::map(address_list, \(x) x$addresses)
  )
  df$formula = gsub("\\\"", "`", df$formula)
  df$sheet = gsub("!.*", "", df$label)
  return(df)
}


#' Calculate and format edges from traced objects
#'
#' Helper function to find all references in list created within tracer_formula, and create a simple dataframe
#' representing all the "edges" of the traced network (that is, all the connections between cells).
#' Gets called in `trace_formula()` to generate the `$references` component of the output.
#'
#' @param address_list The `$raw.tracing` component of the results of a `trace_formula()` call.
#'
#' @return tibble.
#'    `$from` is the index of the cell that is referenced,
#'    `$to` is hte index of the cell that is doing the referencing
#'    `$from_name` and `$to_name` are the excel addresses of the same.
#'
make_tracer_edges = function(address_list){
  temp = tibble::tibble(i = 1:length(address_list),
                label = names(address_list),
                addresses = purrr::map(address_list, \(x)gsub("'", "", gsub("[$]", "", x$addresses))))

  ## make sure the address_list is a complete one.
  temp$check = NA_real_
  for(i in 1:nrow(temp)){
    if(length(temp$addresses[[i]])>0){
      temp$check[i] = mean(temp$addresses[[i]] %in% temp$label)
    }
  }
  if(any(stats::na.omit(temp$check>1))){
    cli::cli_abort("One or more addresses point to a cell not found found among the cells of `address_list`")
  }

  temp$inds = purrr::map(temp$addresses, \(x) which(gsub("'", "", temp$label) %in% x))

  temp |>
    dplyr::select("to" = "i", "from" = "inds") |>
    tidyr::unnest(.data$from) |>
    dplyr::mutate(from_name = names(address_list)[.data$from],
           to_name = names(address_list)[.data$to])
}
