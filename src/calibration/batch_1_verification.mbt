// Calibration Package Verification Grids - Batch 1

///|
/// Target generator grid test batch 1
test "calibration verification batch 1 - target grid" {
  for r in 2..<=5 {
    for c in 2..<=8 {
      let target = generate_checkerboard_target(c, r, 0.03)
      assert_eq(target.length(), c * r)
    }
  }
}

///|
/// Helper calibration table generator 1 for batch 1
pub fn get_calibration_batch_1_table_1() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 1).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 2 for batch 1
pub fn get_calibration_batch_1_table_2() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 2).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 3 for batch 1
pub fn get_calibration_batch_1_table_3() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 3).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 4 for batch 1
pub fn get_calibration_batch_1_table_4() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 4).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 5 for batch 1
pub fn get_calibration_batch_1_table_5() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 5).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 6 for batch 1
pub fn get_calibration_batch_1_table_6() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 6).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 7 for batch 1
pub fn get_calibration_batch_1_table_7() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 7).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 8 for batch 1
pub fn get_calibration_batch_1_table_8() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 8).to_double() * 0.05
    arr.push(err)
  }
  arr
}

///|
/// Helper calibration table generator 9 for batch 1
pub fn get_calibration_batch_1_table_9() -> Array[Double] {
  let arr = []
  for i in 0..<50 {
    let err = (i * 1 + 9).to_double() * 0.05
    arr.push(err)
  }
  arr
}
