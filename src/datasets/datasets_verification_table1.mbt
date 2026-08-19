// Datasets Preset & Synthetic Trajectory Verification Tables

///|
/// Verification Test for Real Dataset Camera Intrinsics Aspect Ratio and Focal Length Sanity
test "datasets verification table 1 - real camera presets aspect ratio and fov" {
  let kitti = load_kitti_left_camera().pinhole_camera.unwrap()
  assert_true(@math.approx_eq(kitti.fx, kitti.fy, 1.0e-3))
  assert_true(kitti.cx > 0.0 && kitti.cx < kitti.width)
  assert_true(kitti.cy > 0.0 && kitti.cy < kitti.height)

  let iphone = load_iphone15_pro_main_camera().pinhole_camera.unwrap()
  assert_true(@math.approx_eq(iphone.fx, iphone.fy, 1.0e-3))
  assert_true(iphone.cx > 0.0 && iphone.cx < iphone.width)

  let tum = load_tum_vi_ds_camera().double_sphere_camera.unwrap()
  assert_true(tum.fx > 0.0)
  assert_true(tum.fy > 0.0)

  let gopro = load_gopro_hero10_fisheye().fisheye_camera.unwrap()
  assert_true(gopro.fx > 0.0)
  assert_true(gopro.fy > 0.0)
}

///|
/// Verification Test for Synthetic Circular Orbit Trajectory Orthonormality over 100 Poses
test "datasets verification table 1 - circular trajectory pose orthonormality" {
  let traj = generate_circular_trajectory(100, 15.0, @math.Vec3::zero())
  assert_eq(traj.length(), 100)

  for i in 0..<100 {
    let pose = traj[i]
    let rot = pose.rotation
    let det = rot.determinant()
    assert_true(@math.approx_eq(det, 1.0, 1.0e-5))

    let eye_check = rot.mul_mat3x3(rot.transpose())
    assert_true(@math.approx_eq(eye_check.m00, 1.0, 1.0e-5))
    assert_true(@math.approx_eq(eye_check.m11, 1.0, 1.0e-5))
    assert_true(@math.approx_eq(eye_check.m22, 1.0, 1.0e-5))
  }
}
