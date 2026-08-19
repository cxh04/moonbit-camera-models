// Integration Facade and End-to-End Workflow Verification Tables

///|
/// Verification Test for End-to-End Projection, Distortion, Unprojection, and Calibration Accuracy Pipeline
test "lib verification table 1 - end to end pipeline verification" {
  let p = @math.Vec3::new(2.0, -1.0, 6.0)
  let (u, v, err_x, err_y, err_z) = demo_projection_pipeline(p)

  assert_true(u > 0.0)
  assert_true(v > 0.0)
  assert_true(err_x < 1.0e-4)
  assert_true(err_y < 1.0e-4)
  assert_true(err_z < 1.0e-4)

  let cam = create_standard_fhd_camera()
  let rms = evaluate_benchmark_accuracy(cam)
  assert_true(rms >= 0.0)
}

///|
/// Verification Test for Package Facade Symbol Linkage Invariants
test "lib verification table 1 - facade linkage check" {
  assert_true(facade_link_all())
}
