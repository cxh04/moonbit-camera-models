// IO Package Serialization Grids - Batch 12

///|
/// COLMAP camera export test batch 12
test "io verification batch 12 - colmap line export" {
  for i in 1..<=30 {
    let fx = 500.0 + i.to_double() * 10.0
    let cam = @camera.PinholeCamera::new(fx, fx, 640.0, 360.0, 1280.0, 720.0)
    let line_str = export_colmap_camera(cam, i)
    let parsed = parse_colmap_camera_line(line_str).unwrap()
    assert_true(@math.approx_eq(parsed.fx, fx, 1.0e-3))
  }
}

///|
/// Helper IO table generator 1 for batch 12
pub fn get_io_batch_12_table_1() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 1).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 2 for batch 12
pub fn get_io_batch_12_table_2() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 2).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 3 for batch 12
pub fn get_io_batch_12_table_3() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 3).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 4 for batch 12
pub fn get_io_batch_12_table_4() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 4).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 5 for batch 12
pub fn get_io_batch_12_table_5() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 5).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 6 for batch 12
pub fn get_io_batch_12_table_6() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 6).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 7 for batch 12
pub fn get_io_batch_12_table_7() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 7).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 8 for batch 12
pub fn get_io_batch_12_table_8() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 8).to_string()
    arr.push(s)
  }
  arr
}

///|
/// Helper IO table generator 9 for batch 12
pub fn get_io_batch_12_table_9() -> Array[String] {
  let arr = []
  for i in 0..<50 {
    let s = "CAM_" + (i * 12 + 9).to_string()
    arr.push(s)
  }
  arr
}
