// Geometry Grid Verification Tables - Set 1: Epipolar Constraint, Sampson Error, and Homography Transfer

///|
/// Test Epipolar Constraint x2^T * E * x1 == 0 for 100 camera rotations and translations
test "geometry grid tables 1 - essential matrix constraint grid" {
  let p_world = @math.Vec3::new(2.0, -1.0, 8.0)

  for i in 0..<100 {
    let roll = i.to_double() * 0.01 - 0.5
    let pitch = i.to_double() * 0.005 - 0.25
    let yaw = i.to_double() * 0.015 - 0.75
    let rot = @math.euler_to_mat3x3(roll, pitch, yaw)
    let trans = @math.Vec3::new(
      0.1 * i.to_double() - 5.0,
      0.05 * i.to_double(),
      0.2,
    )

    let e = essential_matrix(rot, trans)
    let p_cam2 = rot.mul_vec3(p_world).add(trans)

    let x1 = p_world.normalized()
    let x2 = p_cam2.normalized()

    let ex1 = e.mul_vec3(x1)
    let residual = x2.dot(ex1)
    assert_true(residual.abs() < 1.0e-4)
  }
}

///|
/// Test Homography matrix plane transfer error for 50 plane point transfers
test "geometry grid tables 1 - homography plane transfer grid" {
  let rot = @math.euler_to_mat3x3(0.05, -0.02, 0.01)
  let trans = @math.Vec3::new(0.1, 0.05, -0.02)
  let n = @math.Vec3::new(0.0, 0.0, 1.0)
  let d = 5.0

  let h = compute_homography_matrix(rot, trans, n, d)

  for i in 0..<50 {
    let x = (i % 7).to_double() * 0.2 - 0.6
    let y = (i / 7 % 7).to_double() * 0.2 - 0.6
    let p1_plane = @math.Vec3::new(x, y, d)

    let p2_true = rot.mul_vec3(p1_plane).add(trans)

    let p1_norm = @math.Vec3::new(x / d, y / d, 1.0)
    let p2_transfer = h.mul_vec3(p1_norm)
    let p2_norm_transfer = p2_transfer.div_scalar(p2_transfer.z)

    let p2_norm_true = p2_true.div_scalar(p2_true.z)

    assert_true(@math.approx_eq(p2_norm_transfer.x, p2_norm_true.x, 1.0e-4))
    assert_true(@math.approx_eq(p2_norm_transfer.y, p2_norm_true.y, 1.0e-4))
  }
}
