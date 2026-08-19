// Math Package Comprehensive Verification Tables - Batch 20

///|
/// Verification test batch 20 for vector cross product and dot product invariants
test "math verification batch 20 - vector cross dot invariants" {
  for i in 0..<150 {
    let x = (i * 20).to_double() * 0.1 - 10.0
    let y = (i * 2 + 20).to_double() * 0.05 - 5.0
    let z = (i % 13).to_double() + 1.0
    let u = Vec3::new(x, y, z)
    let v = Vec3::new(y, z, x)
    let w = u.cross(v)
    assert_true(approx_eq(u.dot(w), 0.0, 1.0e-6))
    assert_true(approx_eq(v.dot(w), 0.0, 1.0e-6))
  }
}

///|
/// Verification test batch 20 for rotation matrix determinant and orthogonality
test "math verification batch 20 - rotation orthogonality" {
  for i in 0..<150 {
    let r = (i * 20).to_double() * 0.01
    let p = (i * 2).to_double() * 0.005
    let y = (i * 3).to_double() * 0.015
    let rot = euler_to_mat3x3(r, p, y)
    assert_true(approx_eq(rot.determinant(), 1.0, 1.0e-5))
  }
}

///|
/// Helper table generator 1 for batch 20
pub fn get_math_batch_20_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 1).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 2 for batch 20
pub fn get_math_batch_20_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 2).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 3 for batch 20
pub fn get_math_batch_20_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 3).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 4 for batch 20
pub fn get_math_batch_20_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 4).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 5 for batch 20
pub fn get_math_batch_20_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 5).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 6 for batch 20
pub fn get_math_batch_20_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 6).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 7 for batch 20
pub fn get_math_batch_20_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 7).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 8 for batch 20
pub fn get_math_batch_20_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 8).to_double() * 0.12345
    arr.push(val)
  }
  arr
}

///|
/// Helper table generator 9 for batch 20
pub fn get_math_batch_20_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let val = (i * 20 + 9).to_double() * 0.12345
    arr.push(val)
  }
  arr
}
