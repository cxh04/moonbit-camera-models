// Epipolar geometry matrix estimators and geometric distance metrics

///|
/// Compute Homography Matrix H = R + (t * n^T) / d for planar scene with normal n and distance d
pub fn compute_homography_matrix(
  r : @math.Mat3x3,
  t : @math.Vec3,
  n : @math.Vec3,
  d : Double,
) -> @math.Mat3x3 {
  if d == 0.0 {
    r
  } else {
    let tn_m00 = r.m00 + t.x * n.x / d
    let tn_m01 = r.m01 + t.x * n.y / d
    let tn_m02 = r.m02 + t.x * n.z / d
    let tn_m10 = r.m10 + t.y * n.x / d
    let tn_m11 = r.m11 + t.y * n.y / d
    let tn_m12 = r.m12 + t.y * n.z / d
    let tn_m20 = r.m20 + t.z * n.x / d
    let tn_m21 = r.m21 + t.z * n.y / d
    let tn_m22 = r.m22 + t.z * n.z / d
    @math.Mat3x3::new(
      tn_m00, tn_m01, tn_m02, tn_m10, tn_m11, tn_m12, tn_m20, tn_m21, tn_m22,
    )
  }
}

///|
/// Compute symmetric epipolar transfer error for point correspondences p1, p2
pub fn symmetric_epipolar_distance(
  f : @math.Mat3x3,
  p1 : @math.Vec2,
  p2 : @math.Vec2,
) -> Double {
  let l2 = compute_epipolar_line(f, p1)
  let l1 = f.transpose().mul_vec3(@math.Vec3::new(p2.x, p2.y, 1.0))

  let d2 = distance_to_epipolar_line(l2, p2)
  let d1 = distance_to_epipolar_line(l1, p1)

  d1 * d1 + d2 * d2
}
