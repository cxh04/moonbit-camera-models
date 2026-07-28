// Orthographic Camera Model for Telecentric Lenses and CAD Rendering

///|
/// Orthographic camera model performing parallel perspective-free 2D projection
pub(all) struct OrthographicCamera {
  scale_x : Double
  scale_y : Double
  cx : Double
  cy : Double
  width : Double
  height : Double
} derive(Debug, Eq)

///|
/// Construct new orthographic camera model
pub fn OrthographicCamera::new(
  scale_x : Double,
  scale_y : Double,
  cx : Double,
  cy : Double,
  width : Double,
  height : Double,
) -> OrthographicCamera {
  { scale_x, scale_y, cx, cy, width, height }
}

///|
/// Project 3D point in space to orthographic pixel
pub fn OrthographicCamera::project(
  self : OrthographicCamera,
  p : @math.Vec3,
) -> ProjectionResult {
  let u = self.scale_x * p.x + self.cx
  let v = self.scale_y * p.y + self.cy
  let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
  { pixel: @math.Vec2::new(u, v), depth: p.z, in_fov }
}

///|
/// Unproject orthographic pixel and depth back to 3D point
pub fn OrthographicCamera::unproject(
  self : OrthographicCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let x = (pixel.x - self.cx) / self.scale_x
  let y = (pixel.y - self.cy) / self.scale_y
  @math.Vec3::new(x, y, depth)
}
