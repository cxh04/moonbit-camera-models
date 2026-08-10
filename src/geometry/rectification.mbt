// Stereo Rectification Transformation Matrix Computation

///|
/// Compute rectification rotation matrices R1, R2 for stereo camera pair
pub fn rectify_stereo_pair(
  _cam1 : @camera.PinholeCamera,
  _cam2 : @camera.PinholeCamera,
  relative_pose : @math.RigidTransform,
) -> (@math.Mat3x3, @math.Mat3x3) {
  // Baseline vector T
  let t = relative_pose.translation
  let baseline = t.norm()

  let r1 = if baseline < 0.000001 {
    @math.Mat3x3::identity()
  } else {
    // e1 parallel to baseline
    let e1 = t.mul_scalar(1.0 / baseline)
    let k = @math.Vec3::unit_z()
    let e2_temp = k.cross(e1)
    let e2 = if e2_temp.norm() < 0.000001 {
      @math.Vec3::unit_y().cross(e1).normalized()
    } else {
      e2_temp.normalized()
    }
    let e3 = e1.cross(e2)

    @math.Mat3x3::new(e1.x, e1.y, e1.z, e2.x, e2.y, e2.z, e3.x, e3.y, e3.z)
  }

  let r2 = r1.mul_mat3x3(relative_pose.rotation.transpose())
  (r1, r2)
}
