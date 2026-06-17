import gleam/list
import gleam/option.{type Option, Some, None}

/// A generic choice type.
/// 
pub type EitherOr(a, b) {
  Either(a)
  Or(b)
}

/// Given a value of type `EitherOr(a, b)` returns `True` if and
/// only if the value is an `Either` variant.
///
pub fn is_either(v: EitherOr(a, b)) -> Bool {
  case v {
    Either(_) -> True
    _ -> False
  }
}

/// Given a value of type `EitherOr(a, b)` value returns `True` if and
/// only if the value is an `Or` variant.
///
pub fn is_or(v: EitherOr(a, b)) -> Bool {
  case v {
    Or(_) -> True
    _ -> False
  }
}

/// Given a value of type `EitherOr(a, b)` returns `Some(a)` if
/// the value has the form `Either(a)` else returns `None`.
///
pub fn get_either(v: EitherOr(a, b)) -> Option(a) {
  case v {
    Either(x) -> Some(x)
    _ -> None
  }
}

/// Given a value of type `EitherOr(a, b)` returns `Some(x)` if
/// the value has the form `Or(x)` else returns `None`.
///
pub fn get_or(v: EitherOr(a, b)) -> Option(b) {
  case v {
    Or(x) -> Some(x)
    _ -> None
  }
}

/// Given a value of type `EitherOr(a, b)` and default of type `a`
/// returns `x` if the value has the form `Either(x)` else returns
/// the default.
///
pub fn unwrap_either(v: EitherOr(a, b), default: a) -> a {
  case v {
    Either(x) -> x
    _ -> default
  }
}

/// Given a value of type `EitherOr(a, b)` and default of type `b`
/// returns `x` if the value has the form `Or(x)` else returns
/// the default.
///
pub fn unwrap_or(v: EitherOr(a, b), default: b) -> b {
  case v {
    Or(x) -> x
    _ -> default
  }
}

/// Given a value of type `EitherOr(a, a)` returns the payload
/// of type `a` regardless of the variant.
///
pub fn unwrap(v: EitherOr(a, a)) -> a {
  case v {
    Either(a) -> a
    Or(a) -> a
  }
}

/// Given a value of type `EitherOr(a, b)` and a
/// function `f: a -> c` returns `Either(f(a))` if the
/// value has the form `Either(a)` and returns `Or(b)`
/// if the value has the form `Or(b)`.
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

/// Given a value of type `EitherOr(a, b)` and a
/// function `f: b -> c` returns `Or(f(b))` if the
/// value has the form `Or(b)` and returns `Either(a)`
/// if the value has the form `Either(a)`.
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

/// Apply separate maps to each payload of an `EitherOr`
/// value.
///
/// Symmetric to [`map_oe`](#map_oe).
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either `Either`
/// or `Or` variants via the `use <-` syntax.
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

/// Apply separate maps to each payload of an `EitherOr`
/// value.
///
/// Symmetric to [`map_eo`](#map_eo).
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either `Either`
/// or `Or` variants via the `use <-` syntax.
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

/// Given a value of type `EitherOr(a, b)` and functions
/// `f1: a -> c`, `f2: b -> c`, returns `f1(a)` if the
/// value has the form `Either(a)` and returns `f2(b)`
/// if the value has the form `Or(b)`.
///
/// Symmetric to [`resolve_oe`](#resolve_oe).
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either `Either`
/// or `Or` variants via the `use <-` syntax.
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

/// Given a value of type `EitherOr(a, b)` and functions
/// `f1: b -> c`, `f2: a -> c`, returns `f1(a)` if the
/// value has the form `Either(a)` and returns `f2(b)`
/// if the value has the form `Or(b)`.
///
/// Symmetric to [`resolve_eo`](#resolve_eo).
/// 
/// Both functions are offered to in order to allow 
/// the happy path to be pursued with either `Either`
/// or `Or` variants via the `use <-` syntax.
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

/// Flatten an `EitherOr(EitherOr(a, b), b)`-value.
/// 
pub fn flatten_either(
  t: EitherOr(EitherOr(a, b), b),
) -> EitherOr(a, b) {
  case t {
    Either(either_or) -> either_or
    Or(b) -> Or(b)
  }
}

