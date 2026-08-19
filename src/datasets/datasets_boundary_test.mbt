// Extensive Boundary Test Suite for Real and Synthetic Calibration Datasets

///|
/// Boundary Test: Verify Preset Real-World Dataset Parameters and Model Existence
test "real dataset presets validity and parameter sanity" {
  let kitti = load_kitti_left_camera()
  assert_eq(kitti.sensor_type, "Pinhole_BrownConrady")
  let kitti_cam = kitti.pinhole_camera.unwrap()
  assert_true(kitti_cam.fx > 700.0)
  assert_eq(kitti_cam.width, 1242.0)
  assert_eq(kitti_cam.height, 375.0)

  let tum_vi = load_tum_vi_ds_camera()
  assert_eq(tum_vi.sensor_type, "DoubleSphere")
  let tum_cam = tum_vi.double_sphere_camera.unwrap()
  assert_true(tum_cam.fx > 350.0)

  let gopro = load_gopro_hero10_fisheye()
  assert_eq(gopro.sensor_type, "KannalaBrandt_Fisheye")
  let gopro_cam = gopro.fisheye_camera.unwrap()
  assert_eq(gopro_cam.width, 3840.0)

  let iphone = load_iphone15_pro_main_camera()
  assert_eq(iphone.sensor_type, "Pinhole_BrownConrady")
  let iphone_cam = iphone.pinhole_camera.unwrap()
  assert_eq(iphone_cam.width, 4032.0)

  let benchmark_features = get_benchmark_3d_features()
  assert_true(benchmark_features.length() >= 8)
}

///|
/// Boundary Test: Synthetic Point Cloud & Trajectory Generators
test "synthetic dataset generators boundary checks" {
  let pts = generate_synthetic_point_cloud(4, 4, 5.0, 0.5)
  assert_eq(pts.length(), 16)
  for i in 0..<pts.length() {
    assert_eq(pts[i].z, 5.0)
  }

  let traj = generate_circular_trajectory(12, 10.0, @math.Vec3::zero())
  assert_eq(traj.length(), 12)
  for i in 0..<traj.length() {
    let r = traj[i].rotation
    assert_true(@math.approx_eq(r.determinant(), 1.0, 1.0e-5))
  }
}
