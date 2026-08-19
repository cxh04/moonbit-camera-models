// Datasets Package Verification Grids - Batch 15

///|
/// Circular trajectory test batch 15
test "datasets verification batch 15 - trajectory pose" {
  let count_val = 50 + 15 * 2
  let traj = generate_circular_trajectory(count_val, 10.0, @math.Vec3::zero())
  for i in 0..<traj.length() {
    let det = traj[i].rotation.determinant()
    assert_true(@math.approx_eq(det, 1.0, 1.0e-5))
  }
}

///|
/// Helper datasets table generator 1 for batch 15
pub fn get_datasets_batch_15_table_1() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 1).to_double() * 0.2
    let y = (i * 1).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 2 for batch 15
pub fn get_datasets_batch_15_table_2() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 2).to_double() * 0.2
    let y = (i * 2).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 3 for batch 15
pub fn get_datasets_batch_15_table_3() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 3).to_double() * 0.2
    let y = (i * 3).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 4 for batch 15
pub fn get_datasets_batch_15_table_4() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 4).to_double() * 0.2
    let y = (i * 4).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 5 for batch 15
pub fn get_datasets_batch_15_table_5() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 5).to_double() * 0.2
    let y = (i * 5).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 6 for batch 15
pub fn get_datasets_batch_15_table_6() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 6).to_double() * 0.2
    let y = (i * 6).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 7 for batch 15
pub fn get_datasets_batch_15_table_7() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 7).to_double() * 0.2
    let y = (i * 7).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 8 for batch 15
pub fn get_datasets_batch_15_table_8() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 8).to_double() * 0.2
    let y = (i * 8).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}

///|
/// Helper datasets table generator 9 for batch 15
pub fn get_datasets_batch_15_table_9() -> Array[@math.Vec3] {
  let arr = []
  for i in 0..<50 {
    let x = (i * 15 + 9).to_double() * 0.2
    let y = (i * 9).to_double() * 0.1
    let z = 5.0
    arr.push(@math.Vec3::new(x, y, z))
  }
  arr
}
