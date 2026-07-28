///|
test "vec2 operations" {
  let v1 = Vec2::new(3.0, 4.0)
  let v2 = Vec2::new(1.0, 2.0)
  assert_eq(v1.norm(), 5.0)
  assert_eq(v1.dot(v2), 11.0)
  let norm_v1 = v1.normalized()
  assert_true(approx_eq(norm_v1.norm(), 1.0, 0.000001))
}

///|
test "vec3 cross product and distance" {
  let vx = Vec3::unit_x()
  let vy = Vec3::unit_y()
  let vz = vx.cross(vy)
  assert_eq(vz, Vec3::unit_z())
  let p1 = Vec3::new(1.0, 2.0, 3.0)
  let p2 = Vec3::new(4.0, 6.0, 3.0)
  assert_eq(p1.distance(p2), 5.0)
}

///|
test "mat3x3 identity and inverse" {
  let m = Mat3x3::identity()
  let v = Vec3::new(2.5, -3.0, 7.1)
  assert_eq(m.mul_vec3(v), v)
  let inv = m.inverse().unwrap()
  assert_eq(inv, m)
}

///|
test "rigid transform SE3" {
  let r = Mat3x3::identity()
  let t = Vec3::new(10.0, -5.0, 2.0)
  let se3 = RigidTransform::new(r, t)
  let p = Vec3::new(1.0, 2.0, 3.0)
  let p_trans = se3.transform_point(p)
  assert_eq(p_trans, Vec3::new(11.0, -3.0, 5.0))
  let se3_inv = se3.inverse()
  let p_back = se3_inv.transform_point(p_trans)
  assert_true(approx_eq(p_back.x, p.x, 0.000001))
  assert_true(approx_eq(p_back.y, p.y, 0.000001))
  assert_true(approx_eq(p_back.z, p.z, 0.000001))
}
