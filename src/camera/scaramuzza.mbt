// Scaramuzza Omnidirectional Polynomial Camera Model

///| Scaramuzza omnidirectional polynomial camera model used in catadioptric vision
pub(all) struct ScaramuzzaCamera {
  cx : Double
  cy : Double
  c : Double
  d : Double
  e : Double
  poly_a0 : Double
  poly_a1 : Double
  poly_a2 : Double
  poly_a3 : Double
  poly_a4 : Double
  width : Double
  height : Double
} derive(Debug, Eq)

///| Construct new Scaramuzza camera model
pub fn ScaramuzzaCamera::new(
  cx : Double,
  cy : Double,
  c : Double,
  d : Double,
  e : Double,
  poly_a0 : Double,
  poly_a1 : Double,
  poly_a2 : Double,
  poly_a3 : Double,
  poly_a4 : Double,
  width : Double,
  height : Double
) -> ScaramuzzaCamera {
  { cx, cy, c, d, e, poly_a0, poly_a1, poly_a2, poly_a3, poly_a4, width, height }
}

///| Unproject 2D pixel to 3D ray vector using Scaramuzza polynomial
pub fn ScaramuzzaCamera::unproject(self : ScaramuzzaCamera, pixel : @math.Vec2, depth : Double) -> @math.Vec3 {
  let u = pixel.x - self.cx
  let v = pixel.y - self.cy

  let det = self.c - self.d * self.e
  let u_prime = (self.c * u - self.d * v) / det
  let v_prime = (-self.e * u + v) / det

  let rho = (u_prime * u_prime + v_prime * v_prime).sqrt()
  let rho2 = rho * rho
  let rho3 = rho2 * rho
  let rho4 = rho2 * rho2

  let z_poly = self.poly_a0 + self.poly_a1 * rho + self.poly_a2 * rho2 + self.poly_a3 * rho3 + self.poly_a4 * rho4
  let dir = @math.Vec3::new(u_prime, v_prime, -z_poly).normalized()

  dir.mul_scalar(depth)
}
