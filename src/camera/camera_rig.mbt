// Camera Rig & Multi-Sensor Array Abstractions

///|
/// Stereo Rig with Left and Right Pinhole Camera Models
pub(all) struct StereoCameraRig {
  left : PinholeCamera
  right : PinholeCamera
  baseline : Double
  extrinsics_right_to_left : @math.RigidTransform
} derive(Debug, Eq)

///|
/// Construct standard parallel horizontal stereo camera rig
pub fn StereoCameraRig::new_parallel(
  left : PinholeCamera,
  right : PinholeCamera,
  baseline : Double,
) -> StereoCameraRig {
  let r = @math.Mat3x3::identity()
  let t = @math.Vec3::new(-baseline, 0.0, 0.0)
  let extrinsics = @math.RigidTransform::new(r, t)
  { left, right, baseline, extrinsics_right_to_left: extrinsics }
}

///|
/// Compute 3D point triangulation from stereo disparity d = u_left - u_right
pub fn StereoCameraRig::disparity_to_depth(
  self : StereoCameraRig,
  disparity : Double,
) -> Double? {
  if disparity <= 0.0 {
    None
  } else {
    Some(self.left.fx * self.baseline / disparity)
  }
}

///|
/// Triangulate 3D point given left pixel (u_l, v_l) and right pixel (u_r, v_r)
pub fn StereoCameraRig::triangulate_pixel(
  self : StereoCameraRig,
  pixel_left : @math.Vec2,
  pixel_right : @math.Vec2,
) -> @math.Vec3? {
  let disparity = pixel_left.x - pixel_right.x
  match self.disparity_to_depth(disparity) {
    None => None
    Some(z) => {
      let ray = self.left.unproject(pixel_left, z)
      Some(ray)
    }
  }
}
