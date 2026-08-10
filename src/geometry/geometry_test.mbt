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
  let cam = @camera.PinholeCamera::new(800.0, 800.0, 640.0, 360.0, 1280.0, 720.0)
  let points_3d = [
    @math.Vec3::new(-1.0, -1.0, 5.0),
    @math.Vec3::new(1.0, -1.0, 5.0),
    @math.Vec3::new(1.0, 1.0, 5.0),
    @math.Vec3::new(-1.0, 1.0, 5.0),
    @math.Vec3::new(0.0, 0.0, 6.0),
    @math.Vec3::new(0.5, -0.5, 4.5)
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

  let pose_rel = @math.RigidTransform::new(@math.Mat3x3::identity(), @math.Vec3::new(0.12, 0.0, 0.0))
  let (r1, r2) = rectify_stereo_pair(cam, cam, pose_rel)
  assert_true(r1.m00 != 0.0)
  assert_true(r2.m00 != 0.0)
}
