import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import either_or.{Either, Or} as eo

pub fn main() {
  gleeunit.main()
}

pub fn is_left_test() {
  Either(1)
  |> eo.is_either()
  |> should.be_true()

  Or(1)
  |> eo.is_either()
  |> should.be_false()
}

pub fn get_test() {
  Either(1)
  |> eo.get_either()
  |> should.equal(Some(1))

  Or(1)
  |> eo.get_either()
  |> should.equal(None)
}

pub fn unwrap_test() {
  Either(1)
  |> eo.unwrap_either(2)
  |> should.equal(1)

  Or(1)
  |> eo.unwrap_either(2)
  |> should.equal(2)
}

pub fn map_test() {
  Either(1)
  |> eo.map_either(fn(x) { x + 1 })
  |> should.equal(Either(2))

  Or(1)
  |> eo.map_either(fn(x) { x + 1 })
  |> should.equal(Or(1))
}

pub fn flat_map_test() {
  Either(1)
  |> eo.flat_map_either(fn(x) { Either(x + 1) })
  |> should.equal(Either(2))

  Either(1)
  |> eo.flat_map_either(fn(x) { Or(x + 1) })
  |> should.equal(Or(2))

  Or(1)
  |> eo.flat_map_either(fn(x) { Either(x + 1) })
  |> should.equal(Or(1))

  Or(1)
  |> eo.flat_map_either(fn(x) { Or(x + 1) })
  |> should.equal(Or(1))
}

pub fn is_right_test() {
  Either(1)
  |> eo.is_or()
  |> should.be_false()

  Or(1)
  |> eo.is_or()
  |> should.be_true()
}

pub fn get_right_test() {
  Either(1)
  |> eo.get_or()
  |> should.equal(None)

  Or(1)
  |> eo.get_or()
  |> should.equal(Some(1))
}

pub fn get_right_with_default_test() {
  Either(1)
  |> eo.unwrap_or(2)
  |> should.equal(2)

  Or(1)
  |> eo.unwrap_or(2)
  |> should.equal(1)
}

pub fn map_right_test() {
  Either(1)
  |> eo.map_or(fn(x) { x + 1 })
  |> should.equal(Either(1))

  Or(1)
  |> eo.map_or(fn(x) { x + 1 })
  |> should.equal(Or(2))
}

pub fn flat_map_or_test() {
  Or(1)
  |> eo.flat_map_or(fn(x) { Either(x + 1) })
  |> should.equal(Either(2))

  Or(1)
  |> eo.flat_map_or(fn(x) { Or(x + 1) })
  |> should.equal(Or(2))

  Either(1)
  |> eo.flat_map_or(fn(x) { Either(x + 1) })
  |> should.equal(Either(1))

  Either(1)
  |> eo.flat_map_or(fn(x) { Or(x + 1) })
  |> should.equal(Either(1))
}

pub fn swap_test() {
  Either(1)
  |> eo.swap()
  |> should.equal(Or(1))

  Or(1)
  |> eo.swap()
  |> should.equal(Either(1))
}

pub fn map_eo_test() {
  Either(1)
  |> eo.map_eo(fn(x) { x + 1 }, fn(x) { x * 3 })
  |> should.equal(Either(2))

  Or(1)
  |> eo.map_eo(fn(x) { x + 1 }, fn(x) { x * 3 })
  |> should.equal(Or(3))
}

pub fn map_oe_test() {
  Either(1)
  |> eo.map_oe(fn(x) { x + 1 }, fn(x) { x * 3 })
  |> should.equal(Either(3))

  Or(1)
  |> eo.map_oe(fn(x) { x + 1 }, fn(x) { x * 3 })
  |> should.equal(Or(2))
}

pub fn flat_map_eo_test() {
  Either(1)
  |> eo.flat_map_eo(fn(x) { Either(x + 1) }, fn(x) { Or(x * 3) })
  |> should.equal(Either(2))

  Or(1)
  |> eo.flat_map_eo(fn(x) { Either(x + 1) }, fn(x) { Or(x * 3) })
  |> should.equal(Or(3))
}

