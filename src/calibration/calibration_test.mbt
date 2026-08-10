///|
test "rms reprojection error calculation" {
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )
  let p1 = @math.Vec3::new(1.0, 1.0, 5.0)
  let p2 = @math.Vec3::new(-2.0, 1.5, 8.0)

  let proj1 = cam.project(p1)
  let proj2 = cam.project(p2)

  let points_3d = [p1, p2]
  let obs_pixels = [proj1.pixel, proj2.pixel]

  let rms = compute_rms_reprojection_error(cam, points_3d, obs_pixels)
  assert_true(@math.approx_eq(rms, 0.0, 0.000001))
}

///|
test "checkerboard target and intrinsic refinement" {
  let grid = generate_checkerboard_target(6, 4, 0.03)
  assert_eq(grid.length(), 24)

  let cam = @camera.PinholeCamera::new(800.0, 800.0, 640.0, 360.0, 1280.0, 720.0)
  let points_3d = [
    @math.Vec3::new(-0.5, -0.5, 3.0),
    @math.Vec3::new(0.5, -0.5, 3.0),
    @math.Vec3::new(0.5, 0.5, 3.0),
    @math.Vec3::new(-0.5, 0.5, 3.0)
  ]
  let obs_pixels = [
    cam.project(points_3d[0]).pixel,
    cam.project(points_3d[1]).pixel,
    cam.project(points_3d[2]).pixel,
    cam.project(points_3d[3]).pixel
  ]

  let cam_init = @camera.PinholeCamera::new(790.0, 800.0, 640.0, 360.0, 1280.0, 720.0)
  let cam_refined = refine_pinhole_intrinsics_lm(cam_init, points_3d, obs_pixels, 10)
  assert_true(cam_refined.fx > cam_init.fx)
}