/// Flatten an `EitherOr(a, EitherOr(a, b))`-value.
/// 
pub fn flatten_or(
  t: EitherOr(a, EitherOr(a, b)),
) -> EitherOr(a, b) {
  case t {
    Either(a) -> Either(a)
    Or(either_or) -> either_or
  }
}

/// Flatten a `EitherOr(EitherOr(a, b), EitherOr(a, b))` value.
/// 
/// Isomorphic to the special case of [`unwrap`](#unwrap) in which the type
/// `a` has the form `EitherOr(c, d)` for some types `c` and `d`.
/// 
pub fn flatten(
  t: EitherOr(EitherOr(a, b), EitherOr(a, b)),
) -> EitherOr(a, b) {
  unwrap(t)
}

/// Compose [`map_either`](#map_either) and [`flatten_either`](#flatten_either).
///
pub fn flat_map_either(
  v: EitherOr(a, b),
  f: fn(a) -> EitherOr(c, b),
) -> EitherOr(c, b) {
  v |> map_either(f) |> flatten_either
}

/// Compose [`map_or`](#map_or) and [`flatten_or`](#flatten_or).
///
pub fn flat_map_or(
  v: EitherOr(a, b),
  with f: fn(b) -> EitherOr(a, c),
) -> EitherOr(a, c) {
  v |> map_or(f) |> flatten_or
}

/// Given a value of type `EitherOr(a, b)` returns a
/// value of type `EitherOr(b, a)` by swapping the payloads.
/// 
pub fn swap(
  v: EitherOr(a, b),
) -> EitherOr(b, a) {
  case v {
    Either(a) -> Or(a)
    Or(b) -> Either(b)
  }
}

/// Applies [`map_either`](#map_either) to each element of a list of
/// `EitherOr(a, b)` elements.
/// 
pub fn map_eithers(
  v: List(EitherOr(a, b)),
  f: fn(a) -> c,
) -> List(EitherOr(c, b)) {
  list.map(v, map_either(_, f))
}

/// Applies [`map_or`](#map_or) to each element of a list of
/// `EitherOr(a, b)` elements.
/// 
pub fn map_ors(
  v: List(EitherOr(a, b)),
  f: fn(b) -> c,
) -> List(EitherOr(a, c)) {
  list.map(v, map_or(_, f))
}

/// Applies [`resolve_eo`](#resolve_eo) to each element of a list
/// of `EitherOr(a, b)` elements.
/// 
pub fn map_resolve(
  v: List(EitherOr(a, b)),
  on_either f: fn(a) -> c,
  on_or g: fn(b) -> c,
) -> List(c) {
  list.map(v, resolve_eo(_, f, g))
}

/// Given a `List(EitherOr(a, b))` removes all elements
/// of the form `Or(b)` and unwraps the remaining elements.
/// 
pub fn keep_eithers(list: List(EitherOr(a, b))) -> List(a) {
  list.filter_map(list, to_result)
}

/// Given a `List(EitherOr(a, b))` removes all elements
/// of the form `Either(a)` and unwraps the remaining elements.
/// 
pub fn keep_ors(list: List(EitherOr(a, b))) -> List(b) {
  list.filter_map(list, to_swapped_result)
}

fn do_group_eithers(
  already_packaged: List(EitherOr(List(a), b)),
  under_construction: List(a),
  upcoming: List(EitherOr(a, b)),
) -> List(EitherOr(List(a), b)) {
  let package_under_construction = fn() {
    case under_construction {
      [] -> already_packaged
      _ -> [under_construction |> list.reverse |> Either, ..already_packaged]
    }
  }

  case upcoming {
    [] ->
      package_under_construction()
      |> list.reverse

    [Either(a), ..rest] ->
      do_group_eithers(
        already_packaged,
        [a, ..under_construction],
        rest,
      )

    [Or(b), ..rest] ->
      do_group_eithers(
        [Or(b), ..package_under_construction()],
        [],
        rest,
      )
  }
}

/// Aggregates the payloads of consecutive `Either` instances
/// from a `List(EitherOr(a, b))` into single `Either(List(a))` 
/// elements, such as to turn a `List(EitherOr(a, b))` into a
/// `List(EitherOr(List(a), b))`.
/// 
pub fn group_eithers(
  ze_list: List(EitherOr(a, b)),
) -> List(EitherOr(List(a), b)) {
  do_group_eithers([], [], ze_list)
}

