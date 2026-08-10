///|
test "brown conrady distortion roundtrip" {
  let model = BrownConrady::new(0.1, -0.05, 0.001, -0.002, 0.01)
  let p_orig = @math.Vec2::new(0.35, -0.25)
  let p_dist = model.distort(p_orig)
  let p_undist = model.undistort(p_dist, 20, 0.000001)
  assert_true(@math.approx_eq(p_undist.x, p_orig.x, 0.00001))
  assert_true(@math.approx_eq(p_undist.y, p_orig.y, 0.00001))
}

///|
test "division model analytical roundtrip" {
  let model = DivisionModel::new(-0.15)
  let p_orig = @math.Vec2::new(0.4, 0.3)
  let p_dist = model.distort(p_orig)
  let p_undist = model.undistort(p_dist)
  assert_true(@math.approx_eq(p_undist.x, p_orig.x, 0.00001))
  assert_true(@math.approx_eq(p_undist.y, p_orig.y, 0.00001))
}

///|
test "fov model roundtrip" {
  let model = FOVModel::new(0.9)
  let p_orig = @math.Vec2::new(0.2, -0.4)
  let p_dist = model.distort(p_orig)
  let p_undist = model.undistort(p_dist)
  assert_true(@math.approx_eq(p_undist.x, p_orig.x, 0.00001))
  assert_true(@math.approx_eq(p_undist.y, p_orig.y, 0.00001))
}

///|
test "thin prism and equidistant distortion models" {
  let thin_prism = ThinPrismDistortion::new(0.002, -0.0005, 0.001, -0.0002)
  let p_orig = @math.Vec2::new(0.5, 0.5)
  let p_dist = thin_prism.distort(p_orig)
  assert_true(p_dist.x > p_orig.x)

  let equi = EquidistantDistortion::new(0.01, -0.002, 0.0003, -0.00005)
  let theta = 0.45
  let theta_d = equi.distort_angle(theta)
  let theta_undist = equi.undistort_angle(theta_d)
  assert_true(@math.approx_eq(theta_undist, theta, 0.000001))
}
