// Numerical Accuracy and Precision Benchmarking Suite

///|
/// Precision Benchmark Metric Result
pub(all) struct PrecisionMetric {
  name : String
  max_residual : Double
  mean_residual : Double
  converged : Bool
} derive(Debug, Eq)

///|
/// Benchmark pinhole projection and ray unprojection precision roundtrip residual
pub fn evaluate_pinhole_precision() -> PrecisionMetric {
  let dist = @distortion.BrownConrady::new(0.02, -0.005, 0.001, -0.001, 0.0)
  let cam = @camera.PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, dist,
  )

  let test_points = [
    @math.Vec3::new(0.0, 0.0, 2.0),
    @math.Vec3::new(1.5, -0.8, 5.0),
    @math.Vec3::new(-2.0, 1.2, 8.0),
    @math.Vec3::new(3.0, 2.5, 12.0),
  ]

  let mut max_err = 0.0
  let mut sum_err = 0.0
  let n = test_points.length()

  for i in 0..<n {
    let p = test_points[i]
    let proj = cam.project(p)
    let p_rec = cam.unproject(proj.pixel, proj.depth)
    let err = p.distance(p_rec)
    sum_err += err
    if err > max_err {
      max_err = err
    }
  }

  {
    name: "Pinhole_Precision_Roundtrip",
    max_residual: max_err,
    mean_residual: sum_err / n.to_double(),
    converged: max_err < 1.0e-3,
  }
}
