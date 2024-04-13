import gleam/io
import sprinkle.{format}
import image/filetype.{JPG, PNG, get_image_type, to_str}

type ImageType =
  filetype.ImageType

pub type Pixel =
  #(Int, Int, Int, Int)

pub type Matrix(value) =
  List(List(value))

pub type Parser =
  fn(String) -> Matrix(Pixel)

pub const parsers: List(#(ImageType, Parser)) = [
  #(PNG, parse_png),
  #(JPG, parse_jpg),
]

pub fn parse(
  filename: String,
  parsers: List(#(ImageType, Parser)),
) -> Result(Matrix(Pixel), Nil) {
  parse_private(filename, get_image_type(filename), parsers)
}

fn parse_private(
  filename: String,
  image_type: ImageType,
  parsers: List(#(ImageType, Parser)),
) -> Result(Matrix(Pixel), Nil) {
  case parsers {
    [#(img_type, parser), ..] if img_type == image_type -> {
      // TODO: remove this
      format("[DEBUG.parser] '{filename}' is a '{image_type}' image", [
        #("filename", filename),
        #("image_type", to_str(image_type)),
      ])
      |> io.debug

      Ok(parser(filename))
    }
    [_, ..rest] -> {
      parse_private(filename, image_type, rest)
    }
    [] -> {
      // TODO: remove this
      format(
        "[DEBUG.parser] '{filename}' is a '{image_type}' image, and we have no parsers left ???",
        [#("filename", filename), #("image_type", to_str(image_type))],
      )
      |> io.debug

      Error(Nil)
    }
  }
}

pub fn parse_png(_filename: String) -> Matrix(Pixel) {
  []
}

pub fn parse_jpg(_filename: String) -> Matrix(Pixel) {
  []
}
