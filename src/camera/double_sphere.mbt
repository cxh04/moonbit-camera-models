// Double Sphere Camera Model for Wide-Angle Lenses and Visual SLAM

///|
/// Double Sphere Camera Model (DSO / Basalt SLAM)
pub(all) struct DoubleSphereCamera {
  fx : Double
  fy : Double
  cx : Double
  cy : Double
  xi : Double
  alpha : Double
  width : Double
  height : Double
} derive(Debug, Eq)

///|
/// Construct new Double Sphere Camera Model
pub fn DoubleSphereCamera::new(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  xi : Double,
  alpha : Double,
  width : Double,
  height : Double,
) -> DoubleSphereCamera {
  { fx, fy, cx, cy, xi, alpha, width, height }
}

///|
/// Project 3D point in camera frame to 2D double sphere pixel
pub fn DoubleSphereCamera::project(
  self : DoubleSphereCamera,
  p : @math.Vec3,
) -> ProjectionResult {
  let r2 = p.x * p.x + p.y * p.y
  let d1 = (r2 + p.z * p.z).sqrt()
  let z_xi = self.xi * d1 + p.z
  let d2 = (r2 + z_xi * z_xi).sqrt()

  let denom = self.alpha * d2 + (1.0 - self.alpha) * z_xi
  if denom == 0.0 {
    { pixel: @math.Vec2::zero(), depth: d1, in_fov: false }
  } else {
    let u = self.fx * (p.x / denom) + self.cx
    let v = self.fy * (p.y / denom) + self.cy
    let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
    { pixel: @math.Vec2::new(u, v), depth: d1, in_fov }
  }
}

///|
/// Unproject 2D double sphere pixel coordinate back to 3D point
pub fn DoubleSphereCamera::unproject(
  self : DoubleSphereCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let mx = (pixel.x - self.cx) / self.fx
  let my = (pixel.y - self.cy) / self.fy
  let r2 = mx * mx + my * my

  let mz = (1.0 - self.alpha * self.alpha * r2) /
    (
      self.alpha * (1.0 - (1.0 - 2.0 * self.alpha) * r2).sqrt() +
      (1.0 - self.alpha)
    )

  let scale = (mz + self.xi) / (mz * mz + r2)
  let x = mx * scale
  let y = my * scale
  let z = mz * scale - self.xi

  let dir = @math.Vec3::new(x, y, z).normalized()
  dir.mul_scalar(depth)
}
