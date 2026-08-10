///|
test "kitti and tum vi dataset loaders" {
  let kitti = load_kitti_left_camera()
  assert_eq(kitti.name, "KITTI_Gray_Left_Cam0")
  assert_true(kitti.pinhole_camera is Some(_))

  let cam_pinhole = kitti.pinhole_camera.unwrap()
  let features = get_benchmark_3d_features()

  let mut i = 0
  while i < features.length() {
    let p3 = features[i]
    let proj = cam_pinhole.project(p3)
    let p_rec = cam_pinhole.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 0.001))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 0.001))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 0.001))
    i = i + 1
  }

  let tum_vi = load_tum_vi_ds_camera()
  assert_eq(tum_vi.name, "TUM_VI_Room1_Cam0")
  assert_true(tum_vi.double_sphere_camera is Some(_))

  let gopro = load_gopro_hero10_fisheye()
  assert_eq(gopro.name, "GoPro_Hero10_4K_Wide")
  assert_true(gopro.fisheye_camera is Some(_))

  let iphone = load_iphone15_pro_main_camera()
  assert_eq(iphone.name, "iPhone15Pro_Main_24mm")
  assert_true(iphone.pinhole_camera is Some(_))
}
