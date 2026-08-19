// Benchmarks Package Verification Grids - Batch 20

///|
/// Batch throughput test batch 20
test "benchmarks verification batch 20 - pinhole batch" {
  let count_val = 50 + 20 * 2
  let cs = run_pinhole_batch_benchmark(count_val)
  assert_true(cs > 0.0)
}

///|
/// Helper benchmarks table generator 1 for batch 20
pub fn get_benchmarks_batch_20_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 1).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 2 for batch 20
pub fn get_benchmarks_batch_20_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 2).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 3 for batch 20
pub fn get_benchmarks_batch_20_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 3).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 4 for batch 20
pub fn get_benchmarks_batch_20_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 4).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 5 for batch 20
pub fn get_benchmarks_batch_20_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 5).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 6 for batch 20
pub fn get_benchmarks_batch_20_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 6).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 7 for batch 20
pub fn get_benchmarks_batch_20_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 7).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 8 for batch 20
pub fn get_benchmarks_batch_20_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 8).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 9 for batch 20
pub fn get_benchmarks_batch_20_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 20 + 9).to_double() * 0.001
    arr.push(t)
  }
  arr
}
