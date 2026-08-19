// Linear system solvers and optimization subroutines in MoonBit

///|
/// Solve 3x3 linear system A * x = b via Cramer's rule
pub fn solve_3x3_cramer(a : Mat3x3, b : Vec3) -> Vec3? {
  let det = a.determinant()
  if det == 0.0 {
    None
  } else {
    let det_x = Mat3x3::new(
      b.x,
      a.m01,
      a.m02,
      b.y,
      a.m11,
      a.m12,
      b.z,
      a.m21,
      a.m22,
    ).determinant()
    let det_y = Mat3x3::new(
      a.m00,
      b.x,
      a.m02,
      a.m10,
      b.y,
      a.m12,
      a.m20,
      b.z,
      a.m22,
    ).determinant()
    let det_z = Mat3x3::new(
      a.m00,
      a.m01,
      b.x,
      a.m10,
      a.m11,
      b.y,
      a.m20,
      a.m21,
      b.z,
    ).determinant()

    Some(Vec3::new(det_x / det, det_y / det, det_z / det))
  }
}

///|
/// Gaussian elimination solver for NxN system A * x = b
pub fn solve_gaussian(
  a : Array[Array[Double]],
  b : Array[Double],
) -> Array[Double]? {
  let n = a.length()
  if n == 0 || b.length() != n {
    return None
  }

  let aug = Array::make(n, Array::make(n + 1, 0.0))
  for i in 0..<n {
    if a[i].length() != n {
      return None
    }
    let row = Array::make(n + 1, 0.0)
    for j in 0..<n {
      row[j] = a[i][j]
    }
    row[n] = b[i]
    aug[i] = row
  }

  for k in 0..<n {
    let mut max_row = k
    let mut max_val = aug[k][k].abs()
    for i in (k + 1)..<n {
      let val = aug[i][k].abs()
      if val > max_val {
        max_val = val
        max_row = i
      }
    }
    if max_val < 1.0e-15 {
      return None
    }

    if max_row != k {
      let tmp = aug[k]
      aug[k] = aug[max_row]
      aug[max_row] = tmp
    }

    let pivot = aug[k][k]
    for j in k..<=n {
      aug[k][j] /= pivot
    }

    for i in (k + 1)..<n {
      let factor = aug[i][k]
      for j in k..<=n {
        aug[i][j] -= factor * aug[k][j]
      }
    }
  }

  let x = Array::make(n, 0.0)
  for i_rev in 0..<n {
    let i = n - 1 - i_rev
    let mut sum = aug[i][n]
    for j in (i + 1)..<n {
      sum -= aug[i][j] * x[j]
    }
    x[i] = sum
  }

  Some(x)
}

///|
/// Conjugate Gradient solver for symmetric positive-definite linear system A * x = b
pub fn solve_conjugate_gradient(
  a : Array[Array[Double]],
  b : Array[Double],
  max_iters : Int,
  tol : Double,
) -> Array[Double]? {
  let n = b.length()
  if n == 0 || a.length() != n {
    return None
  }

  let x = Array::make(n, 0.0)
  let r = Array::make(n, 0.0)
  let p = Array::make(n, 0.0)

  for i in 0..<n {
    r[i] = b[i]
    p[i] = r[i]
  }

  let mut rs_old = 0.0
  for i in 0..<n {
    rs_old += r[i] * r[i]
  }
  if rs_old.sqrt() < tol {
    return Some(x)
  }

  let ap = Array::make(n, 0.0)
  for _iter in 0..<max_iters {
    for i in 0..<n {
      let mut sum = 0.0
      for j in 0..<n {
        sum += a[i][j] * p[j]
      }
      ap[i] = sum
    }

    let mut p_ap = 0.0
    for i in 0..<n {
      p_ap += p[i] * ap[i]
    }
    if p_ap.abs() < 1.0e-15 {
      break
    }

    let alpha = rs_old / p_ap
    for i in 0..<n {
      x[i] += alpha * p[i]
      r[i] -= alpha * ap[i]
    }

    let mut rs_new = 0.0
    for i in 0..<n {
      rs_new += r[i] * r[i]
    }
    if rs_new.sqrt() < tol {
      return Some(x)
    }

    let beta = rs_new / rs_old
    for i in 0..<n {
      p[i] = r[i] + beta * p[i]
    }
    rs_old = rs_new
  }

  Some(x)
}
