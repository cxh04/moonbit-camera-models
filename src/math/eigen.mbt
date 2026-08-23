// Symmetric eigenvalue routines used by homogeneous camera estimators

///|
/// Return a unit eigenvector associated with the smallest eigenvalue of a
/// real symmetric matrix.
///
/// The Jacobi method is deliberately kept allocation-friendly and backend
/// independent. It is suitable for the small normal matrices used by the
/// eight-point and PnP estimators (typically 9x9 and 12x12).
pub fn smallest_eigenvector_symmetric(
  matrix : Array[Array[Double]],
  max_iter : Int,
) -> Array[Double]? {
  let n = matrix.length()
  if n < 2 || max_iter <= 0 {
    None
  } else {
    let mut valid = true
    for i in 0..<n {
      if matrix[i].length() != n {
        valid = false
      }
    }
    let a = Array::make(n, Array::make(n, 0.0))
    let eigenvectors = Array::make(n, Array::make(n, 0.0))
    if valid {
      for i in 0..<n {
        let row = Array::make(n, 0.0)
        let basis = Array::make(n, 0.0)
        basis[i] = 1.0
        eigenvectors[i] = basis
        for j in 0..<n {
          // Symmetrising also makes the routine robust to tiny round-off
          // differences introduced while constructing normal equations.
          row[j] = (matrix[i][j] + matrix[j][i]) * 0.5
        }
        a[i] = row
      }
    }
    if !valid {
      None
    } else {
      for _iter in 0..<max_iter {
        let (p, q, largest) = largest_off_diagonal(a)
        if largest < 1.0e-14 {
          break
        }

        let app = a[p][p]
        let aqq = a[q][q]
        let apq = a[p][q]
        let tau = (aqq - app) / (2.0 * apq)
        let t = if tau >= 0.0 {
          1.0 / (tau + (1.0 + tau * tau).sqrt())
        } else {
          -1.0 / (-tau + (1.0 + tau * tau).sqrt())
        }
        let c = 1.0 / (1.0 + t * t).sqrt()
        let s = t * c

        for k in 0..<n {
          if k != p && k != q {
            let akp = a[k][p]
            let akq = a[k][q]
            let new_kp = c * akp - s * akq
            let new_kq = s * akp + c * akq
            a[k][p] = new_kp
            a[p][k] = new_kp
            a[k][q] = new_kq
            a[q][k] = new_kq
          }
        }

        a[p][p] = c * c * app - 2.0 * s * c * apq + s * s * aqq
        a[q][q] = s * s * app + 2.0 * s * c * apq + c * c * aqq
        a[p][q] = 0.0
        a[q][p] = 0.0

        // The columns of V accumulate the same Jacobi rotations as A.
        for k in 0..<n {
          let vkp = eigenvectors[k][p]
          let vkq = eigenvectors[k][q]
          eigenvectors[k][p] = c * vkp - s * vkq
          eigenvectors[k][q] = s * vkp + c * vkq
        }
      }

      let mut smallest = 0
      for i in 1..<n {
        if a[i][i] < a[smallest][smallest] {
          smallest = i
        }
      }
      let result = Array::make(n, 0.0)
      let mut norm_sq = 0.0
      for i in 0..<n {
        result[i] = eigenvectors[i][smallest]
        norm_sq += result[i] * result[i]
      }
      let norm = norm_sq.sqrt()
      if norm < 1.0e-15 {
        None
      } else {
        for i in 0..<n {
          result[i] /= norm
        }
        Some(result)
      }
    }
  }
}

///|
fn largest_off_diagonal(matrix : Array[Array[Double]]) -> (Int, Int, Double) {
  let n = matrix.length()
  let mut p = 0
  let mut q = if n > 1 { 1 } else { 0 }
  let mut largest = 0.0
  for i in 0..<n {
    for j in (i + 1)..<n {
      let value = matrix[i][j].abs()
      if value > largest {
        largest = value
        p = i
        q = j
      }
    }
  }
  (p, q, largest)
}
