// Unified Camera Model (EUCM / Mei Model)

///| Extended Unified Camera Model (EUCM)
pub(all) struct UnifiedCamera {
  fx : Double
  fy : Double
  cx : Double
  cy : Double
  alpha : Double
  beta : Double
  width : Double
  height : Double
} derive(Debug, Eq)

///| Construct new Unified Camera Model
pub fn UnifiedCamera::new(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  alpha : Double,
  beta : Double,
  width : Double,
  height : Double
) -> UnifiedCamera {
  { fx, fy, cx, cy, alpha, beta, width, height }
}

///| Project 3D point in camera frame using EUCM model
pub fn UnifiedCamera::project(self : UnifiedCamera, p : @math.Vec3) -> ProjectionResult {
  let r2 = p.x * p.x + p.y * p.y
  let d = (self.beta * r2 + p.z * p.z).sqrt()
  let denom = self.alpha * d + (1.0 - self.alpha) * p.z

  if denom == 0.0 {
    { pixel: @math.Vec2::zero(), depth: d, in_fov: false }
  } else {
    let u = self.fx * (p.x / denom) + self.cx
    let v = self.fy * (p.y / denom) + self.cy
    let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
    { pixel: @math.Vec2::new(u, v), depth: d, in_fov }
  }
}

///| Unproject 2D EUCM pixel coordinate back to 3D point
pub fn UnifiedCamera::unproject(self : UnifiedCamera, pixel : @math.Vec2, depth : Double) -> @math.Vec3 {
  let mx = (pixel.x - self.cx) / self.fx
  let my = (pixel.y - self.cy) / self.fy
  let r2 = mx * mx + my * my

  let term = 1.0 - (1.0 - 2.0 * self.alpha) * self.beta * r2
  let mz = (1.0 - self.alpha * self.alpha * self.beta * r2) /
    (self.alpha * term.sqrt() + (1.0 - self.alpha))

  let dir = @math.Vec3::new(mx, my, mz).normalized()
  dir.mul_scalar(depth)
}
