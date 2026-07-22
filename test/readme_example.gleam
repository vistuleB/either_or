import either_or

pub fn main() {
  let values =
    [-2, 3, -1, 4]
    |> either_or.map_classify(fn(number) { number >= 0 })

  either_or.partition(values)
  // #([3, 4], [-2, -1])
}
