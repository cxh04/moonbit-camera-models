// Extended Lens Distortion Models: Higher-Order Series and Division Distortion Profiles

///|
/// High-Order Radial-Tangential-ThinPrism Distortion Parameter Set
pub(all) struct HighOrderDistortion {
  k1 : Double
  k2 : Double
  k3 : Double
  k4 : Double
  k5 : Double
  k6 : Double
  p1 : Double
  p2 : Double
  s1 : Double
  s2 : Double
  s3 : Double
  s4 : Double
} derive(Debug, Eq)

///|
/// Construct zero high-order distortion model
pub fn HighOrderDistortion::zero() -> HighOrderDistortion {
  {
    k1: 0.0,
    k2: 0.0,
    k3: 0.0,
    k4: 0.0,
    k5: 0.0,
    k6: 0.0,
    p1: 0.0,
    p2: 0.0,
    s1: 0.0,
    s2: 0.0,
    s3: 0.0,
    s4: 0.0,
  }
}

///|
/// Distort normalized 2D point (x, y) using 12-parameter high-order model
pub fn HighOrderDistortion::distort(
  self : HighOrderDistortion,
  p : @math.Vec2,
) -> @math.Vec2 {
  let x = p.x
  let y = p.y
  let r2 = x * x + y * y
  let r4 = r2 * r2
  let r6 = r4 * r2

  let num_radial = 1.0 + self.k1 * r2 + self.k2 * r4 + self.k3 * r6
  let den_radial = 1.0 + self.k4 * r2 + self.k5 * r4 + self.k6 * r6
  let radial = if den_radial == 0.0 { 1.0 } else { num_radial / den_radial }

  let dx_tangential = 2.0 * self.p1 * x * y + self.p2 * (r2 + 2.0 * x * x)
  let dy_tangential = self.p1 * (r2 + 2.0 * y * y) + 2.0 * self.p2 * x * y

  let dx_prism = self.s1 * r2 + self.s2 * r4
  let dy_prism = self.s3 * r2 + self.s4 * r4

  let x_dist = x * radial + dx_tangential + dx_prism
  let y_dist = y * radial + dy_tangential + dy_prism

  @math.Vec2::new(x_dist, y_dist)
}

///|
/// Compute analytical Jacobian matrix J (2x2) of high-order distortion at normalized point (x, y)
pub fn HighOrderDistortion::jacobian(
  self : HighOrderDistortion,
  p : @math.Vec2,
) -> @math.Mat3x3 {
  let h = 1.0e-6
  let f = fn(v : Array[Double]) -> Array[Double] {
    let pt = @math.Vec2::new(v[0], v[1])
    let d = self.distort(pt)
    [d.x, d.y]
  }
  let j_arr = @math.num_jacobian(f, [p.x, p.y], h)
  @math.Mat3x3::new(
    j_arr[0][0],
    j_arr[0][1],
    0.0,
    j_arr[1][0],
    j_arr[1][1],
    0.0,
    0.0,
    0.0,
    1.0,
  )
}
