// Camera Package Comprehensive Projection Grids - Batch 15

///|
/// Projection unprojection roundtrip test batch 15
test "camera verification batch 15 - pinhole grid roundtrip" {
  let dist = @distortion.BrownConrady::zero()
  let fx_val = 800.0 + 15.0
  let cam = PinholeCamera::with_distortion(
    fx_val, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )
  for i in 0..<100 {
    let x = (i % 10).to_double() * 0.4 - 1.8
    let y = (i / 10 % 10).to_double() * 0.3 - 1.35
    let z = 3.0 + (i % 5).to_double() * 1.5
    let p3 = @math.Vec3::new(x, y, z)
    let proj = cam.project(p3)
    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 1.0e-3))
  }
}

///|
/// Helper camera table generator 1 for batch 15
pub fn get_camera_batch_15_table_1() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 1).to_double() * 20.0
    let v = (i * 1).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 2 for batch 15
pub fn get_camera_batch_15_table_2() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 2).to_double() * 20.0
    let v = (i * 2).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 3 for batch 15
pub fn get_camera_batch_15_table_3() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 3).to_double() * 20.0
    let v = (i * 3).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 4 for batch 15
pub fn get_camera_batch_15_table_4() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 4).to_double() * 20.0
    let v = (i * 4).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 5 for batch 15
pub fn get_camera_batch_15_table_5() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 5).to_double() * 20.0
    let v = (i * 5).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 6 for batch 15
pub fn get_camera_batch_15_table_6() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 6).to_double() * 20.0
    let v = (i * 6).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 7 for batch 15
pub fn get_camera_batch_15_table_7() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 7).to_double() * 20.0
    let v = (i * 7).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 8 for batch 15
pub fn get_camera_batch_15_table_8() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 8).to_double() * 20.0
    let v = (i * 8).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}

///|
/// Helper camera table generator 9 for batch 15
pub fn get_camera_batch_15_table_9() -> Array[@math.Vec2] {
  let arr = []
  for i in 0..<50 {
    let u = (i * 15 + 9).to_double() * 20.0
    let v = (i * 9).to_double() * 10.0
    arr.push(@math.Vec2::new(u, v))
  }
  arr
}
