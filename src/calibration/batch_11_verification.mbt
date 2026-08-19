// Calibration Package Verification Grids - Batch 11

///|
/// Target generator grid test batch 11
test "calibration verification batch 11 - target grid" {
  for r in 2..<=5 {
    for c in 2..<=8 {
      let target = generate_checkerboard_target(c, r, 0.03)
      assert_eq(target.length(), c * r)
    }
  }
}

///|
/// Helper calibration table generator 1 for batch 11
pub fn get_calibration_batch_11_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 1).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 2 for batch 11
pub fn get_calibration_batch_11_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 2).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 3 for batch 11
pub fn get_calibration_batch_11_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 3).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 4 for batch 11
pub fn get_calibration_batch_11_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 4).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 5 for batch 11
pub fn get_calibration_batch_11_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 5).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 6 for batch 11
pub fn get_calibration_batch_11_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 6).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 7 for batch 11
pub fn get_calibration_batch_11_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 7).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 8 for batch 11
pub fn get_calibration_batch_11_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 8).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 9 for batch 11
pub fn get_calibration_batch_11_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 11 + 9).to_double() * 0.05
    arr.push(err)
  }
  arr
}
