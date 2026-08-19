// Distortion Package Comprehensive Grid Tests - Batch 26

///|
/// Distortion model roundtrip test batch 26
test "distortion verification batch 26 - brown conrady grid" {
  let k1_val = 0.001 * 26.0
  let dist = BrownConrady::new(k1_val, -0.0002, 0.00005, -0.00001, 0.0)
  for i in 0..<100 {
    let x = (i % 10).to_double() * 0.08 - 0.4
    let y = (i / 10 % 10).to_double() * 0.08 - 0.4
    let p_norm = @math.Vec2::new(x, y)
    let p_dist = dist.distort(p_norm)
    let p_rec = dist.undistort(p_dist, 25, 1.0e-6)
    assert_true(@math.approx_eq(p_rec.x, p_norm.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p_norm.y, 1.0e-3))
  }
}

///|
/// Helper distortion table generator 1 for batch 26
pub fn get_distortion_batch_26_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 1).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 2 for batch 26
pub fn get_distortion_batch_26_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 2).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 3 for batch 26
pub fn get_distortion_batch_26_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 3).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 4 for batch 26
pub fn get_distortion_batch_26_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 4).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 5 for batch 26
pub fn get_distortion_batch_26_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 5).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 6 for batch 26
pub fn get_distortion_batch_26_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 6).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 7 for batch 26
pub fn get_distortion_batch_26_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 7).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 8 for batch 26
pub fn get_distortion_batch_26_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 8).to_double() * 0.001
    arr.push(k)
  }
  arr
}

///|
/// Helper distortion table generator 9 for batch 26
pub fn get_distortion_batch_26_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let k = (i * 26 + 9).to_double() * 0.001
    arr.push(k)
  }
  arr
}
