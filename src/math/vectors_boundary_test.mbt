// Extensive Boundary Test Suite for 2D, 3D, and 4D Vector Operations

///|
/// Boundary Test: Vec2 Zero Norm, Normalization, and Rotation Limits
test "vec2 boundary cases zero and extreme values" {
  let z = Vec2::zero()
  assert_eq(z.norm(), 0.0)
  assert_eq(z.normalized(), Vec2::zero())
  assert_eq(z.dot(z), 0.0)
  assert_eq(z.cross(z), 0.0)
  assert_eq(z.angle(z), 0.0)

  let v = Vec2::new(1.0e10, -2.0e10)
  let norm_v = v.normalized()
  assert_true(approx_eq(norm_v.norm(), 1.0, 1.0e-9))

  let small = Vec2::new(1.0e-10, 1.0e-10)
  assert_true(small.norm() > 0.0)
  assert_true(approx_eq(small.normalized().norm(), 1.0, 1.0e-9))

  let col1 = Vec2::new(2.0, 4.0)
  let col2 = Vec2::new(4.0, 8.0)
  assert_true(approx_eq(col1.cross(col2), 0.0, 1.0e-9))
  assert_true(approx_eq(col1.angle(col2), 0.0, 1.0e-6))

  let opp1 = Vec2::new(1.0, 0.0)
  let opp2 = Vec2::new(-1.0, 0.0)
  assert_true(approx_eq(opp1.angle(opp2), 3.141592653589793, 1.0e-6))
}

///|
/// Boundary Test: Vec3 Zero Norm, Cross Product, Slerp, Reflection, Projection
test "vec3 boundary cases and projection operators" {
  let z = Vec3::zero()
  assert_eq(z.norm(), 0.0)
  assert_eq(z.normalized(), Vec3::zero())
  assert_eq(z.cross(Vec3::unit_x()), Vec3::zero())

  let p = Vec3::new(3.0, 4.0, 5.0)
  let proj_x = p.project_onto(Vec3::unit_x())
  assert_eq(proj_x, Vec3::new(3.0, 0.0, 0.0))

  let rej_x = p.reject_from(Vec3::unit_x())
  assert_eq(rej_x, Vec3::new(0.0, 4.0, 5.0))

  let inc = Vec3::new(1.0, -1.0, 0.0)
  let n = Vec3::unit_y()
  let refl = inc.reflect(n)
  assert_true(approx_eq(refl.x, 1.0, 1.0e-6))
  assert_true(approx_eq(refl.y, 1.0, 1.0e-6))

  let vx = Vec3::unit_x()
  let vy = Vec3::unit_y()
  let s0 = vx.slerp(vy, 0.0)
  let s1 = vx.slerp(vy, 1.0)
  assert_true(approx_eq(s0.x, 1.0, 1.0e-6))
  assert_true(approx_eq(s1.y, 1.0, 1.0e-6))

  let slerp_same = vx.slerp(vx, 0.5)
  assert_true(approx_eq(slerp_same.x, 1.0, 1.0e-6))
}

///|
/// Boundary Test: Vec4 Homogeneous Coordinate Conversions
test "vec4 boundary homogeneous coordinates" {
  let v4_point = Vec4::new(4.0, 8.0, 12.0, 2.0)
  let v3_point = v4_point.to_vec3_homogeneous()
  assert_eq(v3_point, Vec3::new(2.0, 4.0, 6.0))

  let v4_dir = Vec4::new(4.0, 8.0, 12.0, 0.0)
  let v3_dir = v4_dir.to_vec3_homogeneous()
  assert_eq(v3_dir, Vec3::new(4.0, 8.0, 12.0))

  let v3_orig = Vec3::new(1.5, 2.5, 3.5)
  let p_conv = v3_orig.to_vec4_point()
  let v_conv = v3_orig.to_vec4_vector()
  assert_eq(p_conv.w, 1.0)
  assert_eq(v_conv.w, 0.0)
}

///|
/// Comprehensive Vector Algebra Invariants Suite (100 Grid Points)
test "vec3 algebraic invariants over 3d spatial grid" {
  let mut i = 0
  while i < 100 {
    let x = (i % 10).to_double() - 5.0
    let y = (i / 10 % 10).to_double() - 5.0
    let z = (i % 7).to_double() + 1.0
    let v = Vec3::new(x, y, z)

    // Vector self-cross product is zero
    let cross_self = v.cross(v)
    assert_true(approx_eq(cross_self.norm(), 0.0, 1.0e-9))

    // Norm of normalized vector is 1
    let v_norm = v.normalized()
    assert_true(approx_eq(v_norm.norm(), 1.0, 1.0e-9))

    // Triangle inequality |u + v| <= |u| + |v|
    let u = Vec3::new(y, z, x)
    let sum_norm = v.add(u).norm()
    let triangle_bound = v.norm() + u.norm()
    assert_true(sum_norm <= triangle_bound + 1.0e-9)

    i = i + 1
  }
}
