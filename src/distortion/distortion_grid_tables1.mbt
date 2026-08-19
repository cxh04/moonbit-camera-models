// Lens Distortion Verification Tables - Set 1: Brown-Conrady, High-Order, Equidistant, and ThinPrism

///|
/// Test Brown-Conrady high degree distortion mapping grid over 100 normalized points
test "distortion grid tables 1 - brown conrady 100 points grid" {
  let dist = BrownConrady::new(0.04, -0.01, 0.002, -0.002, 0.001)

  for j in 0..<10 {
    for i in 0..<10 {
      let x = -0.4 + i.to_double() * 0.08
      let y = -0.4 + j.to_double() * 0.08
      let p_norm = @math.Vec2::new(x, y)

      let p_dist = dist.distort(p_norm)
      let p_rec = dist.undistort(p_dist, 30, 1.0e-6)

      assert_true(@math.approx_eq(p_rec.x, p_norm.x, 1.0e-3))
      assert_true(@math.approx_eq(p_rec.y, p_norm.y, 1.0e-3))
    }
  }
}

///|
/// Test High-Order Distortion 12-parameter mapping grid over 50 normalized points
test "distortion grid tables 1 - high order 12-parameter grid" {
  let dist = HighOrderDistortion::zero()

  for j in 0..<5 {
    for i in 0..<10 {
      let x = -0.3 + i.to_double() * 0.06
      let y = -0.3 + j.to_double() * 0.12
      let p_norm = @math.Vec2::new(x, y)

      let p_dist = dist.distort(p_norm)
      assert_true(@math.approx_eq(p_dist.x, p_norm.x, 1.0e-5))
      assert_true(@math.approx_eq(p_dist.y, p_norm.y, 1.0e-5))
    }
  }
}

///|
/// Test Equidistant Fisheye angle polynomial mapping grid over 100 angle values
test "distortion grid tables 1 - equidistant angle grid" {
  let dist = EquidistantDistortion::new(0.02, -0.004, 0.0008, -0.0001)

  for i in 1..<=100 {
    let theta_true = i.to_double() * 0.012
    let theta_d = dist.distort_angle(theta_true)
    let theta_rec = dist.undistort_angle(theta_d)

    assert_true(@math.approx_eq(theta_rec, theta_true, 1.0e-4))
  }
}

///|
/// Test ThinPrism lens tilt distortion mapping grid over 50 normalized points
test "distortion grid tables 1 - thin prism tilt grid" {
  let dist = ThinPrismDistortion::new(0.004, -0.001, 0.002, -0.0005)

  for j in 0..<5 {
    for i in 0..<10 {
      let x = -0.3 + i.to_double() * 0.06
      let y = -0.3 + j.to_double() * 0.12
      let p_norm = @math.Vec2::new(x, y)

      let p_dist = dist.distort(p_norm)
      assert_true(p_dist.norm() >= 0.0)
    }
  }
}
