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
/// Normalized eight-point algorithm for fundamental matrix estimation.
///
/// The correspondences are Hartley-normalized before forming the symmetric
/// normal matrix. The smallest eigenvector gives the homogeneous solution and
/// the result is denormalized and projected to rank two.
pub fn estimate_fundamental_matrix_8point(
  pts1 : Array[@math.Vec2],
  pts2 : Array[@math.Vec2],
) -> @math.Mat3x3? {
  let n = pts1.length()
  if n < 8 || n != pts2.length() {
    return None
  }

  let (normalized_1, center_1, scale_1) = normalize_image_points(pts1)
  let (normalized_2, center_2, scale_2) = normalize_image_points(pts2)
  let normal = Array::make(9, Array::make(9, 0.0))
  for i in 0..<9 {
    normal[i] = Array::make(9, 0.0)
  }
  for i in 0..<n {
    let p1 = normalized_1[i]
    let p2 = normalized_2[i]
    let row = [
      p2.x * p1.x,
      p2.x * p1.y,
      p2.x,
      p2.y * p1.x,
      p2.y * p1.y,
      p2.y,
      p1.x,
      p1.y,
      1.0,
    ]
    accumulate_normal_equation(normal, row)
  }

  match @math.smallest_eigenvector_symmetric(normal, 2400) {
    None => None
    Some(solution) => {
      let normalized_f = vector_to_mat3(solution)
      let rank_two_f = project_to_rank_two(normalized_f)
      let t1 = normalization_matrix(center_1, scale_1)
      let t2 = normalization_matrix(center_2, scale_2)
      let denormalized = t2.transpose().mul_mat3x3(rank_two_f).mul_mat3x3(t1)
      normalize_matrix(denormalized)
    }
  }
}

///|
fn normalize_image_points(
  points : Array[@math.Vec2],
) -> (Array[@math.Vec2], @math.Vec2, Double) {
  let n = points.length()
  let mut center_x = 0.0
  let mut center_y = 0.0
  for point in points {
    center_x += point.x
    center_y += point.y
  }
  let center = @math.Vec2::new(
    center_x / n.to_double(),
    center_y / n.to_double(),
  )
  let mut mean_distance = 0.0
  for point in points {
    mean_distance += point.distance(center)
  }
  mean_distance /= n.to_double()
  let scale = if mean_distance < 1.0e-12 {
    1.0
  } else {
    1.4142135623730951 / mean_distance
  }
  let normalized = []
  for point in points {
    normalized.push(
      @math.Vec2::new(
        (point.x - center.x) * scale,
        (point.y - center.y) * scale,
      ),
    )
  }
  (normalized, center, scale)
}

///|
fn normalization_matrix(center : @math.Vec2, scale : Double) -> @math.Mat3x3 {
  @math.Mat3x3::new(
    scale,
    0.0,
    -scale * center.x,
    0.0,
    scale,
    -scale * center.y,
    0.0,
    0.0,
    1.0,
  )
}

///|
fn accumulate_normal_equation(
  normal : Array[Array[Double]],
  row : Array[Double],
) -> Unit {
  for i in 0..<row.length() {
    for j in 0..<row.length() {
      normal[i][j] += row[i] * row[j]
    }
  }
}

///|
fn vector_to_mat3(values : Array[Double]) -> @math.Mat3x3 {
  @math.Mat3x3::new(
    values[0],
    values[1],
    values[2],
    values[3],
    values[4],
    values[5],
    values[6],
    values[7],
    values[8],
  )
}

///|
fn project_to_rank_two(matrix : @math.Mat3x3) -> @math.Mat3x3 {
  let (u, singular_values, vt) = @math.svd_3x3(matrix)
  let diagonal = @math.Mat3x3::new(
    singular_values.x,
    0.0,
    0.0,
    0.0,
    singular_values.y,
    0.0,
    0.0,
    0.0,
    0.0,
  )
  u.mul_mat3x3(diagonal).mul_mat3x3(vt)
}

///|
fn normalize_matrix(matrix : @math.Mat3x3) -> @math.Mat3x3? {
  let norm_sq = matrix.m00 * matrix.m00 +
    matrix.m01 * matrix.m01 +
    matrix.m02 * matrix.m02 +
    matrix.m10 * matrix.m10 +
    matrix.m11 * matrix.m11 +
    matrix.m12 * matrix.m12 +
    matrix.m20 * matrix.m20 +
    matrix.m21 * matrix.m21 +
    matrix.m22 * matrix.m22
  let norm = norm_sq.sqrt()
  if norm < 1.0e-15 {
    None
  } else {
    Some(
      @math.Mat3x3::new(
        matrix.m00 / norm,
        matrix.m01 / norm,
        matrix.m02 / norm,
        matrix.m10 / norm,
        matrix.m11 / norm,
        matrix.m12 / norm,
        matrix.m20 / norm,
        matrix.m21 / norm,
        matrix.m22 / norm,
      ),
    )
  }
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