pub fn flat_map_oe_test() {
  Either(1)
  |> eo.flat_map_oe(fn(x) { Either(x + 1) }, fn(x) { Or(x * 3) })
  |> should.equal(Or(3))

  Or(1)
  |> eo.flat_map_oe(fn(x) { Either(x + 1) }, fn(x) { Or(x * 3) })
  |> should.equal(Either(2))
}

pub fn from_result_test() {
  Ok(1)
  |> eo.from_result()
  |> should.equal(Either(1))

  Error(1)
  |> eo.from_result()
  |> should.equal(Or(1))
}

pub fn group_eithers_test() {
  eo.group_eithers([Either(1), Either(5), Or("a"), Or("b"), Either(6)])
  |> should.equal([Either([1, 5]), Or("a"), Either([]), Or("b"), Either([6])])

  eo.group_eithers([Either(1), Either(5), Or("a"), Or("b")])
  |> should.equal([Either([1, 5]), Or("a"), Either([]), Or("b"), Either([])])

  eo.group_eithers([Or("a"), Or("b")])
  |> should.equal([Either([]), Or("a"), Either([]), Or("b"), Either([])])
}

pub fn group_eithers_no_empty_lists_test() {
  eo.group_eithers_no_empty_lists([Either(1), Either(5), Or("a"), Or("b"), Either(6)])
  |> should.equal([Either([1, 5]), Or("a"), Or("b"), Either([6])])

  eo.group_eithers_no_empty_lists([Either(1), Either(5), Or("a"), Or("b")])
  |> should.equal([Either([1, 5]), Or("a"), Or("b")])

  eo.group_eithers_no_empty_lists([Or("a"), Or("b")])
  |> should.equal([Or("a"), Or("b")])
}

pub fn group_ors_test() {
  eo.group_ors([Or(1), Or(5), Either("a"), Either("b"), Or(6)])
  |> should.equal([Or([1, 5]), Either("a"), Or([]), Either("b"), Or([6])])

  eo.group_ors([Or(1), Or(5), Either("a"), Either("b")])
  |> should.equal([Or([1, 5]), Either("a"), Or([]), Either("b"), Or([])])

  eo.group_ors([Either("a"), Either("b")])
  |> should.equal([Or([]), Either("a"), Or([]), Either("b"), Or([])])
}

pub fn group_ors_no_empty_lists_test() {
  eo.group_ors_no_empty_lists([Or(1), Or(5), Either("a"), Either("b"), Or(6)])
  |> should.equal([Or([1, 5]), Either("a"), Either("b"), Or([6])])

  eo.group_ors_no_empty_lists([Or(1), Or(5), Either("a"), Either("b")])
  |> should.equal([Or([1, 5]), Either("a"), Either("b")])

  eo.group_ors_no_empty_lists([Either("a"), Either("b")])
  |> should.equal([Either("a"), Either("b")])
}

pub fn resolve_eo_test() {
  eo.resolve_eo(
    Either(1),
    fn(x) { x + 1 },
    fn(_) { 0 },
  )
  |> should.equal(2)

  eo.resolve_eo(
    Or(Nil),
    fn(x) { x + 1 },
    fn(_) { 0 },
  )
  |> should.equal(0)
}

pub fn map_resolve_test() {
  eo.map_resolve(
    [Either(1), Or(Nil)],
    fn(x) { x + 1 },
    fn(_) { 0 },
  )
  |> should.equal([2, 0])
}

pub fn from_bool_test() {
  eo.from_bool(1, False)
  |> should.equal(Or(1))

  eo.from_bool(1, True)
  |> should.equal(Either(1))
}

pub fn classify_test() {
  eo.classify(1, fn(x) { x > 0 })
  |> should.equal(Either(1))

  eo.classify(0, fn(x) { x > 0 })
  |> should.equal(Or(0))
}

pub fn map_classify_test() {
  eo.map_classify([-1, 0, 1, 0], fn(x) { x > 0 })
  |> should.equal([Or(-1), Or(0), Either(1), Or(0)])
}
