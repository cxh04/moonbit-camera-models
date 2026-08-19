// Benchmarks Package Verification Grids - Batch 18

///|
/// Batch throughput test batch 18
test "benchmarks verification batch 18 - pinhole batch" {
  let count_val = 50 + 18 * 2
  let cs = run_pinhole_batch_benchmark(count_val)
  assert_true(cs > 0.0)
}

///|
/// Helper benchmarks table generator 1 for batch 18
pub fn get_benchmarks_batch_18_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 1).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 2 for batch 18
pub fn get_benchmarks_batch_18_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 2).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 3 for batch 18
pub fn get_benchmarks_batch_18_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 3).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 4 for batch 18
pub fn get_benchmarks_batch_18_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 4).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 5 for batch 18
pub fn get_benchmarks_batch_18_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 5).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 6 for batch 18
pub fn get_benchmarks_batch_18_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 6).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 7 for batch 18
pub fn get_benchmarks_batch_18_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 7).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 8 for batch 18
pub fn get_benchmarks_batch_18_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 8).to_double() * 0.001
    arr.push(t)
  }
  arr
}

///|
/// Helper benchmarks table generator 9 for batch 18
pub fn get_benchmarks_batch_18_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let t = (i * 18 + 9).to_double() * 0.001
    arr.push(t)
  }
  arr
}
