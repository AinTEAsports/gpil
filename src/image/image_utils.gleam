import gleam/bit_array.{slice}
import simplifile.{read_bits}

pub fn read_first_bits(
  filename: String,
  start_at: Int,
  n: Int,
) -> Result(BitArray, Nil) {
  case read_bits(filename) {
    Ok(result) -> slice(result, start_at, start_at + n)
    _ -> Error(Nil)
  }
}
