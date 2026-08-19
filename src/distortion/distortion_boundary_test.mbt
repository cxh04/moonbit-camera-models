// Extensive Boundary Test Suite for Distortion Models and Remap LUTs

///|
/// Boundary Test: Brown-Conrady Zero Distortion Fixed Point and Origin Symmetry
test "brown conrady origin and zero distortion invariance" {
  let zero_dist = BrownConrady::zero()
  let origin = @math.Vec2::zero()
  assert_eq(zero_dist.distort(origin), origin)

  let p = @math.Vec2::new(0.5, -0.25)
  assert_eq(zero_dist.distort(p), p)
  assert_eq(zero_dist.undistort(p, 20, 1.0e-6), p)

  let dist = BrownConrady::new(0.1, -0.05, 0.001, -0.001, 0.01)
  assert_eq(dist.distort(origin), origin)
}

///|
/// Boundary Test: High-Order Distortion Jacobian and Roundtrip Convergence
test "high order distortion model boundary convergence" {
  let dist = HighOrderDistortion::zero()
  let p = @math.Vec2::new(0.3, 0.4)
  assert_eq(dist.distort(p), p)

  let j = dist.jacobian(p)
  assert_true(@math.approx_eq(j.m00, 1.0, 1.0e-4))
  assert_true(@math.approx_eq(j.m11, 1.0, 1.0e-4))
}

///|
/// Boundary Test: Equidistant Fisheye 8-Parameter Distortion Bounds
test "equidistant fisheye distortion symmetry and origin fixed point" {
  let dist = EquidistantDistortion::new(0.01, -0.002, 0.0005, -0.0001)
  let d_angle = dist.distort_angle(0.5)
  let rec_angle = dist.undistort_angle(d_angle)
  assert_true(@math.approx_eq(rec_angle, 0.5, 1.0e-4))
}

///|
/// Boundary Test: Thin Prism Distortion Misalignment Bounds
test "thin prism distortion optical tilt misalignment boundaries" {
  let dist = ThinPrismDistortion::new(0.005, -0.002, 0.001, -0.0005)
  let p = @math.Vec2::new(-0.2, 0.6)
  let d = dist.distort(p)
  assert_true(d.norm() > 0.0)
}

///|
/// Boundary Test: RemapLUT Out-Of-Bounds Grid Sampling
test "remap lut sampling boundary checks" {
  let lut = generate_remap_lut(100, 100, 50.0, 50.0, 50.0, 50.0, fn(p) { p })
  assert_eq(lut.width, 100)
  assert_eq(lut.height, 100)

  let in_bound_sample = lut.sample(50, 50).unwrap()
  assert_true(@math.approx_eq(in_bound_sample.x, 50.0, 1.0e-5))

  assert_true(lut.sample(-1, 50) is None)
  assert_true(lut.sample(100, 50) is None)
  assert_true(lut.sample(50, -5) is None)
  assert_true(lut.sample(50, 105) is None)
}
