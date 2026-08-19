// DoubleSphere, Unified, Division, FOV, Cubic, and StereoRig Verification Tables

///|
/// Verification Grid Test for Double Sphere Camera over 50 3D Grid Points
test "camera verification table 2 - double sphere 3d grid roundtrip" {
  let cam = DoubleSphereCamera::new(
    400.0, 400.0, 640.0, 360.0, -0.15, 0.55, 1280.0, 720.0,
  )

  for i in 0..<50 {
    let x = (i % 7).to_double() * 0.3 - 0.9
    let y = (i / 7 % 7).to_double() * 0.25 - 0.75
    let z = 2.0 + (i % 5).to_double() * 0.8
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 0.08))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 0.08))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 0.08))
  }
}

///|
/// Verification Grid Test for Mei Extended Unified Camera Model over 50 3D Grid Points
test "camera verification table 2 - eucm 3d grid roundtrip" {
  let cam = UnifiedCamera::new(
    420.0, 420.0, 640.0, 360.0, 0.5, 1.05, 1280.0, 720.0,
  )

  for i in 0..<50 {
    let x = (i % 7).to_double() * 0.3 - 0.9
    let y = (i / 7 % 7).to_double() * 0.25 - 0.75
    let z = 2.0 + (i % 5).to_double() * 0.8
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 0.08))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 0.08))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 0.08))
  }
}

///|
/// Verification Grid Test for Division Camera Model over 50 3D Grid Points
test "camera verification table 2 - division model 3d grid roundtrip" {
  let cam = DivisionCamera::new(
    600.0, 600.0, 320.0, 240.0, 640.0, 480.0, -0.02, 0.0005,
  )

  for i in 0..<50 {
    let x = (i % 7).to_double() * 0.2 - 0.6
    let y = (i / 7 % 7).to_double() * 0.15 - 0.45
    let z = 3.0 + (i % 5).to_double() * 1.0
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    let proj_rec = cam.project(p_rec)
    assert_true(@math.approx_eq(proj_rec.pixel.x, proj.pixel.x, 0.1))
    assert_true(@math.approx_eq(proj_rec.pixel.y, proj.pixel.y, 0.1))
  }
}

///|
/// Verification Grid Test for FOV Camera Model over 50 3D Grid Points
test "camera verification table 2 - fov model 3d grid roundtrip" {
  let cam = FOVCamera::new(600.0, 600.0, 320.0, 240.0, 640.0, 480.0, 0.4)

  for i in 0..<50 {
    let x = (i % 7).to_double() * 0.2 - 0.6
    let y = (i / 7 % 7).to_double() * 0.15 - 0.45
    let z = 3.0 + (i % 5).to_double() * 1.0
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    let proj_rec = cam.project(p_rec)
    assert_true(@math.approx_eq(proj_rec.pixel.x, proj.pixel.x, 0.1))
    assert_true(@math.approx_eq(proj_rec.pixel.y, proj.pixel.y, 0.1))
  }
}

///|
/// Verification Grid Test for Stereo Camera Rig Triangulation Depth Accuracy
test "camera verification table 2 - stereo rig depth accuracy grid" {
  let dist = @distortion.BrownConrady::identity()
  let left = PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, dist,
  )
  let right = PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, dist,
  )
  let rig = StereoCameraRig::new_parallel(left, right, 0.15)

  for i in 0..<30 {
    let depth_true = 3.0 + i.to_double() * 0.5
    let p_3d = @math.Vec3::new(0.4, -0.2, depth_true)

    let proj_l = left.project(p_3d)
    let p_right_frame = @math.Vec3::new(p_3d.x - 0.15, p_3d.y, p_3d.z)
    let proj_r = right.project(p_right_frame)

    let p_tri = rig.triangulate_pixel(proj_l.pixel, proj_r.pixel).unwrap()
    assert_true(@math.approx_eq(p_tri.z, depth_true, 0.05))
  }
}
