import gleam/list
import gleam/option.{type Option, Some, None}

/// A generic choice type.
/// 
pub type EitherOr(a, b) {
  Either(a)
  Or(b)
}

/// Given an EitherOr value returns True if and
/// only if the value is an Either variant.
///
pub fn is_either(v: EitherOr(a, b)) -> Bool {
  case v {
    Either(_) -> True
    _ -> False
  }
}

/// Given an EitherOr value returns True if and
/// only if the value is an Or variant.
///
pub fn is_or(v: EitherOr(a, b)) -> Bool {
  case v {
    Or(_) -> True
    _ -> False
  }
}

/// Converts an EitherOr(a, b) value into Some(x) if
/// the value has the form Either(x), else None.
///
pub fn get_either(v: EitherOr(a, b)) -> Option(a) {
  case v {
    Either(x) -> Some(x)
    _ -> None
  }
}

/// Converts an EitherOr(a, b) value into Some(x) if
/// the value has the form Or(x), else None.
///
pub fn get_or(v: EitherOr(a, b)) -> Option(b) {
  case v {
    Or(x) -> Some(x)
    _ -> None
  }
}

/// Given an EitherOr value returns x if the value has
/// the form Either(x) otherwise returns the supplied default.
///
pub fn unwrap_either(v: EitherOr(a, b), default: a) -> a {
  case v {
    Either(x) -> x
    _ -> default
  }
}

/// Given an EitherOr value returns x if the value has
/// the form Or(x) otherwise returns the supplied default.
///
pub fn unwrap_or(v: EitherOr(a, b), default: b) -> b {
  case v {
    Or(x) -> x
    _ -> default
  }
}

/// Given a value of type EitherOr(a, b) and a
/// function f(a) -> c returns Either(f(a)) if the
/// value has the form Either(a) and returns Or(b)
/// if the value has the form Or(b).
///
pub fn map_either(
  v: EitherOr(a, b),
  f: fn(a) -> c,
) -> EitherOr(c, b) {
  case v {
    Either(a) -> Either(f(a))
    Or(b) -> Or(b)
  }
}

/// Given a value of type EitherOr(a, b) and a
/// function f(b) -> c returns Or(f(b)) if the
/// value has the form Or(b) and returns Either(a)
/// if the value has the form Either(a).
///
pub fn map_or(
  v: EitherOr(a, b),
  with f: fn(b) -> c,
) -> EitherOr(a, c) {
  case v {
    Either(a) -> Either(a)
    Or(b) -> Or(f(b))
  }
}

/// Apply separate maps to each payload of an EitherOr
/// value.
///
/// Symmetric to map_eo.
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either 'Either'
/// or 'Or' variants via the `use <-` syntax.
///
pub fn map_eo(
  v: EitherOr(a, b),
  on_either: fn(a) -> a_prime,
  on_or: fn(b) -> b_prime,
) -> EitherOr(a_prime, b_prime) {
  case v {
    Either(a) -> Either(on_either(a))
    Or(b) -> Or(on_or(b))
  }
}

/// Apply separate maps to each payload of an EitherOr
/// value.
///
/// Symmetric to map_oe.
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either 'Either'
/// or 'Or' variants via the `use <-` syntax.
///
pub fn map_oe(
  v: EitherOr(a, b),
  on_or: fn(b) -> b_prime,
  on_either: fn(a) -> a_prime,
) -> EitherOr(a_prime, b_prime) {
  case v {
    Either(a) -> Either(on_either(a))
    Or(b) -> Or(on_or(b))
  }
}

/// Given a value of type EitherOr(a, b) and functions
/// f1(a) -> c, f2(b) -> c, returns f1(a) if the
/// value has the form Either(a) and returns f2(b)
/// if the value has the form Or(b).
///
/// Symmetric to resolve_oe.
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either 'Either'
/// or 'Or' variants via the `use <-` syntax.
///
pub fn resolve_eo(
  t: EitherOr(a, b),
  on_either f1: fn(a) -> c,
  on_or f2: fn(b) -> c,
) -> c {
  case t {
    Either(a) -> f1(a)
    Or(b) -> f2(b)
  }
}

