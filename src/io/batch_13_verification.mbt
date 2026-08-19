// IO Package Serialization Grids - Batch 13

///|
/// COLMAP camera export test batch 13
test "io verification batch 13 - colmap line export" {
  for i in 1..<=30 {
    let fx = 500.0 + i.to_double() * 10.0
    let cam = @camera.PinholeCamera::new(fx, fx, 640.0, 360.0, 1280.0, 720.0)
    let line_str = export_colmap_camera(cam, i)
    let parsed = parse_colmap_camera_line(line_str).unwrap()
    assert_true(@math.approx_eq(parsed.fx, fx, 1.0e-3))
  }
}

///|
/// Helper IO table generator 1 for batch 13
pub fn get_io_batch_13_table_1() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 1).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 2 for batch 13
pub fn get_io_batch_13_table_2() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 2).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 3 for batch 13
pub fn get_io_batch_13_table_3() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 3).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 4 for batch 13
pub fn get_io_batch_13_table_4() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 4).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 5 for batch 13
pub fn get_io_batch_13_table_5() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 5).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 6 for batch 13
pub fn get_io_batch_13_table_6() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 6).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 7 for batch 13
pub fn get_io_batch_13_table_7() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 7).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 8 for batch 13
pub fn get_io_batch_13_table_8() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 8).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 9 for batch 13
pub fn get_io_batch_13_table_9() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 13 + 9).to_string()
    arr.push(s)
  }
  arr
}
