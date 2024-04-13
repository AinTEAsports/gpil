import gleeunit
import gleeunit/should

import image/filetype
import parser/parser

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn get_image_type_test() {
  filetype.get_image_type("test/images/test_png.png") |> should.equal(filetype.PNG)
  filetype.get_image_type("test/images/test_jpg.jpg") |> should.equal(filetype.JPG)
}

pub fn parse_image_test() {
  parser.parse("test/images/test_png.png", parser.parsers) |> should.equal( Ok([]) )
  parser.parse("test/images/test_jpg.jpg", parser.parsers) |> should.equal( Ok([]) )
}