/// Given a value of type EitherOr(a, b) and functions
/// f1(b) -> c, f1(a) -> c, returns f1(a) if the
/// value has the form Either(a) and returns f2(b)
/// if the value has the form Or(b).
///
/// Symmetric to resolve_eo.
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either 'Either'
/// or 'Or' variants via the `use <-` syntax.
/// 
pub fn resolve_oe(
  t: EitherOr(a, b),
  on_or f1: fn(b) -> c,
  on_either f2: fn(a) -> c,
) -> c {
  case t {
    Or(b) -> f1(b)
    Either(a) -> f2(a)
  }
}

/// Flatten a `EitherOr(EitherOr(a, b), b)` value.
/// 
pub fn flatten_either(
  either: EitherOr(EitherOr(a, b), b),
) -> EitherOr(a, b) {
  case either {
    Either(inner) -> inner
    Or(x) -> Or(x)
  }
}

/// Flatten a `EitherOr(a, EitherOr(a, b))` value.
/// 
pub fn flatten_or(
  either: EitherOr(a, EitherOr(a, b)),
) -> EitherOr(a, b) {
  case either {
    Either(x) -> Either(x)
    Or(inner) -> inner
  }
}

/// Flatten a `EitherOr(EitherOr(a, b), EitherOr(a, b))` value.
/// 
pub fn flatten(
  either: EitherOr(EitherOr(a, b), EitherOr(a, b)),
) -> EitherOr(a, b) {
  case either {
    Either(a) -> a
    Or(x) -> x
  }
}
/// Compose map_either and flatten.
///
pub fn flat_map_either(
  v: EitherOr(a, b),
  f: fn(a) -> EitherOr(c, b),
) -> EitherOr(c, b) {
  v |> map_either(f) |> flatten_either
}

/// Compose map_or and flatten.
///
pub fn flat_map_or(
  v: EitherOr(a, b),
  with f: fn(b) -> EitherOr(a, c),
) -> EitherOr(a, c) {
  v |> map_or(f) |> flatten_or
}

/// Apply a map of codomain EitherOr(c, d) to either
/// side of an EitherOr(a, b) and flatten
///
/// Symmetric to flat_map_eo.
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either 'Either'
/// or 'Or' variants via the `use <-` syntax.
/// 
pub fn flat_map_eo(
  v: EitherOr(a, b),
  f1: fn(a) -> EitherOr(c, d),
  f2: fn(b) -> EitherOr(c, d),
) -> EitherOr(c, d) {
  v
  |> map_either(f1)
  |> map_or(f2)
  |> flatten
}

/// Aplly a map of codomain EitherOr(c, d) to either
/// side of an EitherOr(a, b) and flatten
///
/// Symmetric to flat_map_eo.
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either 'Either'
/// or 'Or' variants via the `use <-` syntax.
/// 
pub fn flat_map_oe(
  v: EitherOr(a, b),
  f2: fn(b) -> EitherOr(c, d),
  f1: fn(a) -> EitherOr(c, d),
) -> EitherOr(c, d) {
  v
  |> map_either(f1)
  |> map_or(f2)
  |> flatten
}

/// Given a value of type EitherOr(a, b) returns a
/// value of type EitherOr(b, a) by swapping the
/// Either constructor for the Or constructor and
/// vice-versa.
/// 
pub fn swap(
  v: EitherOr(a, b),
) -> EitherOr(b, a) {
  case v {
    Either(a) -> Or(a)
    Or(b) -> Either(b)
  }
}

