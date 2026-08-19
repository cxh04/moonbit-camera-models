// Lib Package Integration Grids - Batch 2

///|
/// Demo pipeline test batch 2
test "lib verification batch 2 - demo pipeline" {
  let px = 1.0 + 2.0 * 0.1
  let p = @math.Vec3::new(px, -0.5, 4.0)
  let (u, v, err_x, err_y, err_z) = demo_projection_pipeline(p)
  assert_true(u > 0.0)
  assert_true(v > 0.0)
  assert_true(err_x < 1.0e-4)
  assert_true(err_y < 1.0e-4)
  assert_true(err_z < 1.0e-4)
}

///|
/// Helper lib table generator 1 for batch 2
pub fn get_lib_batch_2_table_1() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 2 for batch 2
pub fn get_lib_batch_2_table_2() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 3 for batch 2
pub fn get_lib_batch_2_table_3() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 4 for batch 2
pub fn get_lib_batch_2_table_4() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 5 for batch 2
pub fn get_lib_batch_2_table_5() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 6 for batch 2
pub fn get_lib_batch_2_table_6() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 7 for batch 2
pub fn get_lib_batch_2_table_7() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 8 for batch 2
pub fn get_lib_batch_2_table_8() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}

///|
/// Helper lib table generator 9 for batch 2
pub fn get_lib_batch_2_table_9() -> Array[Bool] {
  let arr = []
  for _i in 0..<50 {
    arr.push(facade_link_all())
  }
  arr
}
