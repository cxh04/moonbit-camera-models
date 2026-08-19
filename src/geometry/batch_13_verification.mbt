// Geometry Package Verification Grids - Batch 13

///|
/// Essential matrix epipolar constraint test batch 13
test "geometry verification batch 13 - essential constraint" {
  let p_world = @math.Vec3::new(1.0, -0.5, 4.0)
  for i in 0..<80 {
    let rot = @math.euler_to_mat3x3(
      0.01 * i.to_double(),
      -0.005 * i.to_double(),
      0.02 * i.to_double(),
    )
    let trans = @math.Vec3::new(
      0.1 * i.to_double() - 2.0,
      0.05 * i.to_double(),
      0.5,
    )
    let e = essential_matrix(rot, trans)
    let p_cam2 = rot.mul_vec3(p_world).add(trans)
    let x1 = p_world.normalized()
    let x2 = p_cam2.normalized()
    let ex1 = e.mul_vec3(x1)
    let err = x2.dot(ex1)
    assert_true(err.abs() < 1.0e-4)
  }
}

///|
/// Helper geometry table generator 1 for batch 13
pub fn get_geometry_batch_13_table_1() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 1).to_double() * 0.1
    let y = (i * 1).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 2 for batch 13
pub fn get_geometry_batch_13_table_2() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 2).to_double() * 0.1
    let y = (i * 2).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 3 for batch 13
pub fn get_geometry_batch_13_table_3() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 3).to_double() * 0.1
    let y = (i * 3).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 4 for batch 13
pub fn get_geometry_batch_13_table_4() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 4).to_double() * 0.1
    let y = (i * 4).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 5 for batch 13
pub fn get_geometry_batch_13_table_5() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 5).to_double() * 0.1
    let y = (i * 5).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 6 for batch 13
pub fn get_geometry_batch_13_table_6() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 6).to_double() * 0.1
    let y = (i * 6).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 7 for batch 13
pub fn get_geometry_batch_13_table_7() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 7).to_double() * 0.1
    let y = (i * 7).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 8 for batch 13
pub fn get_geometry_batch_13_table_8() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 8).to_double() * 0.1
    let y = (i * 8).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper geometry table generator 9 for batch 13
pub fn get_geometry_batch_13_table_9() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 13 + 9).to_double() * 0.1
    let y = (i * 9).to_double() * 0.05
    let z = (i % 10).to_double() + 1.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}
