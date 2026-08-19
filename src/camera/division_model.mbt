// Division Camera Model (Fitzgibbon single-parameter & dual-parameter division model)

///|
/// Division Camera Model for fast analytical inverse radial distortion
pub(all) struct DivisionCamera {
  fx : Double
  fy : Double
  cx : Double
  cy : Double
  width : Double
  height : Double
  k1 : Double
  k2 : Double
} derive(Debug, Eq)

///|
/// Construct new Division Camera Model
pub fn DivisionCamera::new(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  width : Double,
  height : Double,
  k1 : Double,
  k2 : Double,
) -> DivisionCamera {
  { fx, fy, cx, cy, width, height, k1, k2 }
}

///|
/// Project 3D camera frame point to 2D pixel coordinate
pub fn DivisionCamera::project(
  self : DivisionCamera,
  p : @math.Vec3,
) -> ProjectionResult {
  if p.z <= 0.0 {
    { pixel: @math.Vec2::zero(), depth: p.z, in_fov: false }
  } else {
    let x_u = p.x / p.z
    let y_u = p.y / p.z
    let r2 = x_u * x_u + y_u * y_u
    let r4 = r2 * r2
    let denom = 1.0 + self.k1 * r2 + self.k2 * r4
    if denom == 0.0 {
      { pixel: @math.Vec2::zero(), depth: p.z, in_fov: false }
    } else {
      let scale = 1.0 / denom
      let x_d = x_u * scale
      let y_d = y_u * scale

      let u = self.fx * x_d + self.cx
      let v = self.fy * y_d + self.cy

      let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
      { pixel: @math.Vec2::new(u, v), depth: p.z, in_fov }
    }
  }
}

///|
/// Unproject 2D distorted pixel coordinate back to 3D unit ray
pub fn DivisionCamera::unproject(
  self : DivisionCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let x_d = (pixel.x - self.cx) / self.fx
  let y_d = (pixel.y - self.cy) / self.fy
  let r_d2 = x_d * x_d + y_d * y_d

  // Analytical unprojection formula for division model: x_u = x_d / (1 - k1*r_d^2)
  let denom = 1.0 - self.k1 * r_d2
  let scale = if denom.abs() < 1.0e-12 { 1.0 } else { 1.0 / denom }

  let x_u = x_d * scale
  let y_u = y_d * scale

  let ray_dir = @math.Vec3::new(x_u, y_u, 1.0).normalized()
  ray_dir.mul_scalar(depth)
}
