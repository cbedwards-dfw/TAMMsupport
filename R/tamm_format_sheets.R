#' Apply final formatting to diff'd TAMM sheets
#'
#' Functions that add formatting to broadly replicate the formatting of the TAMM sheets.
#' Colored foregrounds have been toned down to help change highlighting pop, and some of the complicated
#' or superfluous formatting has been skipped.
#'
#' @param wb `openxlsx` workbook object containing `$overview`, `limiting` and  `$input` sheets with the contents of diffing two TAMM files.
#' @param diff.sheet For `tamm_format_overview`, the output of `xldiff::sheet_comp` of the overview tab. Used to
#' programmatically bold the appropriate ERs based on the management objective.
#' @param tabname Name of sheet in the wb to be modified. Defaults to correct value.
#' @name tamm_format_sheets

#' @rdname tamm_format_sheets
tamm_format_overview = function(wb, diff.sheet, tabname = "overview"){
  st.header = openxlsx::createStyle(fontSize = 16, fgFill = "#b7dee8", textDecoration = "bold", halign = "center")
  st.header.sub = openxlsx::createStyle(fontSize = 11, fgFill = "#b7dee8", textDecoration = "bold", halign = "center")
  st.rowheader = openxlsx::createStyle(fontSize = 14, textDecoration = "bold")
  st.rowheader.sub = openxlsx::createStyle(fontSize = 11, textDecoration = "bold")
  st.thin.bbor = openxlsx::createStyle(border = "bottom", borderStyle = "thin")

  openxlsx::addStyle(wb, sheet = tabname, openxlsx::createStyle(valign = "center"),
           rows = 1:38, cols = 1:8, gridExpand = TRUE, stack = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, openxlsx::createStyle(halign = "center"),
           rows = 3:37, cols = 2:8,
           stack = TRUE, gridExpand = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, openxlsx::createStyle(halign = "center"),
           rows = 36:37, cols = 4:5,
           stack = TRUE, gridExpand = TRUE)

  openxlsx::addStyle(wb, sheet = tabname,  st.header,
           rows = c(1, 1, 2), cols = c(2, 5, 1) ,
           gridExpand = FALSE, stack = TRUE)
  openxlsx::addStyle(wb, sheet = tabname,  st.header.sub,
           rows = c(2), cols = c(2:8) ,
           gridExpand = TRUE, stack = TRUE)
  openxlsx::addStyle(wb, sheet = tabname,  st.rowheader,
           rows = c(3, 13), cols = c(1) ,
           gridExpand = TRUE, stack = TRUE)
  openxlsx::addStyle(wb, sheet = tabname,  st.rowheader.sub,
           rows = c(4,7,11, 12, 14, 18,21, 24, 25, 27,29:33, 36, 37), cols = c(1) ,
           gridExpand = TRUE, stack = TRUE)
  openxlsx::addStyle(wb, sheet = tabname,  st.rowheader.sub,
           rows = c(36:37), cols = c(4:8) ,
           gridExpand = TRUE, stack = TRUE)

  ## Bold appropriate ER entries based on ER type.
  df.bold = NULL
  temp = which(grepl("Total", diff.sheet[, 4]))
  if(length(temp)>0){
    df.bold = rbind(df.bold,
                    data.frame(row = temp,
                               col = rep(6, length(temp))))
  }
  temp = which(grepl("PT-SUS", diff.sheet[, 4]))
  if(length(temp)>0){
    df.bold = rbind(df.bold,
                    data.frame(
                      row = temp,
                      col = rep(8, length(temp))))
  }
  temp1 = gsub("PT-SUS", "", diff.sheet[, 4])
  temp = which(grepl("SUS", temp1))
  if(length(temp)>0){
    df.bold = rbind(df.bold,
                    data.frame(row = temp,
                               col = rep(7, length(temp))))
  }
  openxlsx::addStyle(wb, sheet = tabname, openxlsx::createStyle(textDecoration = "bold"),
           rows = df.bold$row, cols = df.bold$col,
           stack = TRUE, gridExpand = FALSE)

  ## borders
  ##    thick boxes
  xldiff::add_cell_borders(wb, sheet = tabname,
                  block.ranges = c("A2", "B1:D34", "E1:H34",
                                   "A3:H12", "A13:H32", "A33:H34",
                                   "D36:H37"),
                  border.col = "black",
                  border.thickness = "medium")
  ##    thin bottom borders
  openxlsx::addStyle(wb, sheet = tabname, st.thin.bbor,
           rows = c(6, 10, 11, 17,20, 23, 24, 26, 28:31),
           cols = 1:8,
           stack = TRUE, gridExpand = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, st.thin.bbor,
           rows = 1,
           cols = 2:8,
           stack = TRUE, gridExpand = TRUE)

  ## cell merging
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 1, cols = 2:4)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 1, cols = 5:8)

  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 25:26, cols = 1)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 27:28, cols = 1)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 33:34, cols = 1)

  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 21:23, cols = 2)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 25:26, cols = 2)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 27:28, cols = 2)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 33:34, cols = 2)

  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 36, cols = 4:5)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 37, cols = 4:5)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 36, cols = 7:8)
  openxlsx::mergeCells(wb, sheet = tabname,
             rows = 37, cols = 7:8)

  ## readable column width
  openxlsx::setColWidths(
    wb,
    sheet = tabname,
    cols = 1:8,
    widths = c(24, rep(16, 7))
  )
}

