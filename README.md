# either_or

[![Package Version](https://img.shields.io/hexpm/v/either_or)](https://hex.pm/packages/either_or)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/either_or/)

Implements a generic choice type named `EitherOr`
with variants `Either` and `Or`.
See also [gleither](https://github.com/bwireman/gleither).

```gleam
pub type EitherOr(a, b) {
  Either(a)
  Or(b)
}
```

## Installation

```sh
gleam add either_or@3
```

## Example

Classify a list, then collect the values from each side:

```gleam
import either_or

pub fn main() {
  let values =
    [-2, 3, -1, 4]
    |> either_or.map_classify(fn(number) { number >= 0 })

  either_or.partition(values)
  // #([3, 4], [-2, -1])
}
```

`Either` contains values for which the predicate returned `True`; `Or`
contains the rest. `partition` preserves the original order of both groups.

## What it provides

- Inspect and extract values with `is_either`, `is_or`, `get_either`, and
  `get_or`.
- Transform either or both sides with `map_either`, `map_or`, `map_eo`, and
  their flat-map variants.
- Collapse both variants into one type with `resolve_eo` or `resolve_oe`.
- Classify and separate collections with `map_classify`, `partition`,
  `keep_eithers`, and `keep_ors`.
- Group consecutive values with `group_eithers` or `group_ors`.
- Convert to and from Gleam's `Result` type with `to_result` and `from_result`.

See the [API documentation](https://hexdocs.pm/either_or/) for the complete
reference.

## Development

```sh
gleam test
```

## License

Apache-2.0
