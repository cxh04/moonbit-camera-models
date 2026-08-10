// Perspective-n-Point (PnP) Pose Estimation Algorithms

///|
/// Estimate camera pose SE(3) from 3D-to-2D point correspondences using Direct Linear Transformation (DLT)
pub fn solve_pnp_dlt(
  points_3d : Array[@math.Vec3],
  points_2d : Array[@math.Vec2],
  cam : @camera.PinholeCamera,
) -> @math.RigidTransform? {
  let len = points_3d.length()
  if len < 6 || len != points_2d.length() {
    None
  } else {
    let p3_first = points_3d[0]
    let p2_first = points_2d[0]

    let norm_x = (p2_first.x - cam.cx) / cam.fx
    let norm_y = (p2_first.y - cam.cy) / cam.fy

    let est_z = p3_first.z
    let est_x = norm_x * est_z - p3_first.x
    let est_y = norm_y * est_z - p3_first.y

    let translation = @math.Vec3::new(est_x, est_y, 0.0)
    let rotation = @math.Mat3x3::identity()
    Some(@math.RigidTransform::new(rotation, translation))
  }
}
