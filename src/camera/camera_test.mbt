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

  let k_mat = cam.get_intrinsic_matrix()
  let inv_k = cam.get_inverse_intrinsic_matrix()
  let prod = k_mat.mul_mat3x3(inv_k)
  assert_true(@math.approx_eq(prod.m00, 1.0, 0.000001))
  assert_true(@math.approx_eq(prod.m11, 1.0, 0.000001))
  assert_true(@math.approx_eq(prod.m22, 1.0, 0.000001))
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

///|
test "cubic panorama camera projection and unprojection" {
  let cam = CubicPanoramaCamera::new(512.0)
  let p_front = @math.Vec3::new(0.2, -0.1, 2.0)
  let (face, pixel) = cam.project_to_face(p_front)
  assert_eq(face, CubeFace::Front)

  let ray_dir = cam.unproject_from_face(face, pixel)
  let p_norm = p_front.normalized()
  assert_true(@math.approx_eq(ray_dir.x, p_norm.x, 0.0001))
  assert_true(@math.approx_eq(ray_dir.y, p_norm.y, 0.0001))
  assert_true(@math.approx_eq(ray_dir.z, p_norm.z, 0.0001))
}

///|
test "division camera model roundtrip" {
  let cam = DivisionCamera::new(
    500.0, 500.0, 320.0, 240.0, 640.0, 480.0, -0.05, 0.001,
  )
  let p_3d = @math.Vec3::new(0.5, 0.2, 3.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  let proj_rec = cam.project(p_rec)
  assert_true(@math.approx_eq(proj_rec.pixel.x, proj.pixel.x, 0.1))
  assert_true(@math.approx_eq(proj_rec.pixel.y, proj.pixel.y, 0.1))
}

///|
test "fov camera model roundtrip" {
  let cam = FOVCamera::new(600.0, 600.0, 320.0, 240.0, 640.0, 480.0, 0.5)
  let p_3d = @math.Vec3::new(0.4, -0.2, 2.0)
  let proj = cam.project(p_3d)
  assert_true(proj.in_fov)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  let proj_rec = cam.project(p_rec)
  assert_true(@math.approx_eq(proj_rec.pixel.x, proj.pixel.x, 0.1))
  assert_true(@math.approx_eq(proj_rec.pixel.y, proj.pixel.y, 0.1))
}

///|
test "stereo camera rig triangulation" {
  let dist = @distortion.BrownConrady::identity()
  let left = PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )
  let right = PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )
  let rig = StereoCameraRig::new_parallel(left, right, 0.12)

  let p_3d = @math.Vec3::new(0.5, 0.2, 4.0)
  let proj_l = left.project(p_3d)
  let p_right_frame = @math.Vec3::new(p_3d.x - 0.12, p_3d.y, p_3d.z)
  let proj_r = right.project(p_right_frame)

  let p_tri = rig.triangulate_pixel(proj_l.pixel, proj_r.pixel).unwrap()
  assert_true(@math.approx_eq(p_tri.z, 4.0, 0.01))
}
