// Real Dataset Preset Validation and Circular Orbit Trajectory Invariants

///|
/// Test KITTI Left Stereo Pinhole Camera preset and focal length equality
test "datasets feature tables 1 - kitti stereo presets sanity" {
  let left = load_kitti_left_camera().pinhole_camera.unwrap()
  assert_eq(left.width, 1242.0)
  assert_eq(left.height, 375.0)
  assert_true(@math.approx_eq(left.fx, 721.5377, 1.0e-4))
  assert_true(@math.approx_eq(left.fy, 721.5377, 1.0e-4))
}

///|
/// Test TUM VI Double Sphere camera preset intrinsics sanity
test "datasets feature tables 1 - tum vi ds camera preset sanity" {
  let ds = load_tum_vi_ds_camera().double_sphere_camera.unwrap()
  assert_eq(ds.width, 512.0)
  assert_eq(ds.height, 512.0)
  assert_true(@math.approx_eq(ds.fx, 384.444, 1.0e-1))
  assert_true(@math.approx_eq(ds.alpha, 0.5841, 1.0e-2))
}

///|
/// Test Circular Trajectory rotation determinant det(R) == 1 for 150 camera poses
test "datasets feature tables 1 - circular trajectory rotation matrix determinant" {
  let traj = generate_circular_trajectory(150, 12.0, @math.Vec3::zero())
  assert_eq(traj.length(), 150)

  for i in 0..<150 {
    let rot = traj[i].rotation
    let det = rot.determinant()
    assert_true(@math.approx_eq(det, 1.0, 1.0e-5))
  }
}
