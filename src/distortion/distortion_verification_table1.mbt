// Brown-Conrady, Equidistant, ThinPrism, and RemapLUT Verification Tables

///|
/// Verification Grid Test for Brown-Conrady Radial-Tangential Distort and Undistort
test "distortion verification table 1 - brown conrady grid roundtrip" {
  let dist = BrownConrady::new(0.05, -0.01, 0.001, -0.001, 0.002)

  for i in 0..<100 {
    let x = (i % 10).to_double() * 0.1 - 0.45
    let y = (i / 10 % 10).to_double() * 0.1 - 0.45
    let p_norm = @math.Vec2::new(x, y)

    let p_dist = dist.distort(p_norm)
    let p_rec = dist.undistort(p_dist, 30, 1.0e-6)

    assert_true(@math.approx_eq(p_rec.x, p_norm.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p_norm.y, 1.0e-3))
  }
}

///|
/// Verification Grid Test for Equidistant Fisheye Angle Mapping over 100 Theta Angles
test "distortion verification table 1 - equidistant fisheye angle grid" {
  let dist = EquidistantDistortion::new(0.015, -0.003, 0.0006, -0.0001)

  for i in 1..<=100 {
    let theta_true = i.to_double() * 0.015
    let theta_d = dist.distort_angle(theta_true)
    let theta_rec = dist.undistort_angle(theta_d)

    assert_true(@math.approx_eq(theta_rec, theta_true, 1.0e-4))
  }
}

///|
/// Verification Grid Test for ThinPrism Lens Distortion Misalignment Mapping
test "distortion verification table 1 - thin prism grid evaluation" {
  let dist = ThinPrismDistortion::new(0.003, -0.001, 0.002, -0.0005)

  for i in 0..<50 {
    let x = (i % 7).to_double() * 0.1 - 0.3
    let y = (i / 7 % 7).to_double() * 0.1 - 0.3
    let p_norm = @math.Vec2::new(x, y)

    let p_dist = dist.distort(p_norm)
    assert_true(p_dist.norm() >= p_norm.norm() * 0.9)
  }
}

///|
/// Verification Grid Test for RemapLUT Interpolation Accuracy over 10x10 Pixel Grid
test "distortion verification table 1 - remap lut sampling grid accuracy" {
  let lut = generate_remap_lut(10, 10, 100.0, 100.0, 500.0, 500.0, fn(p) { p })

  for j in 0..<10 {
    for i in 0..<10 {
      let pt = lut.sample(i, j).unwrap()
      let expected_x = 100.0 * (i.to_double() - 500.0) / 100.0 + 500.0
      let expected_y = 100.0 * (j.to_double() - 500.0) / 100.0 + 500.0
      assert_true(@math.approx_eq(pt.x, expected_x, 1.0e-5))
      assert_true(@math.approx_eq(pt.y, expected_y, 1.0e-5))
    }
  }
}
