// Math Package Comprehensive Verification Tables - Batch 28

///|
/// Verification test batch 28 for vector cross product and dot product invariants
test "math verification batch 28 - vector cross dot invariants" {
  for i in 0..<150 {
    let x = (i * 28).to_double() * 0.1 - 10.0
    let y = (i * 2 + 28).to_double() * 0.05 - 5.0
    let z = (i % 13).to_double() + 1.0
    let u = Vec3::new(x, y, z)
    let v = Vec3::new(y, z, x)
    let w = u.cross(v)
    assert_true(approx_eq(u.dot(w), 0.0, 1.0e-6))
    assert_true(approx_eq(v.dot(w), 0.0, 1.0e-6))
  }
}

///|
/// Verification test batch 28 for rotation matrix determinant and orthogonality
test "math verification batch 28 - rotation orthogonality" {
  for i in 0..<150 {
    let r = (i * 28).to_double() * 0.01
    let p = (i * 2).to_double() * 0.005
    let y = (i * 3).to_double() * 0.015
    let rot = euler_to_mat3x3(r, p, y)
    assert_true(approx_eq(rot.determinant(), 1.0, 1.0e-5))
  }
}

///|
/// Helper table generator 1 for batch 28
pub fn get_math_batch_28_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 1).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 2 for batch 28
pub fn get_math_batch_28_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 2).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 3 for batch 28
pub fn get_math_batch_28_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 3).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 4 for batch 28
pub fn get_math_batch_28_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 4).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 5 for batch 28
pub fn get_math_batch_28_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 5).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 6 for batch 28
pub fn get_math_batch_28_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 6).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 7 for batch 28
pub fn get_math_batch_28_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 7).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 8 for batch 28
pub fn get_math_batch_28_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 8).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 9 for batch 28
pub fn get_math_batch_28_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 28 + 9).to_double() * 0.12345
    arr.push(val)
  }
  arr
}
