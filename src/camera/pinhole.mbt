// Standard Pinhole Camera Model with Intrinsic Parameters and Lens Distortion

///|
/// Pinhole Camera Model struct
pub(all) struct PinholeCamera {
  fx : Double
  fy : Double
  cx : Double
  cy : Double
  skew : Double
  width : Double
  height : Double
  distortion : @distortion.BrownConrady
} derive(Debug, Eq)

///|
/// Construct ideal pinhole camera model without distortion
pub fn PinholeCamera::new(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  width : Double,
  height : Double,
) -> PinholeCamera {
  {
    fx,
    fy,
    cx,
    cy,
    skew: 0.0,
    width,
    height,
    distortion: @distortion.BrownConrady::zero(),
  }
}

///|
/// Construct pinhole camera model with custom skew and lens distortion
pub fn PinholeCamera::with_distortion(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  skew : Double,
  width : Double,
  height : Double,
  distortion : @distortion.BrownConrady,
) -> PinholeCamera {
  { fx, fy, cx, cy, skew, width, height, distortion }
}

///|
/// Project 3D point in camera frame to 2D image coordinates
pub fn PinholeCamera::project(
  self : PinholeCamera,
  p : @math.Vec3,
) -> ProjectionResult {
  let depth = p.z
  if depth <= 0.0 {
    { pixel: @math.Vec2::zero(), depth, in_fov: false }
  } else {
    let x_norm = p.x / depth
    let y_norm = p.y / depth
    let x_skewed = x_norm + self.skew * y_norm
    let p_norm = @math.Vec2::new(x_skewed, y_norm)
    let p_distorted = self.distortion.distort(p_norm)

    let u = self.fx * p_distorted.x + self.cx
    let v = self.fy * p_distorted.y + self.cy

    let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
    { pixel: @math.Vec2::new(u, v), depth, in_fov }
  }
}

///|
/// Unproject 2D pixel coordinate at a given depth back to 3D camera coordinate
pub fn PinholeCamera::unproject(
  self : PinholeCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let x_distorted = (pixel.x - self.cx) / self.fx
  let y_distorted = (pixel.y - self.cy) / self.fy
  let p_distorted = @math.Vec2::new(x_distorted, y_distorted)

  let p_norm = self.distortion.undistort(p_distorted, 20, 0.000001)
  let y_norm = p_norm.y
  let x_norm = p_norm.x - self.skew * y_norm

  @math.Vec3::new(x_norm * depth, y_norm * depth, depth)
}

///|
/// Generate 3D optical ray corresponding to a 2D pixel coordinate
pub fn PinholeCamera::ray(
  self : PinholeCamera,
  pixel : @math.Vec2,
) -> @math.Ray {
  let dir = self.unproject(pixel, 1.0).normalized()
  @math.Ray::new(@math.Vec3::zero(), dir)
}

///|
/// Compute field-of-view angles for the pinhole camera
pub fn PinholeCamera::field_of_view(self : PinholeCamera) -> FOV {
  let h_rad = 2.0 * @cmath.atan(self.width / (2.0 * self.fx))
  let v_rad = 2.0 * @cmath.atan(self.height / (2.0 * self.fy))
  let diag = (self.width * self.width + self.height * self.height).sqrt()
  let d_rad = 2.0 * @cmath.atan(diag / (2.0 * self.fx))
  { horizontal_rad: h_rad, vertical_rad: v_rad, diagonal_rad: d_rad }
}