#' @rdname tamm_format_sheets
tamm_format_limiting = function(wb, tabname = "limiting"){
  st.header = openxlsx::createStyle(fontSize = 12, textDecoration = "bold", fgFill = "gray85", halign = "center")
  st.subheader = openxlsx::createStyle(fontSize = 11, textDecoration = "bold", fgFill = "gray85", halign = "center")
  st.chunkheader = openxlsx::createStyle(fontSize = 14, textDecoration = "bold", fgFill = "gray85")

  ## 108 columns total
  cols.tot = 1:108
  rows.starts = c(3, 82, 161, 240, 319, 398)## rows for the main headers of each chunk
  cols.starts = 3+(0:14)*7 ## some annoying calculations staring at the sheet. - cols for the stock starts

  ## header basics
  openxlsx::addStyle(wb, sheet = tabname, style = st.header,
           rows = rows.starts, cols = cols.tot, gridExpand = TRUE, stack = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, style = st.subheader,
           rows = rows.starts+1, cols = cols.tot,
           gridExpand = TRUE, stack = TRUE)
  ## chunk headers
  openxlsx::addStyle(wb, sheet = tabname, style = st.chunkheader,
           rows = c(1, rows.starts-1), cols = 1,
           gridExpand = TRUE, stack = TRUE)
  ##

  ## results text is all align right
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(halign = "right"),
           rows = as.numeric(sapply(rows.starts+2, function(x){x:(x+76)})),
           cols = 3:108,
           stack = TRUE, gridExpand = TRUE)

  ## add borders
  ## Thick borders
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(border = "left", borderStyle = "medium"),
           rows = as.numeric(sapply(rows.starts, function(x){x:(x+75)})), #deep magic: find all #s that run from starts to starts+75
           cols = c(1, cols.starts),
           stack = TRUE, gridExpand = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(border = "right", borderStyle = "medium"),
           rows = as.numeric(sapply(rows.starts, function(x){x:(x+75)})), #deep magic: find all #s that run from starts to starts+75
           cols = c(max(cols.tot)),
           stack = TRUE, gridExpand = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(border = "bottom", borderStyle = "medium"),
           rows = c(rows.starts-1, rows.starts, rows.starts+1, rows.starts+75),
           cols = cols.tot,
           stack = TRUE, gridExpand = TRUE)
  ## thin borders
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(border = "right", borderStyle = "thin"),
           rows = as.numeric(sapply(rows.starts, function(x){x:(x+75)})), #deep magic: find all #s that run from starts to starts+75
           cols = c(cols.starts+2),
           stack = TRUE, gridExpand = TRUE)
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(border = "bottom", borderStyle = "thin"),
           rows = c(rows.starts+14, rows.starts+34, rows.starts+72),
           cols = cols.tot,
           stack = TRUE, gridExpand = TRUE)

  ## Bold the totals
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(textDecoration = "bold"),
           rows = as.numeric(sapply(rows.starts+2, function(x){x:(x+73)})), #deep magic: find all #s that run from starts to starts+75
           cols = c(cols.starts+6),
           stack = TRUE, gridExpand = TRUE)
  ## bold the total total labels
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(textDecoration = "bold"),
           rows = c(rows.starts+74, rows.starts+75), #deep magic: find all #s that run from starts to starts+75
           cols = c(cols.starts+5),
           stack = TRUE, gridExpand = TRUE)




  for(cur.row in rows.starts){
    for(cur.col in cols.starts){
      openxlsx::mergeCells(wb, sheet = tabname,
                 rows = cur.row, cols = cur.col:(cur.col+6))
    }
  }
  openxlsx::setColWidths(
    wb,
    sheet = tabname,
    cols = cols.tot,
    widths = c(24, 6, rep(14, max(cols.tot)-2))
  )
  openxlsx::setRowHeights(wb,
                sheet = tabname,
                rows = rows.starts,
                height = 28
  )
}

