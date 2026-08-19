// Calibration Verification Tables - Set 1: Checkerboard Target Grids and Loss Weight Curves

///|
/// Test Checkerboard 3D target coordinates generator for 50 grid configurations
test "calibration grid tables 1 - target grid dimensions" {
  for r in 2..<=6 {
    for c in 2..<=10 {
      let spacing = 0.03
      let target = generate_checkerboard_target(c, r, spacing)
      assert_eq(target.length(), c * r)

      let first_pt = target[0]
      assert_eq(first_pt.x, 0.0)
      assert_eq(first_pt.y, 0.0)
      assert_eq(first_pt.z, 0.0)

      let last_pt = target[target.length() - 1]
      let expected_x = (c - 1).to_double() * spacing
      let expected_y = (r - 1).to_double() * spacing
      assert_true(@math.approx_eq(last_pt.x, expected_x, 1.0e-5))
      assert_true(@math.approx_eq(last_pt.y, expected_y, 1.0e-5))
    }
  }
}

///|
/// Test Huber, Cauchy, and Tukey loss weight curves for 100 residual values
test "calibration grid tables 1 - loss function weights" {
  let huber = LossFunction::HuberLoss(2.0)
  let cauchy = LossFunction::CauchyLoss(2.0)
  let tukey = LossFunction::TukeyLoss(4.0)

  for i in 0..<100 {
    let residual = i.to_double() * 0.08

    let w_huber = huber.weight(residual)
    let w_cauchy = cauchy.weight(residual)
    let w_tukey = tukey.weight(residual)

    assert_true(w_huber >= 0.0 && w_huber <= 1.0)
    assert_true(w_cauchy >= 0.0 && w_cauchy <= 1.0)
    assert_true(w_tukey >= 0.0 && w_tukey <= 1.0)
  }
}
