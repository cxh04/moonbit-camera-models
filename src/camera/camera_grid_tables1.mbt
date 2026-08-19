// Camera Grid Verification Tables - Set 1: Pinhole, Fisheye, Equirectangular, and Orthographic Pixel Projection Grids

///|
/// Test Pinhole Camera pixel distortion grid over 120 image points
test "camera grid tables 1 - pinhole distortion remap grid" {
  let dist = @distortion.BrownConrady::new(0.02, -0.005, 0.001, -0.001, 0.0)
  let cam = PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )

  for j in 0..<10 {
    for i in 0..<12 {
      let u = 100.0 + i.to_double() * 90.0
      let v = 50.0 + j.to_double() * 60.0
      let depth = 5.0

      let ray = cam.unproject(@math.Vec2::new(u, v), depth)
      let proj = cam.project(ray)

      assert_true(@math.approx_eq(proj.pixel.x, u, 1.0e-3))
      assert_true(@math.approx_eq(proj.pixel.y, v, 1.0e-3))
    }
  }
}

///|
/// Test Fisheye Camera radial projection grid over 100 image points
test "camera grid tables 1 - fisheye radial projection grid" {
  let cam = FisheyeCamera::new(
    400.0, 400.0, 640.0, 360.0, 0.01, -0.002, 0.0005, -0.0001, 1280.0, 720.0,
  )

  for j in 0..<10 {
    for i in 0..<10 {
      let u = 140.0 + i.to_double() * 100.0
      let v = 80.0 + j.to_double() * 60.0
      let depth = 4.0

      let ray = cam.unproject(@math.Vec2::new(u, v), depth)
      let proj = cam.project(ray)

      assert_true(@math.approx_eq(proj.pixel.x, u, 1.0e-3))
      assert_true(@math.approx_eq(proj.pixel.y, v, 1.0e-3))
    }
  }
}

///|
/// Test Equirectangular Panorama Camera spherical panorama grid over 100 points
test "camera grid tables 1 - equirectangular spherical panorama grid" {
  let cam = EquirectangularCamera::new(3600.0, 1800.0)

  for j in 0..<10 {
    for i in 0..<10 {
      let u = 360.0 + i.to_double() * 320.0
      let v = 180.0 + j.to_double() * 160.0
      let depth = 6.0

      let ray = cam.unproject(@math.Vec2::new(u, v), depth)
      let proj = cam.project(ray)

      assert_true(@math.approx_eq(proj.pixel.x, u, 1.0e-3))
      assert_true(@math.approx_eq(proj.pixel.y, v, 1.0e-3))
    }
  }
}

///|
/// Test Orthographic Camera parallel ray grid over 100 points
test "camera grid tables 1 - orthographic parallel ray grid" {
  let cam = OrthographicCamera::new(10.0, 10.0, 500.0, 500.0, 1000.0, 1000.0)

  for j in 0..<10 {
    for i in 0..<10 {
      let u = 100.0 + i.to_double() * 80.0
      let v = 100.0 + j.to_double() * 80.0
      let depth = 10.0

      let ray = cam.unproject(@math.Vec2::new(u, v), depth)
      let proj = cam.project(ray)

      assert_true(@math.approx_eq(proj.pixel.x, u, 1.0e-3))
      assert_true(@math.approx_eq(proj.pixel.y, v, 1.0e-3))
    }
  }
}