/// Given a List(EitherOr(a, b)) and a function
/// f: fn(a) -> c returns a List(EitherOr(c, b)) by
/// applying map_either(_, f) to each element of the
/// list.
/// 
pub fn map_eithers(
  v: List(EitherOr(a, b)),
  f: fn(a) -> c,
) -> List(EitherOr(c, b)) {
  list.map(v, map_either(_, f))
}

/// Given a List(EitherOr(a, b)) and a function
/// f: fn(b) -> c returns a List(EitherOr(a, c)) by
/// applying map_or(_, f) to each element of the
/// list.
/// 
pub fn map_ors(
  v: List(EitherOr(a, b)),
  f: fn(b) -> c,
) -> List(EitherOr(a, c)) {
  list.map(v, map_or(_, f))
}

/// Given a List(EitherOr(a, b)) and functions
/// f: fn(a) -> c, g: fn(b) -> c, returns a List(c)
/// by mapping each element of the form Either(a) to
/// f(a) and each element of the form Or(b) to g(b).
/// 
pub fn map_resolve(
  v: List(EitherOr(a, b)),
  on_either f: fn(a) -> c,
  on_or g: fn(b) -> c,
) -> List(c) {
  list.map(v, resolve_eo(_, f, g))
}

fn group_eithers_accumulator(
  already_packaged: List(EitherOr(List(a), b)),
  under_construction: List(a),
  upcoming: List(EitherOr(a, b)),
) -> List(EitherOr(List(a), b)) {
  case upcoming {
    [] ->
      [under_construction |> list.reverse |> Either, ..already_packaged]
      |> list.reverse

    [Either(a), ..rest] ->
      group_eithers_accumulator(
        already_packaged,
        [a, ..under_construction],
        rest,
      )

    [Or(b), ..rest] ->
      group_eithers_accumulator(
        [
          Or(b),
          under_construction |> list.reverse |> Either,
          ..already_packaged
        ],
        [],
        rest,
      )
  }
}

fn group_ors_accumulator(
  already_packaged: List(EitherOr(a, List(b))),
  under_construction: List(b),
  upcoming: List(EitherOr(a, b)),
) -> List(EitherOr(a, List(b))) {
  case upcoming {
    [] ->
      [under_construction |> list.reverse |> Or, ..already_packaged]
      |> list.reverse

    [Or(b), ..rest] ->
      group_ors_accumulator(already_packaged, [b, ..under_construction], rest)

    [Either(a), ..rest] ->
      group_ors_accumulator(
        [
          Either(a),
          under_construction |> list.reverse |> Or,
          ..already_packaged
        ],
        [],
        rest,
      )
  }
}

/// Given a List(EitherOr(a, b)), removes all elements
/// of the form Or(b) and unwraps the remaining elements
/// of the form Either(a).
/// 
pub fn remove_ors_unwrap_eithers(ze_list: List(EitherOr(a, b))) -> List(a) {
  list.filter_map(ze_list, fn(either_or) {
    case either_or {
      Either(sth) -> Ok(sth)
      Or(_) -> Error(Nil)
    }
  })
}

/// Given a List(EitherOr(a, b)), removes all elements
/// of the form Either(a) and unwraps the remaining elements
/// of the form Or(b).
/// 
pub fn remove_eithers_unwrap_ors(ze_list: List(EitherOr(a, b))) -> List(b) {
  list.filter_map(ze_list, fn(either_or) {
    case either_or {
      Either(_) -> Error(Nil)
      Or(sth) -> Ok(sth)
    }
  })
}

/// Aggregates the payloads of consecutive Either instances
/// from a List(EitherOr(a, b)) into single Either(List(a)) 
/// elements, such as to turn a List(EitherOr(a, b)) into a
/// List(EitherOr(List(a), b)). Introduces an element of the
/// form Either([]: List(a)) between each consecutive pair of
/// 'Or(b)' elements symoblizing an empty of 'Either' payloads
/// sitting between pair of consecutive 'Or(b)' elements.
/// 
pub fn group_eithers(
  ze_list: List(EitherOr(a, b)),
) -> List(EitherOr(List(a), b)) {
  group_eithers_accumulator([], [], ze_list)
}

