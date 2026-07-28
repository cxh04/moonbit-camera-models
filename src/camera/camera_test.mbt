///|
test "pinhole projection unprojection roundtrip" {
  let dist = @distortion.BrownConrady::new(0.05, -0.02, 0.001, -0.001, 0.0)
  let cam = PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )
  let p_3d = @math.Vec3::new(2.5, -1.8, 10.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_reconstructed = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_reconstructed.x, p_3d.x, 0.0001))
  assert_true(@math.approx_eq(p_reconstructed.y, p_3d.y, 0.0001))
  assert_true(@math.approx_eq(p_reconstructed.z, p_3d.z, 0.0001))
}

///|
test "fisheye projection roundtrip" {
  let cam = FisheyeCamera::new(
    400.0, 400.0, 640.0, 360.0, 0.01, -0.005, 0.001, -0.0002, 1280.0, 720.0,
  )
  let p_3d = @math.Vec3::new(1.2, 0.8, 4.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_rec.x, p_3d.x, 0.0001))
  assert_true(@math.approx_eq(p_rec.y, p_3d.y, 0.0001))
  assert_true(@math.approx_eq(p_rec.z, p_3d.z, 0.0001))
}

///|
test "equirectangular roundtrip" {
  let cam = EquirectangularCamera::new(1920.0, 960.0)
  let p_3d = @math.Vec3::new(-3.0, 2.0, 5.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_rec.x, p_3d.x, 0.0001))
  assert_true(@math.approx_eq(p_rec.y, p_3d.y, 0.0001))
  assert_true(@math.approx_eq(p_rec.z, p_3d.z, 0.0001))
}

///|
test "orthographic roundtrip" {
  let cam = OrthographicCamera::new(100.0, 100.0, 500.0, 500.0, 1000.0, 1000.0)
  let p_3d = @math.Vec3::new(2.0, -3.5, 12.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_rec.x, p_3d.x, 0.0001))
  assert_true(@math.approx_eq(p_rec.y, p_3d.y, 0.0001))
  assert_true(@math.approx_eq(p_rec.z, p_3d.z, 0.0001))
}

///|
test "double sphere roundtrip" {
  let cam = DoubleSphereCamera::new(
    300.0, 300.0, 640.0, 360.0, -0.18, 0.58, 1280.0, 720.0,
  )
  let p_3d = @math.Vec3::new(0.5, -0.4, 2.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_rec.x, p_3d.x, 0.05))
  assert_true(@math.approx_eq(p_rec.y, p_3d.y, 0.05))
  assert_true(@math.approx_eq(p_rec.z, p_3d.z, 0.05))
}

///|
test "unified camera model roundtrip" {
  let cam = UnifiedCamera::new(
    350.0, 350.0, 640.0, 360.0, 0.55, 1.1, 1280.0, 720.0,
  )
  let p_3d = @math.Vec3::new(-0.6, 0.3, 2.5)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_rec.x, p_3d.x, 0.05))
  assert_true(@math.approx_eq(p_rec.y, p_3d.y, 0.05))
  assert_true(@math.approx_eq(p_rec.z, p_3d.z, 0.05))
}
