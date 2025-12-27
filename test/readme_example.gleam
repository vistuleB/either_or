import gleam/string
import either_or as eo

// from eo:
//
// pub type EitherOr(a, b) {
//   Either(a)
//   Or(b)
// }

pub fn main() -> Nil {
  [
    "a",
    "a",
    "b",
    "a",
    "b",
    "a",
    "a",
    "a",
  ]
  |> eo.discriminate(string.starts_with(_, "a"))
  |> echo
  // [
  //   Either("a"),
  //   Either("a"),
  //   Or("b"),
  //   Either("a"),
  //   Or("b"),
  //   Either("a"),
  //   Either("a"),
  //   Either("a"),
  // ]
  |> eo.group_eithers
  |> echo
  // [
  //   Either(["a", "a"]),
  //   Or("b"),
  //   Either(["a"]),
  //   Or("b"),
  //   Either(["a", "a", "a"]),
  // ]
  Nil
}