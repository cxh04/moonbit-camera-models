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
