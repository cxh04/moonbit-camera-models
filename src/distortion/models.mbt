// Division Model and FOV Distortion Models

///|
/// Single-parameter Division Model for fast analytical radial distortion inversion
pub(all) struct DivisionModel {
  lambda : Double
} derive(Debug, Eq)

///|
pub fn DivisionModel::new(lambda : Double) -> DivisionModel {
  { lambda, }
}

///|
/// Distort point: p_d = p_u / (1 + lambda * ||p_u||^2)
pub fn DivisionModel::distort(
  self : DivisionModel,
  p : @math.Vec2,
) -> @math.Vec2 {
  let r2 = p.norm_sq()
  let factor = 1.0 + self.lambda * r2
  p.div_scalar(factor)
}

///|
/// Fast analytical undistortion for Division Model
pub fn DivisionModel::undistort(
  self : DivisionModel,
  p_distorted : @math.Vec2,
) -> @math.Vec2 {
  let rd2 = p_distorted.norm_sq()
  let term = 1.0 - 4.0 * self.lambda * rd2
  if term < 0.0 {
    p_distorted
  } else {
    let factor = 2.0 / (1.0 + term.sqrt())
    p_distorted.mul_scalar(factor)
  }
}

///|
/// FOV (Field Of View) Distortion Model used in wide-angle cameras
pub(all) struct FOVModel {
  omega : Double
} derive(Debug, Eq)

///|
/// Construct FOV model with distortion angle parameter omega (in radians)
pub fn FOVModel::new(omega : Double) -> FOVModel {
  { omega, }
}

///|
/// Distort point using FOV arc model
pub fn FOVModel::distort(self : FOVModel, p : @math.Vec2) -> @math.Vec2 {
  let ru = p.norm()
  if ru == 0.0 || self.omega == 0.0 {
    p
  } else {
    let tan_half = @cmath.tan(self.omega / 2.0)
    let rd = @cmath.atan(2.0 * ru * tan_half) / self.omega
    p.mul_scalar(rd / ru)
  }
}

///|
/// Analytical undistortion for FOV model
pub fn FOVModel::undistort(
  self : FOVModel,
  p_distorted : @math.Vec2,
) -> @math.Vec2 {
  let rd = p_distorted.norm()
  if rd == 0.0 || self.omega == 0.0 {
    p_distorted
  } else {
    let tan_half = @cmath.tan(self.omega / 2.0)
    let ru = @cmath.tan(rd * self.omega) / (2.0 * tan_half)
    p_distorted.mul_scalar(ru / rd)
  }
}
