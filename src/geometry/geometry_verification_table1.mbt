// Multi-View Epipolar Geometry and Triangulation Verification Tables

///|
/// Verification Grid Test for Essential Matrix Epipolar Constraint x2^T * E * x1 = 0 over 50 Camera Poses
test "geometry verification table 1 - essential matrix epipolar constraint grid" {
  let p_world = @math.Vec3::new(1.5, -0.8, 5.0)

  for i in 0..<50 {
    let roll = i.to_double() * 0.02 - 0.5
    let pitch = i.to_double() * 0.01 - 0.25
    let yaw = i.to_double() * 0.03 - 0.75
    let rot = @math.euler_to_mat3x3(roll, pitch, yaw)
    let trans = @math.Vec3::new(
      0.2 * i.to_double() - 5.0,
      0.1 * i.to_double(),
      0.5,
    )

    let e = essential_matrix(rot, trans)
    let p_cam2 = rot.mul_vec3(p_world).add(trans)

    let x1 = p_world.normalized()
    let x2 = p_cam2.normalized()

    let ex1 = e.mul_vec3(x1)
    let epipolar_residual = x2.dot(ex1)
    assert_true(epipolar_residual.abs() < 1.0e-4)
  }
}

///|
/// Verification Grid Test for Sampson Epipolar Distance Metric Error Bounds
test "geometry verification table 1 - sampson distance error bounds" {
  let rot = @math.euler_to_mat3x3(0.05, -0.02, 0.01)
  let trans = @math.Vec3::new(0.12, 0.0, 0.0)
  let e = essential_matrix(rot, trans)

  let k = @math.Mat3x3::new(960.0, 0.0, 960.0, 0.0, 960.0, 540.0, 0.0, 0.0, 1.0)
  let k_inv = k.inverse().unwrap()
  let f = fundamental_matrix(e, k_inv, k_inv)

  for i in 0..<30 {
    let p_3d = @math.Vec3::new(
      i.to_double() * 0.2 - 3.0,
      i.to_double() * 0.1 - 1.5,
      4.0,
    )
    let p2_3d = rot.mul_vec3(p_3d).add(trans)

    let p1_homo = k.mul_vec3(p_3d.div_scalar(p_3d.z))
    let p2_homo = k.mul_vec3(p2_3d.div_scalar(p2_3d.z))

    let pt1 = @math.Vec2::new(p1_homo.x, p1_homo.y)
    let pt2 = @math.Vec2::new(p2_homo.x, p2_homo.y)

    let samp_err = sampson_distance(f, pt1, pt2)
    assert_true(samp_err < 1.0e-3)
  }
}

///|
/// Verification Grid Test for 3D Midpoint Triangulation over 50 Parallel Stereo Rays
test "geometry verification table 1 - midpoint triangulation grid precision" {
  let pose1 = @math.RigidTransform::identity()
  let pose2 = @math.RigidTransform::new(
    @math.Mat3x3::identity(),
    @math.Vec3::new(-0.12, 0.0, 0.0),
  )

  for i in 0..<50 {
    let true_z = 2.0 + i.to_double() * 0.2
    let p_world = @math.Vec3::new(0.3, -0.2, true_z)

    let ray1 = @math.Ray::new(@math.Vec3::zero(), p_world.normalized())
    let p_rel2 = p_world.sub(@math.Vec3::new(0.12, 0.0, 0.0))
    let ray2 = @math.Ray::new(@math.Vec3::zero(), p_rel2.normalized())

    let p_tri = triangulate_midpoint(pose1, ray1, pose2, ray2)
    assert_true(p_tri.z > 0.0)
  }
}
