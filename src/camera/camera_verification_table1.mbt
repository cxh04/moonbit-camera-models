// Comprehensive Projection and Ray Unprojection Verification Grids across Camera Models

///|
/// Verification Grid Test for Pinhole Camera over 100 3D Grid Points
test "camera verification table 1 - pinhole 3d grid roundtrip" {
  let dist = @distortion.BrownConrady::new(0.01, -0.002, 0.0001, -0.0001, 0.0)
  let cam = PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, dist,
  )

  for i in 0..<100 {
    let x = (i % 10).to_double() * 0.4 - 1.8
    let y = (i / 10 % 10).to_double() * 0.3 - 1.35
    let z = 3.0 + (i % 5).to_double() * 1.5
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 1.0e-3))
  }
}

///|
/// Verification Grid Test for Fisheye Kannala-Brandt Camera over 100 3D Points
test "camera verification table 1 - fisheye 3d grid roundtrip" {
  let cam = FisheyeCamera::new(
    450.0, 450.0, 640.0, 360.0, 0.012, -0.003, 0.0004, -0.00005, 1280.0, 720.0,
  )

  for i in 0..<100 {
    let x = (i % 10).to_double() * 0.5 - 2.25
    let y = (i / 10 % 10).to_double() * 0.4 - 1.8
    let z = 2.5 + (i % 5).to_double() * 1.0
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 1.0e-3))
  }
}

///|
/// Verification Grid Test for Equirectangular Panorama Camera over 100 Spherical Directions
test "camera verification table 1 - equirectangular spherical grid roundtrip" {
  let cam = EquirectangularCamera::new(2048.0, 1024.0)

  for i in 0..<100 {
    let theta = (i % 10).to_double() * 0.3 - 1.35
    let phi = (i / 10 % 10).to_double() * 0.25 - 1.1
    let depth = 4.0 + (i % 5).to_double() * 2.0

    let cos_p = @cmath.cos(phi)
    let x = depth * cos_p * @cmath.sin(theta)
    let y = depth * @cmath.sin(phi)
    let z = depth * cos_p * @cmath.cos(theta)
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 1.0e-3))
  }
}

///|
/// Verification Grid Test for Orthographic Camera over 100 3D Grid Points
test "camera verification table 1 - orthographic 3d grid roundtrip" {
  let cam = OrthographicCamera::new(10.0, 10.0, 500.0, 500.0, 1000.0, 1000.0)

  for i in 0..<100 {
    let x = (i % 10).to_double() * 4.0 - 18.0
    let y = (i / 10 % 10).to_double() * 4.0 - 18.0
    let z = 10.0 + (i % 10).to_double() * 5.0
    let p3 = @math.Vec3::new(x, y, z)

    let proj = cam.project(p3)
    assert_true(proj.in_fov)

    let p_rec = cam.unproject(proj.pixel, proj.depth)
    assert_true(@math.approx_eq(p_rec.x, p3.x, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.y, p3.y, 1.0e-3))
    assert_true(@math.approx_eq(p_rec.z, p3.z, 1.0e-3))
  }
}