#' @rdname tamm_format_sheets
tamm_format_input = function(wb, tabname = "input"){
  st.header = openxlsx::createStyle(fontSize = 20, textDecoration = "bold", fgFill = "gray85", halign = "center")
  st.subheader.stock = openxlsx::createStyle(fontSize = 18, textDecoration = "bold", fgFill = "#E5FFDA", halign = "center")
  st.subheader.net = openxlsx::createStyle(fontSize = 18, textDecoration = "bold", fgFill = "#E8FFFF", halign = "center")
  st.subheader.sport = openxlsx::createStyle(fontSize = 18, textDecoration = "bold", fgFill = "#fffddd", halign = "center")

  # Give light gray cell shading for entries in chunks:
  cells.chunk = do.call(rbind,
                        purrr::map(c("A11:O47", "A51:S72", "A75:P83", "A87:O94", "A99:H120",
                              "A123:H147", "A150:I170", "A173:H205", "J178:P191",
                              "N197:U203", "W195:Y202", "AA196:AC202", "W204:AB213",
                              "O210:Q220", "S213:T214", "S216:U221", "J210:M216",
                              "A209:H231", "A234:H242", "A248:H255", "A266:H299",
                              "K293:N294", "I280:Q282", "Q278:T278", "L278:O278",
                              "P267:R276",
                              ## more extras
                              "R82:S90", "R77", "T77", "S78:S80",  "L102:M108", "N103:O103",
                              "N110:T112", "Q108:R109", "J116:L117", "J199:J200", "L200",
                              "M247:N256", "L284:M284"


                        ),
                        .f = xldiff::cell_range_translate))
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(fgFill = "#f0f4f9"),
           rows = cells.chunk$row,
           cols = cells.chunk$col,
           stack = TRUE, gridExpand = FALSE)

  ## stock superheader
  openxlsx::addStyle(wb, sheet = tabname,
           style = openxlsx::createStyle(fontSize = 22, textDecoration = "bold", fgFill = "#E5FFDA", halign = "center"),
           rows = 9, cols = 1:15)
  ## stock headers
  openxlsx::addStyle(wb, sheet = tabname, style = st.subheader.stock,
           rows = c(10, 27, 38, 50, 74, 86),
           cols = 1:15,
           stack = TRUE, gridExpand = TRUE)

  ## net superheader
  openxlsx::addStyle(wb, sheet = tabname,
           style = openxlsx::createStyle(fontSize = 22, textDecoration = "bold", fgFill = "#E8FFFF", halign = "center"),
           rows = 96, cols = 1:8)
  ## net headers
  openxlsx::addStyle(wb, sheet = tabname, style = st.subheader.net,
           rows = c(98, 122, 149, 172, 208, 233),
           cols = 1:8,
           stack = TRUE, gridExpand = TRUE)

  ## Sport superheader
  openxlsx::addStyle(wb, sheet = tabname,
           style = openxlsx::createStyle(fontSize = 22, textDecoration = "bold", fgFill = "#fffddd", halign = "center"),
           rows = 245, cols = 1:8)
  ## sport headers
  openxlsx::addStyle(wb, sheet = tabname, style = st.subheader.sport,
           rows = c(247, 257, 265, 271, 288, 294),
           cols = 1:8,
           stack = TRUE, gridExpand = TRUE)

  ## Minor headers
  cells.minihead = do.call(rbind,
                           purrr::map(c("A11:O13", "A28:O29",
                                 "A39:O40", "A51:S52",
                                 "A75:O76", "A87:O88",
                                 "A99:H100", "A101", "A118",
                                 "A123:H125", "A137", "A150:I152",
                                 "A164", "I164", "A173:H175",
                                 "A179", "A192", "A209:H211",
                                 "A234:H235","A248:H248", "A258:H258",
                                 "A266:H266", "A272:H272", "A289:H289",
                                 "A295:H296",
                                 ## "Extras"
                                 "K282:N282", "I280:O280", "L277:T277", "P266",
                                 "M247", "J210:M211", "O210",
                                 "W204:Y207", "N196:U197", "W195", "AA196:AC187",
                                 "AA198:AA199", "J178:P179", "J116:L116",
                                 "R82:S82"
                           ),
                           .f = xldiff::cell_range_translate))
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(fontSize = 12, textDecoration = "bold"),
           rows = cells.minihead$row,
           cols = cells.minihead$col,
           stack = TRUE, gridExpand = FALSE)

  ## merging header cells:
  df.merge = rbind(tidyr::expand_grid(rows = c(9, 10, 27, 38, 50, 74, 86), endcol = 15), ## including superheaders
                   tidyr::expand_grid(rows = c(96, 98, 122, 149, 172, 208, 233), endcol = 8),
                   tidyr::expand_grid(rows = c(245, 247, 257, 265, 271, 288, 294), endcol = 8)
  )
  for(i in 1:nrow(df.merge)){
    openxlsx::mergeCells(wb, sheet = tabname,
               rows = df.merge$rows[i],
               cols = 1:df.merge$endcol[i]
    )
  }
  openxlsx::setColWidths(
    wb,
    sheet = tabname,
    cols = 1:31,
    widths = c(37, rep(16, 5), 28, 28, 16, 16, 16, 28, rep(16, 31-12)) ## a bit fiddly, but trying to give
    ## extra width to cols that have big width in original.
  )



  ## add in borders
  ## Identify all cells that are completely surrounded
  xldiff::add_cell_borders(wb = wb, sheet = tabname,
                  block.ranges = c("A14:O26", "A30:J34", "K30:O33", "A41:E47", "G41:O47", "A53:S72",
                                   "A77:O83", "P77:P80", "A89:O91", "A102:H117",
                                   "A119:H120", "A126:H147", "A153:H163", "I153:I155",
                                   "I161:I162", "A165:I169", "A170:H170",
                                   "A176:H178", "A180:H191", "A193:H204",
                                   "A213:H216", "A220:H226", "A228:H228",
                                   "A230:H231", "A236:H242", "A248:B255", "E249",
                                   "D251:D253", "E254", "F253", "G249:H255",
                                   "A259:B264","G259:H264", "A267:B270", "C267", "E267:F267",
                                   "G267:H270", "A273:B287", "E276", "D277:D281", "E281:E282",
                                   "F281", "G273:H287", "A289:B293", "D292:D293", "E291", "F292:F293",
                                   "G289:H293", "A297:H299", "R83:S90", "S78:S80", "L102:M108",
                                   "J116:L117", "K183:P184", "K186:P191", "J199:J200", "N197:U203", "W197:Y202",
                                   "O211:Q220", "J211:M216", "M248:N249", "M251:N256", "Q278:T278", "L278:O278",
                                   "I281:O281", "K293:N294"
                                   ## spot checking cells

                  ), border.thickness = "thin",
                  every.cell = TRUE)
  ## add in thick outer borders
  xldiff::add_cell_borders(wb = wb, sheet = tabname,
                  block.ranges = c(
                    #Skagit stock data
                    "A9:O9", "A10:O10", "A11:O26", "A14:O26","A14:A26",
                    #Stilly/sno stock data
                    "A27:O27", "A28:O36", "A30:O36",
                    #hood canal stock data
                    "A38:O38", "A39:O40", "O41:A47",
                    #South puget Sound stock data
                    "A50:O50", "A51:S52", "A53:S72",
                    # Nooksack /samish stock data
                    "A74:O74", "A75:P76", "A77:P83",
                    #Strait of Juan de Fuca stock data
                    "A86:O86", "A87:O88", "A89:O91",
                    #Skagit net
                    "A96:H96", "A98:H98", "A99:H100", "A102:H117", "A119:H120", "A98:H120",
                    #sTILLY/SNO NET
                    "A122:H122", "A123:H124", "A126:H126", "A138:H147", "A122:H147",
                    #hood canal net
                    "A149:H149", "A150:I151", "A153:I163", "A165:I170", "A149:I170",
                    # SPS Net
                    "A172:H172", "A173:H174", "A176:H178", "A180:H191", "A193:H205", "A172:H205",
                    #Nooksack samish net
                    "A208:H208", "A209:H210", "A212:H216", "A220:H226", "A228:H228", "A230:H231", "A208:H231",
                    #Strait of juan de fuca net
                    "A233:H233", "A234:H235", "A236:H242",  "A233:H242",
                    #Skagit sport
                    "A245:H245", "A247:H247", "A248:H248", "A247:H255",
                    #stily/snoh sport
                    "A257:H257", "A258:H258", "A257:H264",
                    #hood canal sport
                    "A265:H265", "A266:H266", "A265:H270",
                    #SPS sport
                    "A271:H271", "A272:H272", "A271:H287",
                    #nooksack/samish sport
                    "A288:H288", "A289:H289", "A288:H293",
                    #JDF sport
                    "A294:H294", "A295:H296", "A294:H299",
                    ## Extra bits!
                    "R82:S90", "R82:S82", "R77", "T77", "S78:S80",
                    "L102:M108", "N103:O103",
                    "N110:R112", "Q108:R109", "J116:L117",
                    "J178:P191", "J178:P178", "J179:P179",
                    "J199:J200", "L200", "N197:U203", "W195:Y202", "AA196:AC199", "AA196:AC196",
                    "AC201", "W204:AB204", "W207:X209", "Y207:AB209", "W210:AB213", "S213:T214",
                    "S216:U221", "O210:Q220", "J210:M216",
                    "M247:N256", "M247:N247", "P267:R270", "P271:R272", "P273:R276", "Q278:T278",
                    "L278:O278", "I280:O281", "L284", "M284", "K293:N294"
                  ),
                  border.thickness = "medium",
                  every.cell = FALSE
  )
  ## add black to some cells
  cells.blackout = do.call(rbind,
                           purrr::map(c("D102", "B159:B160", "B226", "G226:H226",
                                        "B238", "G238:H238", "B255", "G255:H255",
                                        "B262", "G262:H262"
                           ),
                           .f = xldiff::cell_range_translate))
  openxlsx::addStyle(wb, sheet = tabname, style = openxlsx::createStyle(fgFill = "black"),
                     rows = cells.blackout$row,
                     cols = cells.blackout$col,
                     stack = TRUE, gridExpand = FALSE)
}
