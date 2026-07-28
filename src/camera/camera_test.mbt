test "pinhole projection unprojection roundtrip" {
  let dist = @distortion.BrownConrady::new(0.05, -0.02, 0.001, -0.001, 0.0)
  let cam = PinholeCamera::with_distortion(
    800.0,
    800.0,
    640.0,
    360.0,
    0.0,
    1280.0,
    720.0,
    dist,
  )
  let p_3d = @math.Vec3::new(2.5, -1.8, 10.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_reconstructed = cam.unproject(proj.pixel, proj.depth)
  assert_true(@math.approx_eq(p_reconstructed.x, p_3d.x, 0.0001))
  assert_true(@math.approx_eq(p_reconstructed.y, p_3d.y, 0.0001))
  assert_true(@math.approx_eq(p_reconstructed.z, p_3d.z, 0.0001))
}
