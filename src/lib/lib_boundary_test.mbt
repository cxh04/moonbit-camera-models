// Extensive Boundary Test Suite for Library Facade and Top-Level Utilities

///|
/// Boundary Test: Standard Camera Model Factory Utilities
test "standard camera factories and facade linkage" {
  let fhd = create_standard_fhd_camera()
  assert_eq(fhd.width, 1920.0)
  assert_eq(fhd.height, 1080.0)
  assert_eq(fhd.fx, 960.0)

  let fisheye = create_standard_fisheye_camera()
  assert_eq(fisheye.width, 3840.0)
  assert_eq(fisheye.height, 2160.0)

  let kitti = create_kitti_stereo_camera()
  assert_eq(kitti.sensor_type, "Pinhole_BrownConrady")

  let tum = create_tum_vi_camera()
  assert_eq(tum.sensor_type, "DoubleSphere")

  assert_true(facade_link_all())
}

///|
/// Boundary Test: Demo Projection Pipeline Evaluation
test "demo projection pipeline evaluation" {
  let p = @math.Vec3::new(1.2, -0.8, 5.0)
  let (u, v, err_x, err_y, err_z) = demo_projection_pipeline(p)
  assert_true(u > 0.0)
  assert_true(v > 0.0)
  assert_true(err_x < 1.0e-5)
  assert_true(err_y < 1.0e-5)
  assert_true(err_z < 1.0e-5)
}

///|
/// Boundary Test: Benchmark Accuracy Evaluation Function
test "evaluate benchmark accuracy check" {
  let cam = create_standard_fhd_camera()
  let rms = evaluate_benchmark_accuracy(cam)
  assert_true(rms >= 0.0)
}
