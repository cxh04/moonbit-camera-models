// Perspective-n-Point (PnP) Pose Estimation Algorithms

///|
/// Estimate camera pose SE(3) from 3D-to-2D point correspondences using a
/// homogeneous DLT camera matrix followed by rotation orthogonalisation.
///
/// Image observations are undistorted through the supplied camera model before
/// the linear system is built. At least six non-degenerate correspondences are
/// required; extra points are used in the normal equations as a least-squares
/// estimate.
pub fn solve_pnp_dlt(
  points_3d : Array[@math.Vec3],
  points_2d : Array[@math.Vec2],
  cam : @camera.PinholeCamera,
) -> @math.RigidTransform? {
  let len = points_3d.length()
  if len < 6 || len != points_2d.length() {
    None
  } else {
    let normal = Array::make(12, Array::make(12, 0.0))
    for i in 0..<12 {
      normal[i] = Array::make(12, 0.0)
    }
    for i in 0..<len {
      let world = points_3d[i]
      let normalized = cam.unproject(points_2d[i], 1.0)
      let norm_x = normalized.x / normalized.z
      let norm_y = normalized.y / normalized.z
      let x = world.x
      let y = world.y
      let z = world.z
      let row_x = [
        -x,
        -y,
        -z,
        -1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        norm_x * x,
        norm_x * y,
        norm_x * z,
        norm_x,
      ]
      let row_y = [
        0.0,
        0.0,
        0.0,
        0.0,
        -x,
        -y,
        -z,
        -1.0,
        norm_y * x,
        norm_y * y,
        norm_y * z,
        norm_y,
      ]
      accumulate_pnp_normal(normal, row_x)
      accumulate_pnp_normal(normal, row_y)
    }

    match @math.smallest_eigenvector_symmetric(normal, 3600) {
      None => None
      Some(solution) => pose_from_dlt_solution(solution, points_3d)
    }
  }
}

///|
fn accumulate_pnp_normal(
  normal : Array[Array[Double]],
  row : Array[Double],
) -> Unit {
  for i in 0..<row.length() {
    for j in 0..<row.length() {
      normal[i][j] += row[i] * row[j]
    }
  }
}

///|
fn pose_from_dlt_solution(
  solution : Array[Double],
  points_3d : Array[@math.Vec3],
) -> @math.RigidTransform? {
  let mut p00 = solution[0]
  let mut p01 = solution[1]
  let mut p02 = solution[2]
  let mut p03 = solution[3]
  let mut p10 = solution[4]
  let mut p11 = solution[5]
  let mut p12 = solution[6]
  let mut p13 = solution[7]
  let mut p20 = solution[8]
  let mut p21 = solution[9]
  let mut p22 = solution[10]
  let mut p23 = solution[11]

  // The eigenvector is defined up to sign. Select the sign that puts the
  // average reconstructed point in front of the camera.
  let mut signed_depth = 0.0
  for point in points_3d {
    signed_depth += p20 * point.x + p21 * point.y + p22 * point.z + p23
  }
  if signed_depth < 0.0 {
    p00 = -p00
    p01 = -p01
    p02 = -p02
    p03 = -p03
    p10 = -p10
    p11 = -p11
    p12 = -p12
    p13 = -p13
    p20 = -p20
    p21 = -p21
    p22 = -p22
    p23 = -p23
  }

  let c1 = @math.Vec3::new(p00, p10, p20)
  let c2 = @math.Vec3::new(p01, p11, p21)
  let c3 = @math.Vec3::new(p02, p12, p22)
  let scale = (c1.norm() + c2.norm() + c3.norm()) / 3.0
  if scale < 1.0e-12 {
    None
  } else {
    let a1 = c1.div_scalar(scale)
    let a2 = c2.div_scalar(scale)
    let r1 = a1.normalized()
    let r2_candidate = a2.sub(r1.mul_scalar(r1.dot(a2)))
    if r2_candidate.norm() < 1.0e-8 {
      None
    } else {
      let r2 = r2_candidate.normalized()
      let r3 = r1.cross(r2)
      let translation = @math.Vec3::new(p03 / scale, p13 / scale, p23 / scale)
      let rotation = @math.Mat3x3::new(
        r1.x,
        r2.x,
        r3.x,
        r1.y,
        r2.y,
        r3.y,
        r1.z,
        r2.z,
        r3.z,
      )
      Some(@math.RigidTransform::new(rotation, translation))
    }
  }
}
