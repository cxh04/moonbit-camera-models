// Extensive Boundary Test Suite for Calibration Targets and LM Intrinsics Optimizer

///|
/// Boundary Test: Checkerboard Target Generator Dimensions & Spacing
test "checkerboard target generator bounds" {
  let target_small = generate_checkerboard_target(2, 2, 0.05)
  assert_eq(target_small.length(), 4)
  assert_eq(target_small[0], @math.Vec3::new(0.0, 0.0, 0.0))
  assert_eq(target_small[1], @math.Vec3::new(0.05, 0.0, 0.0))
  assert_eq(target_small[2], @math.Vec3::new(0.0, 0.05, 0.0))
  assert_eq(target_small[3], @math.Vec3::new(0.05, 0.05, 0.0))

  let target_grid = generate_checkerboard_target(10, 8, 0.02)
  assert_eq(target_grid.length(), 80)
}

///|
/// Boundary Test: Robust Loss Function Weights (Huber, Cauchy, Tukey)
test "robust loss function weights boundary evaluations" {
  let l2 = LossFunction::L2Loss
  assert_eq(l2.weight(0.0), 1.0)
  assert_eq(l2.weight(10.0), 1.0)

  let huber = LossFunction::HuberLoss(1.0)
  assert_eq(huber.weight(0.5), 1.0)
  assert_eq(huber.weight(2.0), 0.5)

  let cauchy = LossFunction::CauchyLoss(1.0)
  assert_eq(cauchy.weight(0.0), 1.0)
  assert_true(cauchy.weight(2.0) < 1.0)

  let tukey = LossFunction::TukeyLoss(1.0)
  assert_eq(tukey.weight(0.0), 1.0)
  assert_eq(tukey.weight(2.0), 0.0)
}

///|
/// Boundary Test: Levenberg-Marquardt Intrinsics Refinement Convergence
test "lm intrinsics refinement convergence bounds" {
  let dist = @distortion.BrownConrady::zero()
  let true_cam = @camera.PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )
  let init_cam = @camera.PinholeCamera::with_distortion(
    750.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )

  let target_3d = generate_checkerboard_target(5, 5, 0.1)
  let obs_pixels = []
  for i in 0..<target_3d.length() {
    let p3 = @math.Vec3::new(target_3d[i].x - 0.2, target_3d[i].y - 0.2, 2.0)
    obs_pixels.push(true_cam.project(p3).pixel)
  }

  let refined_cam = refine_pinhole_intrinsics_lm(
    init_cam, target_3d, obs_pixels, 20,
  )
  assert_true(refined_cam.fx > 0.0)
}

///|
/// Boundary Test: Reprojection Quality Metrics Calculation
test "reprojection metrics quality calculation" {
  let proj = [@math.Vec2::new(10.0, 10.0), @math.Vec2::new(20.0, 20.0)]
  let obs = [@math.Vec2::new(10.0, 10.0), @math.Vec2::new(20.0, 20.0)]

  let metrics_exact = compute_reprojection_metrics(proj, obs)
  assert_eq(metrics_exact.total_points, 2)
  assert_eq(metrics_exact.rms_error, 0.0)
  assert_eq(metrics_exact.max_error, 0.0)

  let obs_noise = [@math.Vec2::new(13.0, 14.0), @math.Vec2::new(20.0, 20.0)]
  let metrics_noise = compute_reprojection_metrics(proj, obs_noise)
  assert_true(metrics_noise.rms_error > 0.0)
  assert_true(metrics_noise.max_error >= 5.0)
}
