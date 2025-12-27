# either_or

[![Package Version](https://img.shields.io/hexpm/v/either_or)](https://hex.pm/packages/either_or)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/either_or/)

```sh
gleam add either_or@1
```

```gleam
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
```

Further documentation can be found at <https://hexdocs.pm/either_or>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
