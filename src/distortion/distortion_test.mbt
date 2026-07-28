test "brown conrady distortion roundtrip" {
  let model = BrownConrady::new(0.1, -0.05, 0.001, -0.002, 0.01)
  let p_orig = @math.Vec2::new(0.35, -0.25)
  let p_dist = model.distort(p_orig)
  let p_undist = model.undistort(p_dist, 20, 0.000001)
  assert_true(@math.approx_eq(p_undist.x, p_orig.x, 0.00001))
  assert_true(@math.approx_eq(p_undist.y, p_orig.y, 0.00001))
}

test "division model analytical roundtrip" {
  let model = DivisionModel::new(-0.15)
  let p_orig = @math.Vec2::new(0.4, 0.3)
  let p_dist = model.distort(p_orig)
  let p_undist = model.undistort(p_dist)
  assert_true(@math.approx_eq(p_undist.x, p_orig.x, 0.00001))
  assert_true(@math.approx_eq(p_undist.y, p_orig.y, 0.00001))
}

test "fov model roundtrip" {
  let model = FOVModel::new(0.9)
  let p_orig = @math.Vec2::new(0.2, -0.4)
  let p_dist = model.distort(p_orig)
  let p_undist = model.undistort(p_dist)
  assert_true(@math.approx_eq(p_undist.x, p_orig.x, 0.00001))
  assert_true(@math.approx_eq(p_undist.y, p_orig.y, 0.00001))
}
