// Benchmarks Package Verification Grids - Batch 1

///|
/// Batch throughput test batch 1
test "benchmarks verification batch 1 - pinhole batch" {
  let count_val = 50 + 1 * 2
  let cs = run_pinhole_batch_benchmark(count_val)
  assert_true(cs > 0.0)
}

///|
/// Helper benchmarks table generator 1 for batch 1
pub fn get_benchmarks_batch_1_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 1).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 2 for batch 1
pub fn get_benchmarks_batch_1_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 2).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 3 for batch 1
pub fn get_benchmarks_batch_1_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 3).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 4 for batch 1
pub fn get_benchmarks_batch_1_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 4).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 5 for batch 1
pub fn get_benchmarks_batch_1_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 5).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 6 for batch 1
pub fn get_benchmarks_batch_1_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 6).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 7 for batch 1
pub fn get_benchmarks_batch_1_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 7).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 8 for batch 1
pub fn get_benchmarks_batch_1_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 8).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 9 for batch 1
pub fn get_benchmarks_batch_1_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 1 + 9).to_double() * 0.001
    arr.push(t)
  }
  arr
}
