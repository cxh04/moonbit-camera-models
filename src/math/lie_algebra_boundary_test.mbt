// Boundary Test Suite for SO(3) and SE(3) Lie Algebra Operations

///|
/// Boundary Test: Rodrigues Exp/Log near Identity (theta -> 0) and Pi (theta -> pi)
test "rodrigues exp and log boundary cases" {
  let zero_omega = Vec3::zero()
  let eye_rot = rodrigues_exp(zero_omega)
  assert_eq(eye_rot, Mat3x3::identity())
  let rec_zero = rodrigues_log(eye_rot)
  assert_eq(rec_zero, Vec3::zero())

  let tiny_omega = Vec3::new(1.0e-8, -2.0e-8, 3.0e-8)
  let tiny_rot = rodrigues_exp(tiny_omega)
  let rec_tiny = rodrigues_log(tiny_rot)
  assert_true(approx_eq(rec_tiny.x, tiny_omega.x, 1.0e-7))
  assert_true(approx_eq(rec_tiny.y, tiny_omega.y, 1.0e-7))
  assert_true(approx_eq(rec_tiny.z, tiny_omega.z, 1.0e-7))

  let pi_omega = Vec3::new(3.141592653589793, 0.0, 0.0)
  let pi_rot = rodrigues_exp(pi_omega)
  let rec_pi = rodrigues_log(pi_rot)
  assert_true(approx_eq(rec_pi.x, pi_omega.x, 1.0e-3))
}

///|
/// Boundary Test: Euler Angle round-trip and Gimbal Lock boundaries
test "euler angle matrix conversion and gimbal lock bounds" {
  let roll = 0.3
  let pitch = 0.4
  let yaw = -0.5
  let rot = euler_to_mat3x3(roll, pitch, yaw)
  let (r_rec, p_rec, y_rec) = mat3x3_to_euler(rot)

  assert_true(approx_eq(r_rec, roll, 1.0e-4))
  assert_true(approx_eq(p_rec, pitch, 1.0e-4))
  assert_true(approx_eq(y_rec, yaw, 1.0e-4))
}

///|
/// Boundary Test: SE(3) RigidTransform Inverses and Identity Composition
test "se3 rigid transform identity and composition boundaries" {
  let eye_pose = RigidTransform::identity()
  let p = Vec3::new(1.0, 2.0, 3.0)
  assert_eq(eye_pose.transform_point(p), p)

  let inv_eye = eye_pose.inverse()
  assert_eq(inv_eye.rotation, Mat3x3::identity())
  assert_eq(inv_eye.translation, Vec3::zero())
}
