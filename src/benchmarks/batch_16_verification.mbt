// Benchmarks Package Verification Grids - Batch 16

///|
/// Batch throughput test batch 16
test "benchmarks verification batch 16 - pinhole batch" {
  let count_val = 50 + 16 * 2
  let cs = run_pinhole_batch_benchmark(count_val)
  assert_true(cs > 0.0)
}

///|
/// Helper benchmarks table generator 1 for batch 16
pub fn get_benchmarks_batch_16_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 1).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 2 for batch 16
pub fn get_benchmarks_batch_16_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 2).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 3 for batch 16
pub fn get_benchmarks_batch_16_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 3).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 4 for batch 16
pub fn get_benchmarks_batch_16_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 4).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 5 for batch 16
pub fn get_benchmarks_batch_16_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 5).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 6 for batch 16
pub fn get_benchmarks_batch_16_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 6).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 7 for batch 16
pub fn get_benchmarks_batch_16_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 7).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 8 for batch 16
pub fn get_benchmarks_batch_16_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 8).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 9 for batch 16
pub fn get_benchmarks_batch_16_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 16 + 9).to_double() * 0.001
    arr.push(t)
  }
  arr
}
