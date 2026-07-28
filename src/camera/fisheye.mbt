// Fisheye (Kannala-Brandt / Equidistant) Camera Model

///|
/// Kannala-Brandt Fisheye Camera Model with polynomial distortion parameters k1, k2, k3, k4
pub(all) struct FisheyeCamera {
  fx : Double
  fy : Double
  cx : Double
  cy : Double
  k1 : Double
  k2 : Double
  k3 : Double
  k4 : Double
  width : Double
  height : Double
} derive(Debug, Eq)

///|
/// Construct new fisheye camera model
pub fn FisheyeCamera::new(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  k1 : Double,
  k2 : Double,
  k3 : Double,
  k4 : Double,
  width : Double,
  height : Double,
) -> FisheyeCamera {
  { fx, fy, cx, cy, k1, k2, k3, k4, width, height }
}

///|
/// Distort theta angle using polynomial: theta_d = theta * (1 + k1*theta^2 + k2*theta^4 + k3*theta^6 + k4*theta^8)
pub fn FisheyeCamera::distort_theta(
  self : FisheyeCamera,
  theta : Double,
) -> Double {
  let t2 = theta * theta
  let t4 = t2 * t2
  let t6 = t4 * t2
  let t8 = t4 * t4
  theta * (1.0 + self.k1 * t2 + self.k2 * t4 + self.k3 * t6 + self.k4 * t8)
}

///|
/// Undistort theta_d back to theta using Newton-Raphson method
pub fn FisheyeCamera::undistort_theta(
  self : FisheyeCamera,
  theta_d : Double,
  max_iter : Int,
  tol : Double,
) -> Double {
  let mut theta = theta_d
  let mut i = 0
  while i < max_iter {
    let td_est = self.distort_theta(theta)
    let err = td_est - theta_d
    if (if err < 0.0 { -err } else { err }) < tol {
      break
    }
    let t2 = theta * theta
    let t4 = t2 * t2
    let t6 = t4 * t2
    let t8 = t4 * t4
    // Derivative d(theta_d)/d(theta)
    let deriv = 1.0 +
      3.0 * self.k1 * t2 +
      5.0 * self.k2 * t4 +
      7.0 * self.k3 * t6 +
      9.0 * self.k4 * t8
    if deriv != 0.0 {
      theta = theta - err / deriv
    }
    i = i + 1
  }
  theta
}

///|
/// Project 3D point in camera space to 2D fisheye pixel
pub fn FisheyeCamera::project(
  self : FisheyeCamera,
  p : @math.Vec3,
) -> ProjectionResult {
  let r = (p.x * p.x + p.y * p.y).sqrt()
  if p.z == 0.0 && r == 0.0 {
    { pixel: @math.Vec2::new(self.cx, self.cy), depth: 0.0, in_fov: true }
  } else {
    let theta = @cmath.atan2(r, p.z)
    let theta_d = self.distort_theta(theta)

    let scale = if r == 0.0 { 1.0 } else { theta_d / r }
    let u = self.fx * p.x * scale + self.cx
    let v = self.fy * p.y * scale + self.cy

    let depth = p.norm()
    let in_fov = u >= 0.0 &&
      u < self.width &&
      v >= 0.0 &&
      v < self.height &&
      theta <= 1.5707963267948966
    { pixel: @math.Vec2::new(u, v), depth, in_fov }
  }
}

///|
/// Unproject 2D fisheye pixel coordinate to 3D ray point
pub fn FisheyeCamera::unproject(
  self : FisheyeCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let mx = (pixel.x - self.cx) / self.fx
  let my = (pixel.y - self.cy) / self.fy
  let theta_d = (mx * mx + my * my).sqrt()
  let theta = self.undistort_theta(theta_d, 20, 0.000001)

  if theta_d == 0.0 {
    @math.Vec3::new(0.0, 0.0, depth)
  } else {
    let sin_t = @cmath.sin(theta)
    let cos_t = @cmath.cos(theta)
    let dir_x = sin_t * (mx / theta_d)
    let dir_y = sin_t * (my / theta_d)
    let dir_z = cos_t
    @math.Vec3::new(dir_x * depth, dir_y * depth, dir_z * depth)
  }
}
