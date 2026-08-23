///|
test "essential matrix and triangulation" {
  let r = @math.Mat3x3::identity()
  let t = @math.Vec3::new(2.0, 0.0, 0.0)
  let e = essential_matrix(r, t)
  assert_eq(e.m00, 0.0)
  assert_eq(e.m12, -2.0)

  let pose1 = @math.RigidTransform::identity()
  let pose2 = @math.RigidTransform::new(r, t)

  let p_gt = @math.Vec3::new(0.0, 0.0, 10.0)

  let ray1 = @math.Ray::new(@math.Vec3::zero(), p_gt)
  let p_cam2 = pose2.transform_point(p_gt)
  let ray2 = @math.Ray::new(@math.Vec3::zero(), p_cam2)

  let p_tri = triangulate_midpoint(pose1, ray1, pose2, ray2)
  assert_true(@math.approx_eq(p_tri.x, p_gt.x, 0.0001))
  assert_true(@math.approx_eq(p_tri.y, p_gt.y, 0.0001))
  assert_true(@math.approx_eq(p_tri.z, p_gt.z, 0.0001))
}

///|
test "pnp solve dlt and stereo rectification" {
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )
  let points_3d = [
    @math.Vec3::new(-1.0, -1.0, 5.0),
    @math.Vec3::new(1.0, -1.0, 5.0),
    @math.Vec3::new(1.0, 1.0, 5.0),
    @math.Vec3::new(-1.0, 1.0, 5.0),
    @math.Vec3::new(0.0, 0.0, 6.0),
    @math.Vec3::new(0.5, -0.5, 4.5),
  ]
  let points_2d = [
    cam.project(points_3d[0]).pixel,
    cam.project(points_3d[1]).pixel,
    cam.project(points_3d[2]).pixel,
    cam.project(points_3d[3]).pixel,
    cam.project(points_3d[4]).pixel,
    cam.project(points_3d[5]).pixel,
  ]

  let pose_est = solve_pnp_dlt(points_3d, points_2d, cam)
  assert_true(pose_est is Some(_))

  let pose_rel = @math.RigidTransform::new(
    @math.Mat3x3::identity(),
    @math.Vec3::new(0.12, 0.0, 0.0),
  )
  let (r1, r2) = rectify_stereo_pair(cam, cam, pose_rel)
  assert_true(r1.m00 != 0.0)
  assert_true(r2.m00 != 0.0)
}

///|
test "normalized eight point estimator fits synthetic correspondences" {
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )
  let pose = @math.RigidTransform::new(
    @math.euler_to_mat3x3(0.02, -0.03, 0.04),
    @math.Vec3::new(0.35, -0.1, 0.05),
  )
  let world_points = [
    @math.Vec3::new(-1.4, -0.8, 5.0),
    @math.Vec3::new(1.2, -0.7, 5.8),
    @math.Vec3::new(1.8, 1.1, 6.2),
    @math.Vec3::new(-1.1, 1.4, 4.7),
    @math.Vec3::new(-0.4, 0.1, 7.0),
    @math.Vec3::new(0.7, -1.5, 8.5),
    @math.Vec3::new(2.1, 0.4, 9.0),
    @math.Vec3::new(-2.0, 0.9, 7.8),
    @math.Vec3::new(0.2, 1.8, 6.8),
    @math.Vec3::new(-0.8, -1.8, 9.5),
  ]
  let points_1 = []
  let points_2 = []
  for point in world_points {
    points_1.push(cam.project(point).pixel)
    points_2.push(cam.project(pose.transform_point(point)).pixel)
  }

  let fundamental = estimate_fundamental_matrix_8point(points_1, points_2).unwrap()
  assert_true(fundamental.determinant().abs() < 1.0e-6)
  let mut max_f_error = 0.0
  for i in 0..<world_points.length() {
    let error = sampson_distance(fundamental, points_1[i], points_2[i])
    if error > max_f_error {
      max_f_error = error
    }
  }
  assert_true(max_f_error < 1.0e-3)
}

///|
test "pnp dlt recovers a non-trivial pose from all observations" {
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )
  let expected = @math.RigidTransform::new(
    @math.euler_to_mat3x3(0.05, -0.04, 0.08),
    @math.Vec3::new(0.25, -0.18, 0.35),
  )
  let points_3d = [
    @math.Vec3::new(-1.2, -0.8, 5.0),
    @math.Vec3::new(1.1, -0.7, 5.8),
    @math.Vec3::new(1.6, 1.0, 6.4),
    @math.Vec3::new(-1.0, 1.3, 4.8),
    @math.Vec3::new(-0.3, 0.2, 7.2),
    @math.Vec3::new(0.8, -1.4, 8.3),
    @math.Vec3::new(2.0, 0.5, 9.0),
    @math.Vec3::new(-1.8, 0.8, 7.6),
    @math.Vec3::new(0.4, 1.7, 6.9),
    @math.Vec3::new(-0.7, -1.7, 9.4),
  ]
  let points_2d = []
  for point in points_3d {
    points_2d.push(cam.project(expected.transform_point(point)).pixel)
  }
  let estimated = solve_pnp_dlt(points_3d, points_2d, cam).unwrap()
  let mut max_pnp_error = 0.0
  for i in 0..<points_3d.length() {
    let predicted = cam.project(estimated.transform_point(points_3d[i])).pixel
    let error = predicted.distance(points_2d[i])
    if error > max_pnp_error {
      max_pnp_error = error
    }
  }
  assert_true(max_pnp_error < 1.0e-2)
}
