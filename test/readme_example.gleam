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
    "Alan",
    "Ackerman",
    "Bob",
    "Alfonse",
    "Bibimbap",
    "Al-Ansar",
    "Al-Akbar",
    "Al-Kashimoodo",
  ]
  |> eo.discriminate(string.starts_with(_, "A"))
  |> echo
  // [
  //   Either("Alan"),
  //   Either("Ackerman"),
  //   Or("Bob"),
  //   Either("Alfonse"),
  //   Or("Bibimbap"),
  //   Either("Al-Ansar"),
  //   Either("Al-Akbar"),
  //   Either("Al-Kashimoodo"),
  // ]
  |> eo.group_eithers
  |> echo
  // [
  //   Either(["Alan", "Ackerman"]),
  //   Or("Bob"),
  //   Either(["Alfonse"]),
  //   Or("Bibimbap"),
  //   Either(["Al-Ansar", "Al-Akbar", "Al-Kashimoodo"]),
  // ]

  Nil
}