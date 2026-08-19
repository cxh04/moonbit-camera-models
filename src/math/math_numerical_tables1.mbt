// Math Numerical Verification Tables - Set 1: Vector Algebra, Cross Products, and Homogeneous Conversions

///|
/// Test 2D vector rotation, norm, and angle for 150 configurations
test "math numerical tables 1 - 2d vector rotation grid" {
  for i in 0..<150 {
    let angle = i.to_double() * 0.041887902047863905 - 3.141592653589793
    let cos_a = @cmath.cos(angle)
    let sin_a = @cmath.sin(angle)
    let v = Vec2::new(cos_a, sin_a)

    assert_true(approx_eq(v.norm(), 1.0, 1.0e-6))
    assert_true(approx_eq(v.dot(v), 1.0, 1.0e-6))

    let v_rot = Vec2::new(v.x * cos_a - v.y * sin_a, v.x * sin_a + v.y * cos_a)
    assert_true(approx_eq(v_rot.norm(), 1.0, 1.0e-6))
  }
}

///|
/// Test 3D vector projection and rejection for 150 spatial vectors
test "math numerical tables 1 - 3d projection and rejection" {
  for i in 0..<150 {
    let ux = i.to_double() * 0.1 - 7.5
    let uy = (i * 2).to_double() * 0.1 - 15.0
    let uz = (i % 9).to_double() + 1.0
    let u = Vec3::new(ux, uy, uz)

    let normal = Vec3::new(0.0, 0.0, 1.0)
    let proj = u.project_onto(normal)
    let rej = u.reject_from(normal)

    let sum = proj.add(rej)
    assert_true(approx_eq(sum.x, u.x, 1.0e-6))
    assert_true(approx_eq(sum.y, u.y, 1.0e-6))
    assert_true(approx_eq(sum.z, u.z, 1.0e-6))
    assert_true(approx_eq(proj.dot(rej), 0.0, 1.0e-6))
  }
}

///|
/// Test 4D homogeneous point-to-vector and vector-to-point transformations for 150 cases
test "math numerical tables 1 - 4d homogeneous transformation grid" {
  for i in 0..<150 {
    let x = i.to_double() * 0.2 - 15.0
    let y = (i * 3).to_double() * 0.1 - 22.5
    let z = (i % 11).to_double() * 0.5 + 0.5
    let w = (i % 5).to_double() + 1.0

    let v4 = Vec4::new(x * w, y * w, z * w, w)
    let v3 = v4.to_vec3_homogeneous()

    assert_true(approx_eq(v3.x, x, 1.0e-5))
    assert_true(approx_eq(v3.y, y, 1.0e-5))
    assert_true(approx_eq(v3.z, z, 1.0e-5))
  }
}

///|
/// Function generating 3D vector scalar triple product table
pub fn get_scalar_triple_product_sample(index : Int) -> Double {
  let u = Vec3::new(index.to_double() * 0.1, -index.to_double() * 0.05, 1.0)
  let v = Vec3::new(1.0, index.to_double() * 0.2, -0.5)
  let w = Vec3::new(-0.5, 1.0, index.to_double() * 0.1)
  u.dot(v.cross(w))
}
