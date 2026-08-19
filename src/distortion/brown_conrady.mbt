// Brown-Conrady Radial and Tangential Distortion Model

///|
/// Brown-Conrady camera lens distortion model
/// Radial distortion parameters: k1, k2, k3
/// Tangential distortion parameters: p1, p2
pub(all) struct BrownConrady {
  k1 : Double
  k2 : Double
  p1 : Double
  p2 : Double
  k3 : Double
} derive(Debug, Eq)

///|
/// Construct new Brown-Conrady distortion model
pub fn BrownConrady::new(
  k1 : Double,
  k2 : Double,
  p1 : Double,
  p2 : Double,
  k3 : Double,
) -> BrownConrady {
  { k1, k2, p1, p2, k3 }
}

///|
/// Create zero distortion model
pub fn BrownConrady::zero() -> BrownConrady {
  { k1: 0.0, k2: 0.0, p1: 0.0, p2: 0.0, k3: 0.0 }
}

///|
/// Create identity (zero) distortion model
pub fn BrownConrady::identity() -> BrownConrady {
  BrownConrady::zero()
}

///|
/// Distort normalized 2D point (x, y)
pub fn BrownConrady::distort(self : BrownConrady, p : @math.Vec2) -> @math.Vec2 {
  let x = p.x
  let y = p.y
  let r2 = x * x + y * y
  let r4 = r2 * r2
  let r6 = r4 * r2

  let radial = 1.0 + self.k1 * r2 + self.k2 * r4 + self.k3 * r6
  let dx_tangential = 2.0 * self.p1 * x * y + self.p2 * (r2 + 2.0 * x * x)
  let dy_tangential = self.p1 * (r2 + 2.0 * y * y) + 2.0 * self.p2 * x * y

  let x_distorted = x * radial + dx_tangential
  let y_distorted = y * radial + dy_tangential

  @math.Vec2::new(x_distorted, y_distorted)
}

///|
/// Undistort point iteratively using Newton-Raphson method
pub fn BrownConrady::undistort(
  self : BrownConrady,
  p_distorted : @math.Vec2,
  max_iter : Int,
  tol : Double,
) -> @math.Vec2 {
  let mut p_est = p_distorted
  let mut i = 0
  while i < max_iter {
    let p_re_distorted = self.distort(p_est)
    let err = p_re_distorted.sub(p_distorted)
    if err.norm() < tol {
      break
    }
    p_est = p_est.sub(err)
    i = i + 1
  }
  p_est
}
