import gleam/bit_array.{byte_size}
import image/image_utils.{read_first_bits}

pub type ImageType {
  PNG
  JPG
  Other
}

pub fn to_str(image_type: ImageType) -> String {
  case image_type {
    PNG -> "PNG"
    JPG -> "JPG"
    Other -> "Other"
  }
}

pub type Signature =
  BitArray

pub type Offset =
  Int

pub const image_signatures: List(#(ImageType, Offset, Signature)) = [
  #(PNG, 0, <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>),
  #(
    JPG,
    0,
    <<0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 01>>,
  ),
  #(JPG, 0, <<0xFF, 0xD8, 0xFF, 0xEE>>),
  #(JPG, 0, <<0xFF, 0xD8, 0xFF, 0xE0>>),
]

// #(JPG, <<0xFF, 0xD8, 0xFF, 0xE1, 0x??, 0x??, 0x45, 0x78, 0x69, 0x66, 0x00, 0x00>>),

pub fn get_image_type(filename: String) -> ImageType {
  get_image_type_private(filename, image_signatures)
}

fn get_image_type_private(
  filename: String,
  signatures: List(#(ImageType, Offset, Signature)),
) -> ImageType {
  case signatures {
    [] -> Other
    [#(image_type, offset, signature), ..rest] -> {
      case read_first_bits(filename, offset, byte_size(signature)) {
        Ok(bitarray) -> {
          case bitarray == signature {
            True -> image_type
            False -> get_image_type_private(filename, rest)
          }
        }
        _ -> get_image_type_private(filename, rest)
      }
    }
  }
}
