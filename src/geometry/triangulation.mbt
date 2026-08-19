// 3D Point Triangulation Algorithms (DLT, Midpoint Ray Intersection)

///|
/// Triangulate 3D point from two camera projection matrices P1, P2 and 2D pixel observations
pub fn triangulate_dlt(
  p1 : @math.Mat4x4,
  p2 : @math.Mat4x4,
  pt1 : @math.Vec2,
  pt2 : @math.Vec2,
) -> @math.Vec3 {
  let r0 = [
    pt1.x * p1.m30 - p1.m00,
    pt1.x * p1.m31 - p1.m01,
    pt1.x * p1.m32 - p1.m02,
    pt1.x * p1.m33 - p1.m03,
  ]
  let r1 = [
    pt1.y * p1.m30 - p1.m10,
    pt1.y * p1.m31 - p1.m11,
    pt1.y * p1.m32 - p1.m12,
    pt1.y * p1.m33 - p1.m13,
  ]
  let r2 = [
    pt2.x * p2.m30 - p2.m00,
    pt2.x * p2.m31 - p2.m01,
    pt2.x * p2.m32 - p2.m02,
    pt2.x * p2.m33 - p2.m03,
  ]

  let b_vec = [-r0[3], -r1[3], -r2[3]]
  let sub_a = [
    [r0[0], r0[1], r0[2]],
    [r1[0], r1[1], r1[2]],
    [r2[0], r2[1], r2[2]],
  ]

  match @math.solve_gaussian(sub_a, b_vec) {
    None => @math.Vec3::zero()
    Some(sol) => @math.Vec3::new(sol[0], sol[1], sol[2])
  }
}
