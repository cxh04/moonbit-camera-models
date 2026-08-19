// Target Generation, Robust Loss Functions, and Reprojection Metrics Verification Tables

///|
/// Verification Grid Test for Checkerboard 3D Target Coordinates over 10 Target Grids
test "calibration verification table 1 - target grid dimensions" {
  for r in 2..<=10 {
    for c in 2..<=10 {
      let spacing = 0.025
      let target = generate_checkerboard_target(c, r, spacing)
      assert_eq(target.length(), c * r)

      let last_pt = target[target.length() - 1]
      let expected_x = (c - 1).to_double() * spacing
      let expected_y = (r - 1).to_double() * spacing
      assert_true(@math.approx_eq(last_pt.x, expected_x, 1.0e-5))
      assert_true(@math.approx_eq(last_pt.y, expected_y, 1.0e-5))
    }
  }
}

///|
/// Verification Grid Test for Huber, Cauchy, Tukey Robust Loss Weight Curves
test "calibration verification table 1 - robust loss weight attenuation curves" {
  let huber = LossFunction::HuberLoss(1.5)
  let cauchy = LossFunction::CauchyLoss(1.5)
  let tukey = LossFunction::TukeyLoss(3.0)

  for i in 0..<50 {
    let residual = i.to_double() * 0.1

    let w_huber = huber.weight(residual)
    let w_cauchy = cauchy.weight(residual)
    let w_tukey = tukey.weight(residual)

    assert_true(w_huber >= 0.0 && w_huber <= 1.0)
    assert_true(w_cauchy >= 0.0 && w_cauchy <= 1.0)
    assert_true(w_tukey >= 0.0 && w_tukey <= 1.0)
  }
}

///|
/// Verification Grid Test for Reprojection Error Metrics (RMS, Mean, StdDev, Max)
test "calibration verification table 1 - reprojection metrics statistical properties" {
  let projected = []
  let observed = []

  for i in 0..<50 {
    let u = 100.0 + i.to_double() * 10.0
    let v = 100.0 + i.to_double() * 5.0
    projected.push(@math.Vec2::new(u, v))

    // Inject 0.5px offset
    observed.push(@math.Vec2::new(u + 0.5, v))
  }

  let metrics = compute_reprojection_metrics(projected, observed)
  assert_eq(metrics.total_points, 50)
  assert_true(@math.approx_eq(metrics.mean_error, 0.5, 1.0e-4))
  assert_true(@math.approx_eq(metrics.rms_error, 0.5, 1.0e-4))
  assert_true(@math.approx_eq(metrics.max_error, 0.5, 1.0e-4))
}
