require 'prawn/labels'

Prawn::Labels.types = {
  "Burris8UP" => {
    "paper_size" => "LETTER",
    "top_margin" => 38,
    "bottom_margin" => 0,
    "left_margin" => 16,
    "right_margin" => 16,
    "columns" => 2,
    "rows" => 4,
    "column_gutter" => 18,
    "row_gutter" => 12
  }
}
