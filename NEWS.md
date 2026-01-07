# TAMMsupport 1.1.0

Updated `tamm_diff()` to use the new version of `xldiff`, which in turn now harnesses updates the newer excel interaction package `openxslx2`. The upshot is that `excel_diff()` now copies sheet formatting
(things be in percentage form, font sizes, cell borders, etc),

From the user end, all this means is that `tamm_diff()` is prettier when applied to coho. On the developer end, I don't have to custom code every important formatting choice in the TAMM (font sizes, cell borders) in order to make the output easy to read. Additionally, I'm able to remove a lot of code under the hood
that existed to do all the formatting. And if the TAMM changes (e.g., a new row gets added, etc),
`tamm_diff()` will continue to work.

Other changes:
- readme updated to represent newer functions
- function arguments relabeled to consistently use snake_case. This may break older scripts :(

# TAMMsupport 1.0.0

## major changes
- removed data objects from TAMMsupport, as they are duplicates of those in framrosetta. Added dependency on framrosetta instead.

## minor changes

- `compare_chinook_inputs()` returns a table instead of a tibble

# TAMMsupport 0.2.0

- added read_jdf() to read the important info in the `JDF` sheet, reformat into something useable in R
- added read_2ac_sheets() to read and format the important info from sheets `2A_CU&M`, `2A_CUnmrkd`, `2A_CU&M_H+N`, and `2A_CU&M_N`.

# TAMMsupport 0.1.0
- Initial package creation. Too much to list here.
