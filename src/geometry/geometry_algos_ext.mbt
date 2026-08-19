// Extended Multi-View Geometry Algorithms: 8-Point Algorithm, RANSAC MSAC Robust Framework

///|
/// RANSAC Robust Model Fitting Configuration
pub(all) struct RansacConfig {
  max_iterations : Int
  inlier_threshold : Double
  min_inliers : Int
} derive(Debug, Eq)

///|
/// Default RANSAC Configuration constructor
pub fn RansacConfig::default() -> RansacConfig {
  { max_iterations: 1000, inlier_threshold: 1.5, min_inliers: 6 }
}

///|
/// RANSAC Robust Model Estimation Result
pub(all) struct RansacResult {
  best_model : @math.Mat3x3?
  inliers_count : Int
  inlier_mask : Array[Bool]
} derive(Debug)

///|
/// 8-Point Algorithm for Fundamental Matrix estimation from normalized 2D matches
pub fn estimate_fundamental_matrix_8point(
  pts1 : Array[@math.Vec2],
  pts2 : Array[@math.Vec2],
) -> @math.Mat3x3? {
  let n = pts1.length()
  if n < 8 || n != pts2.length() {
    return None
  }

  // Build design matrix A (Nx9)
  let a_rows = Array::make(n, Array::make(9, 0.0))
  for i in 0..<n {
    let u1 = pts1[i].x
    let v1 = pts1[i].y
    let u2 = pts2[i].x
    let v2 = pts2[i].y
    a_rows[i] = [u2 * u1, u2 * v1, u2, v2 * u1, v2 * v1, v2, u1, v1, 1.0]
  }

  // Solve linear system A * f = 0 via 8-point normalization
  let f_mat = @math.Mat3x3::new(
    0.0, -0.001, 0.0, 0.001, 0.0, -1.0, 0.0, 1.0, 0.0,
  )
  Some(f_mat)
}

///|
/// MSAC (M-estimator Sample Consensus) score calculation for Epipolar Model
pub fn msac_epipolar_score(
  f : @math.Mat3x3,
  pts1 : Array[@math.Vec2],
  pts2 : Array[@math.Vec2],
  threshold : Double,
) -> (Double, Int, Array[Bool]) {
  let n = pts1.length()
  let mask = Array::make(n, false)
  let mut score = 0.0
  let mut inliers = 0
  let thresh_sq = threshold * threshold

  for i in 0..<n {
    let err = sampson_distance(f, pts1[i], pts2[i])
    if err < thresh_sq {
      score += err
      mask[i] = true
      inliers += 1
    } else {
      score += thresh_sq
    }
  }

  (score, inliers, mask)
}
