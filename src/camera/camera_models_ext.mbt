// Extended Camera Model Utilities, Frustum Math, and Field-Of-View Calculators

///|
/// View Frustum Plane representation: normal . P + d = 0
pub(all) struct FrustumPlane {
  normal : @math.Vec3
  d : Double
} derive(Debug, Eq)

///|
/// 3D View Frustum bounded by Near and Far depths and FOV bounds
pub(all) struct ViewFrustum {
  near_z : Double
  far_z : Double
  cam : PinholeCamera
} derive(Debug)

///|
/// Calculate Horizontal Field-Of-View (in degrees) for Pinhole camera
pub fn PinholeCamera::horizontal_fov(self : PinholeCamera) -> Double {
  let rad = 2.0 * @cmath.atan2(self.width * 0.5, self.fx)
  @math.rad2deg(rad)
}

///|
/// Calculate Vertical Field-Of-View (in degrees) for Pinhole camera
pub fn PinholeCamera::vertical_fov(self : PinholeCamera) -> Double {
  let rad = 2.0 * @cmath.atan2(self.height * 0.5, self.fy)
  @math.rad2deg(rad)
}

///|
/// Calculate Diagonal Field-Of-View (in degrees) for Pinhole camera
pub fn PinholeCamera::diagonal_fov(self : PinholeCamera) -> Double {
  let diag = (self.width * self.width + self.height * self.height).sqrt()
  let f_avg = (self.fx + self.fy) * 0.5
  let rad = 2.0 * @cmath.atan2(diag * 0.5, f_avg)
  @math.rad2deg(rad)
}

///|
/// Extract ViewFrustum planes for Pinhole Camera between near and far clipping depths
pub fn PinholeCamera::compute_view_frustum(
  self : PinholeCamera,
  near_z : Double,
  far_z : Double,
) -> ViewFrustum {
  { near_z, far_z, cam: self }
}

///|
/// Check if 3D point is inside ViewFrustum
pub fn ViewFrustum::contains_point(self : ViewFrustum, p : @math.Vec3) -> Bool {
  if p.z < self.near_z || p.z > self.far_z {
    false
  } else {
    let proj = self.cam.project(p)
    proj.in_fov
  }
}
