// Extensive Boundary Test Suite for All Camera Models

///|
/// Boundary Test: Pinhole Camera Edge & Singular Cases
test "pinhole camera boundary edge cases" {
  let dist = @distortion.BrownConrady::zero()
  let cam = PinholeCamera::with_distortion(
    500.0, 500.0, 320.0, 240.0, 0.0, 640.0, 480.0, dist,
  )

  // Point behind camera (z <= 0)
  let p_behind = @math.Vec3::new(1.0, 2.0, 0.0)
  let proj_behind = cam.project(p_behind)
  assert_false(proj_behind.in_fov)

  let p_neg_z = @math.Vec3::new(1.0, 2.0, -5.0)
  let proj_neg = cam.project(p_neg_z)
  assert_false(proj_neg.in_fov)

  // Image center point (0, 0, z)
  let p_center = @math.Vec3::new(0.0, 0.0, 10.0)
  let proj_center = cam.project(p_center)
  assert_true(proj_center.in_fov)
  assert_true(@math.approx_eq(proj_center.pixel.x, 320.0, 1.0e-5))
  assert_true(@math.approx_eq(proj_center.pixel.y, 240.0, 1.0e-5))

  // Corner pixel unprojections
  let corner_tl = cam.unproject(@math.Vec2::new(0.0, 0.0), 10.0)
  let corner_br = cam.unproject(@math.Vec2::new(640.0, 480.0), 10.0)
  assert_true(corner_tl.x < 0.0)
  assert_true(corner_tl.y < 0.0)
  assert_true(corner_br.x > 0.0)
  assert_true(corner_br.y > 0.0)
}

///|
/// Boundary Test: FOV & View Frustum Calculation Checks
test "pinhole camera fov and view frustum bounds" {
  let cam = PinholeCamera::new(960.0, 960.0, 960.0, 540.0, 1920.0, 1080.0)
  let h_fov = cam.horizontal_fov()
  let v_fov = cam.vertical_fov()
  let d_fov = cam.diagonal_fov()

  assert_true(h_fov > 85.0 && h_fov < 95.0)
  assert_true(v_fov > 55.0 && v_fov < 65.0)
  assert_true(d_fov > h_fov)

  let frustum = cam.compute_view_frustum(0.1, 100.0)
  assert_true(frustum.contains_point(@math.Vec3::new(0.0, 0.0, 5.0)))
  assert_false(frustum.contains_point(@math.Vec3::new(0.0, 0.0, 150.0)))
}

///|
/// Boundary Test: Fisheye Camera Extreme FOV Angle Tests
test "fisheye camera extreme wide-angle boundary cases" {
  let cam = FisheyeCamera::new(
    300.0, 300.0, 640.0, 360.0, 0.02, -0.005, 0.001, -0.0001, 1280.0, 720.0,
  )

  // Near 90-degree off-axis point
  let p_wide = @math.Vec3::new(10.0, 0.0, 0.1)
  let proj_wide = cam.project(p_wide)
  assert_true(proj_wide.depth > 0.0)

  let ray_rec = cam.unproject(proj_wide.pixel, proj_wide.depth)
  assert_true(ray_rec.x > 0.0)
}

///|
/// Boundary Test: Equirectangular Spherical Mapping Poles and Antimeridian
test "equirectangular panorama poles and antimeridian boundary" {
  let cam = EquirectangularCamera::new(3600.0, 1800.0)

  // North pole (0, Y, 0)
  let p_north = @math.Vec3::new(0.0, 5.0, 0.0)
  let proj_north = cam.project(p_north)
  assert_true(@math.approx_eq(proj_north.pixel.y, 1800.0, 1.0e-4))

  // South pole (0, -Y, 0)
  let p_south = @math.Vec3::new(0.0, -5.0, 0.0)
  let proj_south = cam.project(p_south)
  assert_true(@math.approx_eq(proj_south.pixel.y, 0.0, 1.0e-4))

  // Antimeridian (-X, 0, -Z)
  let p_anti = @math.Vec3::new(-0.001, 0.0, -5.0)
  let proj_anti = cam.project(p_anti)
  assert_true(proj_anti.in_fov)
}

///|
/// Boundary Test: Cubemap Face Boundary Transitions
test "cubic panorama 6-face mapping boundary transitions" {
  let cam = CubicPanoramaCamera::new(512.0)

  let p_front = @math.Vec3::new(0.0, 0.0, 10.0)
  let (f_front, _) = cam.project_to_face(p_front)
  assert_eq(f_front, CubeFace::Front)

  let p_back = @math.Vec3::new(0.0, 0.0, -10.0)
  let (f_back, _) = cam.project_to_face(p_back)
  assert_eq(f_back, CubeFace::Back)

  let p_top = @math.Vec3::new(0.0, 10.0, 0.0)
  let (f_top, _) = cam.project_to_face(p_top)
  assert_eq(f_top, CubeFace::Top)

  let p_bottom = @math.Vec3::new(0.0, -10.0, 0.0)
  let (f_bottom, _) = cam.project_to_face(p_bottom)
  assert_eq(f_bottom, CubeFace::Bottom)
}

///|
/// Boundary Test: Scaramuzza Omnidirectional Polynomial Model
test "scaramuzza camera polynomial unprojection bounds" {
  let cam = ScaramuzzaCamera::new(
    320.0, 240.0, 1.0, 0.0, 0.0, -100.0, 0.0, 0.001, 0.0, 0.00001, 640.0, 480.0,
  )
  let center_pixel = @math.Vec2::new(320.0, 240.0)
  let ray_center = cam.unproject(center_pixel, 1.0)
  assert_true(@math.approx_eq(ray_center.x, 0.0, 1.0e-5))
  assert_true(@math.approx_eq(ray_center.y, 0.0, 1.0e-5))
}
