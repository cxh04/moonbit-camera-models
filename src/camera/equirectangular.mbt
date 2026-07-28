// Equirectangular 360-degree Panorama Camera Model

///|
/// Equirectangular camera model mapping 3D space to a 360-degree spherical panorama image
pub(all) struct EquirectangularCamera {
  width : Double
  height : Double
} derive(Debug, Eq)

///|
/// Construct new equirectangular panorama camera model
pub fn EquirectangularCamera::new(
  width : Double,
  height : Double,
) -> EquirectangularCamera {
  { width, height }
}

///|
/// Project 3D point to 2D equirectangular panorama pixel
pub fn EquirectangularCamera::project(
  self : EquirectangularCamera,
  p : @math.Vec3,
) -> ProjectionResult {
  let norm = p.norm()
  if norm == 0.0 {
    { pixel: @math.Vec2::zero(), depth: 0.0, in_fov: false }
  } else {
    // Longitude lambda in [-pi, pi]
    let lambda = @cmath.atan2(p.x, p.z)
    // Latitude phi in [-pi/2, pi/2]
    let phi = @cmath.asin(p.y / norm)

    let pi = 3.141592653589793
    let u = (lambda / pi + 1.0) / 2.0 * self.width
    let v = (phi / (pi / 2.0) + 1.0) / 2.0 * self.height

    let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
    { pixel: @math.Vec2::new(u, v), depth: norm, in_fov }
  }
}

///|
/// Unproject 2D equirectangular pixel coordinate back to 3D ray point
pub fn EquirectangularCamera::unproject(
  self : EquirectangularCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let pi = 3.141592653589793
  let lambda = (pixel.x / self.width * 2.0 - 1.0) * pi
  let phi = (pixel.y / self.height * 2.0 - 1.0) * (pi / 2.0)

  let cos_phi = @cmath.cos(phi)
  let x = cos_phi * @cmath.sin(lambda) * depth
  let y = @cmath.sin(phi) * depth
  let z = cos_phi * @cmath.cos(lambda) * depth

  @math.Vec3::new(x, y, z)
}
