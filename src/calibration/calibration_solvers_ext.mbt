// Extended Calibration Solvers & Robust Loss Functions for LM Optimizer

///|
/// Robust Loss Function Type for M-Estimator Optimization
pub(all) enum LossFunction {
  L2Loss
  HuberLoss(Double)
  CauchyLoss(Double)
  TukeyLoss(Double)
} derive(Debug, Eq)

///|
/// Compute robust weight for scalar residual e under specified LossFunction
pub fn LossFunction::weight(self : LossFunction, e : Double) -> Double {
  let abs_e = e.abs()
  match self {
    L2Loss => 1.0
    HuberLoss(delta) => if abs_e <= delta { 1.0 } else { delta / abs_e }
    CauchyLoss(c) => 1.0 / (1.0 + abs_e / c * (abs_e / c))
    TukeyLoss(c) =>
      if abs_e <= c {
        let u = 1.0 - abs_e / c * (abs_e / c)
        u * u
      } else {
        0.0
      }
  }
}

///|
/// Levenberg-Marquardt Optimizer Options Configuration
pub(all) struct LMOptions {
  max_iterations : Int
  init_lambda : Double
  lambda_factor : Double
  min_gradient : Double
  loss_function : LossFunction
} derive(Debug, Eq)

///|
/// Default Levenberg-Marquardt Options constructor
pub fn LMOptions::default() -> LMOptions {
  {
    max_iterations: 100,
    init_lambda: 1.0e-3,
    lambda_factor: 10.0,
    min_gradient: 1.0e-6,
    loss_function: LossFunction::L2Loss,
  }
}

///|
/// Helper to construct initial zero distortion model for calibration optimization
pub fn create_default_distortion_profile() -> @distortion.BrownConrady {
  @distortion.BrownConrady::zero()
}
