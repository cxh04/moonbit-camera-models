// Comprehensive Vector Algebra and Matrix Transformation Verification Tables

///|
/// Verify 3D rotation matrix orthogonality and determinant for 100 angle configurations
test "math verification table 1 - rotation matrix orthogonality" {
  for i in 0..<100 {
    let roll = i.to_double() * 0.06283185307179586 - 3.141592653589793
    let pitch = (i * 2).to_double() * 0.03141592653589793 - 1.5707963267948966
    let yaw = (i * 3).to_double() * 0.06283185307179586 - 3.141592653589793

    let rot = euler_to_mat3x3(roll, pitch, yaw)
    let det = rot.determinant()
    assert_true(approx_eq(det, 1.0, 1.0e-5))

    let rot_t = rot.transpose()
    let eye_check = rot.mul_mat3x3(rot_t)
    assert_true(approx_eq(eye_check.m00, 1.0, 1.0e-5))
    assert_true(approx_eq(eye_check.m11, 1.0, 1.0e-5))
    assert_true(approx_eq(eye_check.m22, 1.0, 1.0e-5))
    assert_true(approx_eq(eye_check.m01, 0.0, 1.0e-5))
    assert_true(approx_eq(eye_check.m02, 0.0, 1.0e-5))
    assert_true(approx_eq(eye_check.m12, 0.0, 1.0e-5))
  }
}

///|
/// Verify Rodrigues exponential and logarithm roundtrip for 100 axis-angle vectors
test "math verification table 1 - rodrigues roundtrip grid" {
  for i in 1..<=100 {
    let scale = i.to_double() * 0.02
    let wx = @cmath.sin(scale) * scale
    let wy = @cmath.cos(scale) * scale
    let wz = @cmath.sin(scale * 0.5) * scale
    let omega = Vec3::new(wx, wy, wz)

    let rot = rodrigues_exp(omega)
    let rec_omega = rodrigues_log(rot)

    assert_true(approx_eq(rec_omega.x, omega.x, 1.0e-3))
    assert_true(approx_eq(rec_omega.y, omega.y, 1.0e-3))
    assert_true(approx_eq(rec_omega.z, omega.z, 1.0e-3))
  }
}

///|
/// Verify 3D vector cross product and triple product identities
test "math verification table 1 - vector cross and scalar triple product" {
  for i in 0..<100 {
    let u = Vec3::new(
      i.to_double() * 0.1 - 5.0,
      (i * 2).to_double() * 0.1 - 10.0,
      (i % 7).to_double() + 1.0,
    )
    let v = Vec3::new(
      (i * 3).to_double() * 0.1 - 7.0,
      i.to_double() * 0.05,
      (i % 5).to_double() + 0.5,
    )
    let w = Vec3::new(
      (i % 4).to_double() - 2.0,
      (i * 4).to_double() * 0.1 - 8.0,
      (i % 9).to_double() + 2.0,
    )

    let stp1 = u.dot(v.cross(w))
    let stp2 = v.dot(w.cross(u))
    let stp3 = w.dot(u.cross(v))
    assert_true(approx_eq(stp1, stp2, 1.0e-6))
    assert_true(approx_eq(stp2, stp3, 1.0e-6))

    let vtp = u.cross(v.cross(w))
    let vtp_rhs = v.mul_scalar(u.dot(w)).sub(w.mul_scalar(u.dot(v)))
    assert_true(approx_eq(vtp.x, vtp_rhs.x, 1.0e-5))
    assert_true(approx_eq(vtp.y, vtp_rhs.y, 1.0e-5))
    assert_true(approx_eq(vtp.z, vtp_rhs.z, 1.0e-5))
  }
}

///|
/// Generate verification table dataset for 3D point rigid transformation compositions
pub fn generate_rigid_composition_table(count : Int) -> Array[Vec3] {
  let results = []
  let mut current_pose = RigidTransform::identity()

  for i in 0..<count {
    let rot = euler_to_mat3x3(
      0.01 * i.to_double(),
      -0.005 * i.to_double(),
      0.02 * i.to_double(),
    )
    let trans = Vec3::new(
      0.1 * i.to_double(),
      -0.05 * i.to_double(),
      0.2 * i.to_double(),
    )
    let step_pose = RigidTransform::new(rot, trans)

    current_pose = RigidTransform::new(
      current_pose.rotation.mul_mat3x3(step_pose.rotation),
      current_pose.rotation
      .mul_vec3(step_pose.translation)
      .add(current_pose.translation),
    )

    let p = Vec3::new(1.0, 1.0, 1.0)
    results.push(current_pose.transform_point(p))
  }
  results
}
