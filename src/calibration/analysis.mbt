// Calibration residual analysis and quality reporting

///|
/// Calibration Reprojection Quality Metrics
pub(all) struct ReprojectionMetrics {
  rms_error : Double
  mean_error : Double
  max_error : Double
  stddev_error : Double
  total_points : Int
} derive(Debug, Eq)

///|
/// Calculate comprehensive reprojection error metrics for set of projected and observed 2D points
pub fn compute_reprojection_metrics(
  projected : Array[@math.Vec2],
  observed : Array[@math.Vec2],
) -> ReprojectionMetrics {
  let n = projected.length()
  if n == 0 || n != observed.length() {
    {
      rms_error: 0.0,
      mean_error: 0.0,
      max_error: 0.0,
      stddev_error: 0.0,
      total_points: 0,
    }
  } else {
    let mut sum_sq = 0.0
    let mut sum_err = 0.0
    let mut max_err = 0.0
    let errors = Array::make(n, 0.0)

    for i in 0..<n {
      let err = projected[i].distance(observed[i])
      errors[i] = err
      sum_err += err
      sum_sq += err * err
      if err > max_err {
        max_err = err
      }
    }

    let mean_err = sum_err / n.to_double()
    let rms_err = (sum_sq / n.to_double()).sqrt()

    let mut sum_var = 0.0
    for i in 0..<n {
      let diff = errors[i] - mean_err
      sum_var += diff * diff
    }
    let stddev_err = (sum_var / n.to_double()).sqrt()

    {
      rms_error: rms_err,
      mean_error: mean_err,
      max_error: max_err,
      stddev_error: stddev_err,
      total_points: n,
    }
  }
}