fn do_group_ors(
  already_packaged: List(EitherOr(a, List(b))),
  under_construction: List(b),
  upcoming: List(EitherOr(a, b)),
) -> List(EitherOr(a, List(b))) {
  let package_under_construction = fn() {
    case under_construction {
      [] -> already_packaged
      _ -> [under_construction |> list.reverse |> Or, ..already_packaged]
    }
  }

  case upcoming {
    [] ->
      package_under_construction()
      |> list.reverse

    [Or(b), ..rest] ->
      do_group_ors(
        already_packaged,
        [b, ..under_construction],
        rest,
      )

    [Either(a), ..rest] ->
      do_group_ors(
        [Either(a), ..package_under_construction()],
        [],
        rest,
      )
  }
}

/// Aggregates the payloads of consecutive Or instances
/// from a `List(EitherOr(a, b))` into single `Or(List(b))` 
/// elements such as to turn a `List(EitherOr(a, b))` into a
/// `List(EitherOr(a, List(b)))`.
/// 
pub fn group_ors(
  ze_list: List(EitherOr(a, b)),
) -> List(EitherOr(a, List(b))) {
  do_group_ors([], [], ze_list)
}

/// Converts a `Result(a, b)` into an `EitherOr(a, b)`.
///
pub fn from_result(
  z: Result(a, b),
) -> EitherOr(a, b) {
  case z {
    Ok(x) -> Either(x)
    Error(x) -> Or(x)
  }
}

/// Converts an `EitherOr(a, b)` into a `Result(a, b)`.
///
pub fn to_result(
  z: EitherOr(a, b),
) -> Result(a, b) {
  case z {
    Either(x) -> Ok(x)
    Or(x) -> Error(x)
  }
}

/// Converts an `EitherOr(a, b)` into a `Result(b, a)`.
///
fn to_swapped_result(
  z: EitherOr(a, b),
) -> Result(b, a) {
  case z {
    Either(x) -> Error(x)
    Or(x) -> Ok(x)
  }
}

/// Given a value `z` of arbitrary type and a bool `b` returns
/// `Either(z)` if `b == True` else returns `Or(z)`.
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

/// Lazy form of [`from_bool`](#from_bool).
/// 
pub fn from_predicate(
  a: a,
  predicate predicate: fn(a) -> Bool
) -> EitherOr(a, a) {
  case predicate(a) {
    True -> Either(a)
    False -> Or(a)
  }
}

/// Alias for of [`from_predicate`](#from_predicate).
/// 
pub fn classify(
  a: a,
  predicate predicate: fn(a) -> Bool
) -> EitherOr(a, a) {
  case predicate(a) {
    True -> Either(a)
    False -> Or(a)
  }
}

/// Given a `List(z)` and a function `f: z -> Bool` returns
/// a `List(EitherOr(z, z))` by mapping over the list with
/// [`classify`](#classify)`(_, f)`.
/// 
pub fn map_classify(
  from list: List(z),
  with predicate: fn(z) -> Bool,
) -> List(EitherOr(z, z)) {
  list.map(list, classify(_, predicate))
}

/// Splits a `List(EitherOr(a, b))` into a `#(List(a), List(b))`
/// while inverting the order in each sublist. Faster than
/// [`either_or.partition`](#partition), which maintains the
/// original order.
/// 
pub fn partition_reversed(from list: List(EitherOr(a, b))) -> #(List(a), List(b)) {
  list.fold(
    over: list, 
    from: #([], []), 
    with: fn(acc, item) {
    case item {
      Either(val) -> #([val, ..acc.0], acc.1)
      Or(val) -> #(acc.0, [val, ..acc.1])
    }
  })
}

/// Splits a `List(EitherOr(a, b))` into a `#(List(a), List(b))`
/// while maintaining the order in each sublist.
/// 
/// See also [`partition_reversed`](#partition_reversed).
/// 
pub fn partition(from list: List(EitherOr(a, b))) -> #(List(a), List(b)) {
  let #(l1, l2) = partition_reversed(list)
  #(l1 |> list.reverse, l2 |> list.reverse)
}