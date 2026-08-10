// Extensive Boundary Conditions and Edge-Case Test Suite

///|
test "boundary: pinhole camera points behind optical center" {
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )
  let p_behind = @math.Vec3::new(1.0, 2.0, -5.0)
  let proj_behind = cam.project(p_behind)
  assert_eq(proj_behind.in_fov, false)
  assert_eq(proj_behind.depth, -5.0)

  let p_zero = @math.Vec3::new(0.0, 0.0, 0.0)
  let proj_zero = cam.project(p_zero)
  assert_eq(proj_zero.in_fov, false)
}

///|
test "boundary: fisheye points out of FOV bounds" {
  let cam = @camera.FisheyeCamera::new(
    400.0, 400.0, 640.0, 360.0, 0.01, -0.002, 0.0005, -0.0001, 1280.0, 720.0,
  )
  let p_far_out = @math.Vec3::new(100.0, 100.0, 1.0)
  let proj = cam.project(p_far_out)
  assert_eq(proj.in_fov, false)
}

///|
test "boundary: singular matrix determinant and inverse" {
  let singular_mat = @math.Mat3x3::new(
    1.0, 2.0, 3.0, 2.0, 4.0, 6.0, 3.0, 6.0, 9.0,
  )
  assert_eq(singular_mat.determinant(), 0.0)
  assert_eq(singular_mat.inverse(), None)
}

///|
test "boundary: zero rotation and zero translation rigid transform" {
  let identity_tf = @math.RigidTransform::identity()
  let p = @math.Vec3::new(1.23, -4.56, 7.89)
  let p_tf = identity_tf.transform_point(p)
  assert_eq(p_tf, p)
  let inv_tf = identity_tf.inverse()
  assert_eq(inv_tf.transform_point(p), p)
}

///|
test "boundary: rodrigues 180 degree rotation" {
  let omega_pi = @math.Vec3::new(3.141592653589793, 0.0, 0.0)
  let rot_pi = @math.rodrigues_exp(omega_pi)
  let p = @math.Vec3::new(0.0, 1.0, 0.0)
  let p_rot = rot_pi.mul_vec3(p)
  assert_true(@math.approx_eq(p_rot.y, -1.0, 0.0001))
}

///|
test "boundary: triangulate parallel rays" {
  let pose1 = @math.RigidTransform::identity()
  let pose2 = @math.RigidTransform::new(
    @math.Mat3x3::identity(),
    @math.Vec3::new(1.0, 0.0, 0.0),
  )
  let ray1 = @math.Ray::new(@math.Vec3::zero(), @math.Vec3::unit_z())
  let ray2 = @math.Ray::new(@math.Vec3::zero(), @math.Vec3::unit_z())

  let p_tri = @geometry.triangulate_midpoint(pose1, ray1, pose2, ray2)
  assert_true(p_tri.z != 0.0 || p_tri.x != 0.0)
}

///|
test "boundary: distorted point at origin" {
  let model = @distortion.BrownConrady::new(0.2, -0.1, 0.01, -0.01, 0.001)
  let origin = @math.Vec2::zero()
  let distorted_origin = model.distort(origin)
  assert_eq(distorted_origin, origin)
  let undistorted_origin = model.undistort(origin, 10, 0.000001)
  assert_eq(undistorted_origin, origin)
}

///|
test "boundary: empty inputs to calibration metrics" {
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )
  let rms_empty = @calibration.compute_rms_reprojection_error(cam, [], [])
  assert_eq(rms_empty, 0.0)

  let empty_3d : Array[@math.Vec3] = []
  let empty_2d : Array[@math.Vec2] = []
  let pnp_empty = @geometry.solve_pnp_dlt(empty_3d, empty_2d, cam)
  assert_eq(pnp_empty, None)
}

///|
test "boundary: colmap parser invalid inputs" {
  let parsed1 = @io.parse_colmap_camera_line("# Comment line")
  assert_eq(parsed1, None)

  let parsed2 = @io.parse_colmap_camera_line("")
  assert_eq(parsed2, None)

  let parsed3 = @io.parse_colmap_camera_line("1 UNKNOWN_MODEL 100 100")
  assert_eq(parsed3, None)
}

///|
test "boundary: iphone 15 pro dataset extreme corner projection" {
  let iphone = @datasets.load_iphone15_pro_main_camera()
  let cam = iphone.pinhole_camera.unwrap()
  let corner_3d = @math.Vec3::new(10.0, 7.5, 10.0)
  let proj = cam.project(corner_3d)
  assert_true(proj.pixel.x > 0.0)
  assert_true(proj.pixel.y > 0.0)
}

///|
test "boundary: tum vi double sphere optical center unproject" {
  let tum_vi = @datasets.load_tum_vi_ds_camera()
  let ds_cam = tum_vi.double_sphere_camera.unwrap()
  let center_pixel = @math.Vec2::new(255.433, 255.084)
  let ray_dir = ds_cam.unproject(center_pixel, 1.0)
  assert_true(@math.approx_eq(ray_dir.x, 0.0, 0.001))
  assert_true(@math.approx_eq(ray_dir.y, 0.0, 0.001))
  assert_true(ray_dir.z > 0.0)
}

///|
test "boundary: sampson distance on zero vector" {
  let f = @math.Mat3x3::zero()
  let dist = @geometry.sampson_distance(
    f,
    @math.Vec2::zero(),
    @math.Vec2::zero(),
  )
  assert_eq(dist, 0.0)
}
