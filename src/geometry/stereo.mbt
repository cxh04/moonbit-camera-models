// Multi-view Epipolar Geometry and 3D Triangulation

///|
/// Compute skew-symmetric matrix [t]_x for vector t
pub fn skew_symmetric(t : @math.Vec3) -> @math.Mat3x3 {
  @math.Mat3x3::new(0.0, -t.z, t.y, t.z, 0.0, -t.x, -t.y, t.x, 0.0)
}

///|
/// Compute Essential Matrix E = [t]_x * R
pub fn essential_matrix(r : @math.Mat3x3, t : @math.Vec3) -> @math.Mat3x3 {
  let tx = skew_symmetric(t)
  tx.mul_mat3x3(r)
}

///|
/// Compute Fundamental Matrix F = K2^(-T) * E * K1^(-1)
pub fn fundamental_matrix(
  e : @math.Mat3x3,
  k1_inv : @math.Mat3x3,
  k2_inv : @math.Mat3x3,
) -> @math.Mat3x3 {
  let k2_inv_t = k2_inv.transpose()
  k2_inv_t.mul_mat3x3(e).mul_mat3x3(k1_inv)
}

///|
/// Compute epipolar line l = F * p1 in image 2 (line equation a*u + b*v + c = 0)
pub fn compute_epipolar_line(f : @math.Mat3x3, p1 : @math.Vec2) -> @math.Vec3 {
  let p1_h = @math.Vec3::new(p1.x, p1.y, 1.0)
  f.mul_vec3(p1_h)
}

///|
/// Compute perpendicular distance from point p to line equation (a, b, c)
pub fn distance_to_epipolar_line(line : @math.Vec3, p : @math.Vec2) -> Double {
  let num = line.x * p.x + line.y * p.y + line.z
  let denom = (line.x * line.x + line.y * line.y).sqrt()
  if denom == 0.0 {
    0.0
  } else {
    let dist = num / denom
    if dist < 0.0 {
      -dist
    } else {
      dist
    }
  }
}

///|
/// Compute Sampson Error metric for Fundamental Matrix F and point match (p1, p2)
pub fn sampson_distance(
  f : @math.Mat3x3,
  p1 : @math.Vec2,
  p2 : @math.Vec2,
) -> Double {
  let p1_h = @math.Vec3::new(p1.x, p1.y, 1.0)
  let p2_h = @math.Vec3::new(p2.x, p2.y, 1.0)

  let f_p1 = f.mul_vec3(p1_h)
  let f_t_p2 = f.transpose().mul_vec3(p2_h)

  let num = p2_h.dot(f_p1)
  let num_sq = num * num

  let denom = f_p1.x * f_p1.x +
    f_p1.y * f_p1.y +
    f_t_p2.x * f_t_p2.x +
    f_t_p2.y * f_t_p2.y
  if denom == 0.0 {
    0.0
  } else {
    (num_sq / denom).sqrt()
  }
}

///|
/// Midpoint Triangulation of 2D rays from two cameras to reconstruct 3D point in world coordinates
pub fn triangulate_midpoint(
  pose1 : @math.RigidTransform,
  ray1 : @math.Ray,
  pose2 : @math.RigidTransform,
  ray2 : @math.Ray,
) -> @math.Vec3 {
  let o1 = pose1.inverse().transform_point(ray1.origin)
  let d1 = pose1.rotation.transpose().mul_vec3(ray1.direction)

  let o2 = pose2.inverse().transform_point(ray2.origin)
  let d2 = pose2.rotation.transpose().mul_vec3(ray2.direction)

  let o21 = o2.sub(o1)
  let d1_dot_d2 = d1.dot(d2)
  let d1_sq = d1.norm_sq()
  let d2_sq = d2.norm_sq()

  let denom = d1_sq * d2_sq - d1_dot_d2 * d1_dot_d2
  if denom == 0.0 {
    o1.add(o2).mul_scalar(0.5)
  } else {
    let t1 = (o21.dot(d1) * d2_sq - o21.dot(d2) * d1_dot_d2) / denom
    let t2 = (o21.dot(d1) * d1_dot_d2 - o21.dot(d2) * d1_sq) / denom
    let p1 = o1.add(d1.mul_scalar(t1))
    let p2 = o2.add(d2.mul_scalar(t2))
    p1.add(p2).mul_scalar(0.5)
  }
}
