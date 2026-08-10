// Thin Prism Distortion Model (s1, s2, s3, s4)

///|
/// Thin Prism Lens Distortion parameters modeling optical tilt and prism misalignment
pub(all) struct ThinPrismDistortion {
  s1 : Double
  s2 : Double
  s3 : Double
  s4 : Double
} derive(Debug, Eq)

///|
/// Construct Thin Prism Distortion
pub fn ThinPrismDistortion::new(
  s1 : Double,
  s2 : Double,
  s3 : Double,
  s4 : Double,
) -> ThinPrismDistortion {
  { s1, s2, s3, s4 }
}

///|
/// Apply Thin Prism distortion offset to normalized image coordinates (x, y)
pub fn ThinPrismDistortion::distort(
  self : ThinPrismDistortion,
  p : @math.Vec2,
) -> @math.Vec2 {
  let r2 = p.x * p.x + p.y * p.y
  let r4 = r2 * r2
  let dx = self.s1 * r2 + self.s2 * r4
  let dy = self.s3 * r2 + self.s4 * r4
  @math.Vec2::new(p.x + dx, p.y + dy)
}