/// Aggregates the payloads of consecutive Or instances 
/// from a List(EitherOr(a, b)) into single Or(List(b)) 
/// elements, such as to turn a List(EitherOr(a, b)) into a
/// List(EitherOr(a, List(b))). Introduces an element of the
/// form Or([]: List(a)) between each consecutive pair of
/// 'Either(a)' elements, symoblizing an empty of 'Or' payloads
/// sitting between pair of consecutive 'Either(a)' elements.
/// 
pub fn group_ors(ze_list: List(EitherOr(a, b))) -> List(EitherOr(a, List(b))) {
  group_ors_accumulator([], [], ze_list)
}

/// Aggregates the payloads of consecutive Either instances
/// from a List(EitherOr(a, b)) into single Either(List(a)) 
/// elements, such as to turn a List(EitherOr(a, b)) into a
/// List(EitherOr(List(a), b)). Discards elements of the form
/// Either([]) from the final list.
/// 
pub fn group_eithers_no_empty_lists(
  ze_list: List(EitherOr(a, b)),
) -> List(EitherOr(List(a), b)) {
  group_eithers(ze_list)
  |> list.filter(fn(thing) {
    case thing {
      Either(a_list) -> !{ list.is_empty(a_list) }
      Or(_) -> True
    }
  })
}

/// Aggregates the payloads of consecutive Either instances
/// from a List(EitherOr(a, b)) into single Either(List(a)) 
/// elements, such as to turn a List(EitherOr(a, b)) into a
/// List(EitherOr(List(a), b)). Discards elements of the form
/// Or([]) from the final list.
/// 
pub fn group_ors_no_empty_lists(
  ze_list: List(EitherOr(a, b)),
) -> List(EitherOr(a, List(b))) {
  group_ors(ze_list)
  |> list.filter(fn(thing) {
    case thing {
      Either(_) -> True
      Or(a_list) -> !{ list.is_empty(a_list) }
    }
  })
}

/// Given a value z of arbitrary type and a bool b constructs a
/// value of type EitherOr(z, z) by outputting Either(z) if b is
/// True, else Or(z).
///
pub fn from_bool(
  z: z,
  b: Bool,
) -> EitherOr(z, z) {
  case b {
    True -> Either(z)
    False -> Or(z)
  }
}

/// Converts a Result(a, b) into an EitherOr(a, b).
///
pub fn from_result(
  z: Result(a, b),
) -> EitherOr(a, b) {
  case z {
    Ok(x) -> Either(x)
    Error(x) -> Or(x)
  }
}

/// Converts an EitherOr(a, b) into a Result(a, b).
///
pub fn to_result(
  z: EitherOr(a, b),
) -> Result(a, b) {
  case z {
    Either(x) -> Ok(x)
    Or(x) -> Error(x)
  }
}

/// Given a value z of type z and a function fn(z) -> Bool
/// constructs a value of type EitherOr(z, z) by outputting Either(z)
/// if f(z) is True, else Or(z).
/// 
pub fn classify(
  a: a,
  classifier classifier: fn(a) -> Bool
) -> EitherOr(a, a) {
  from_bool(a, classifier(a))
}

/// Given a List(z) of arbitrary type and a function f: fn(z) -> Bool,
/// returns a List(EitherOr(z, z)) by mapping over the list with
/// classify(_, f), i.e., by replacing each value z of the list
/// with Either(z) if f(z) True, Or(z) otherwise.
/// 
pub fn map_classify(
  list: List(z),
  classifier classifier: fn(z) -> Bool,
) -> List(EitherOr(z, z)) {
  list.map(list, classify(_, classifier))
}

/// Alias for map_classify.
///
pub const discriminate = map_classify
