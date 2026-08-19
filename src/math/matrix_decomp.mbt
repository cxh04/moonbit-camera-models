// Matrix decomposition routines: SVD, LU, QR, Cholesky for camera math in MoonBit

///|
/// LU Decomposition result for NxN matrix A = L * U (with row permutation pivot array)
pub(all) struct LUDecomp {
  lu : Array[Array[Double]]
  pivots : Array[Int]
  det_sign : Double
  n : Int
} derive(Debug)

///|
/// Compute LU decomposition of square matrix A (NxN) using Partial Pivoting
pub fn lu_decompose(a : Array[Array[Double]]) -> LUDecomp? {
  let n = a.length()
  if n == 0 {
    return None
  }
  for i in 0..<n {
    if a[i].length() != n {
      return None
    }
  }
  let lu = Array::make(n, Array::make(n, 0.0))
  for i in 0..<n {
    let row = Array::make(n, 0.0)
    for j in 0..<n {
      row[j] = a[i][j]
    }
    lu[i] = row
  }
  let pivots = Array::make(n, 0)
  for i in 0..<n {
    pivots[i] = i
  }
  let mut det_sign = 1.0

  for k in 0..<n {
    let mut max_val = 0.0
    let mut max_row = k
    for i in k..<n {
      let val = lu[i][k].abs()
      if val > max_val {
        max_val = val
        max_row = i
      }
    }
    if max_val == 0.0 {
      return None
    }
    if max_row != k {
      let tmp_row = lu[k]
      lu[k] = lu[max_row]
      lu[max_row] = tmp_row
      let tmp_p = pivots[k]
      pivots[k] = pivots[max_row]
      pivots[max_row] = tmp_p
      det_sign = -det_sign
    }
    for i in (k + 1)..<n {
      lu[i][k] /= lu[k][k]
      for j in (k + 1)..<n {
        lu[i][j] -= lu[i][k] * lu[k][j]
      }
    }
  }

  Some({ lu, pivots, det_sign, n })
}

///|
/// Solve A * x = b given LU decomposition
pub fn LUDecomp::solve(self : LUDecomp, b : Array[Double]) -> Array[Double]? {
  if b.length() != self.n {
    return None
  }
  let x = Array::make(self.n, 0.0)
  for i in 0..<self.n {
    x[i] = b[self.pivots[i]]
  }
  // Forward substitution for L * y = b_perm
  for i in 0..<self.n {
    for j in 0..<i {
      x[i] -= self.lu[i][j] * x[j]
    }
  }
  // Back substitution for U * x = y
  for i_rev in 0..<self.n {
    let i = self.n - 1 - i_rev
    for j in (i + 1)..<self.n {
      x[i] -= self.lu[i][j] * x[j]
    }
    if self.lu[i][i] == 0.0 {
      return None
    }
    x[i] /= self.lu[i][i]
  }
  Some(x)
}

///|
/// QR Decomposition result for M x N matrix A = Q * R
pub(all) struct QRDecomp {
  q : Array[Array[Double]] // M x M orthogonal matrix
  r : Array[Array[Double]] // M x N upper triangular matrix
  m : Int
  n : Int
} derive(Debug)

///|
/// Compute QR decomposition of M x N matrix A using Gram-Schmidt orthogonalization
pub fn qr_decompose(a : Array[Array[Double]]) -> QRDecomp? {
  let m = a.length()
  if m == 0 {
    return None
  }
  let n = a[0].length()
  if n == 0 {
    return None
  }

  let q = Array::make(m, Array::make(m, 0.0))
  let r = Array::make(m, Array::make(n, 0.0))
  for i in 0..<m {
    q[i] = Array::make(m, 0.0)
    r[i] = Array::make(n, 0.0)
  }

  let v = Array::make(n, Array::make(m, 0.0))
  for j in 0..<n {
    let col = Array::make(m, 0.0)
    for i in 0..<m {
      col[i] = a[i][j]
    }
    v[j] = col
  }

  let q_cols = Array::make(n, Array::make(m, 0.0))
  for j in 0..<n {
    let mut norm_sq = 0.0
    for i in 0..<m {
      norm_sq += v[j][i] * v[j][i]
    }
    let r_jj = norm_sq.sqrt()
    r[j][j] = r_jj
    if r_jj < 1.0e-12 {
      let q_col = Array::make(m, 0.0)
      q_cols[j] = q_col
    } else {
      let q_col = Array::make(m, 0.0)
      for i in 0..<m {
        q_col[i] = v[j][i] / r_jj
      }
      q_cols[j] = q_col
      for k in (j + 1)..<n {
        let mut dot = 0.0
        for i in 0..<m {
          dot += q_cols[j][i] * v[k][i]
        }
        r[j][k] = dot
        for i in 0..<m {
          v[k][i] -= dot * q_cols[j][i]
        }
      }
    }
  }

  for i in 0..<m {
    for j in 0..<n {
      if j < m {
        q[i][j] = q_cols[j][i]
      }
    }
  }

  Some({ q, r, m, n })
}

///|
/// SVD (Singular Value Decomposition) result A = U * S * V^T
pub(all) struct SVDResult {
  u : Array[Array[Double]] // M x M orthogonal
  s : Array[Double] // Singular values min(M, N) sorted descending
  vt : Array[Array[Double]] // N x N orthogonal transpose
  m : Int
  n : Int
} derive(Debug)

///|
/// Compute 3x3 SVD specifically optimized for camera rotation and matrix estimation
pub fn svd_3x3(a : Mat3x3) -> (Mat3x3, Vec3, Mat3x3) {
  let mut v = Mat3x3::identity()
  let mut ata = a.transpose().mul_mat3x3(a)

  for _iter in 0..<30 {
    let off_diag = ata.m01.abs() + ata.m02.abs() + ata.m12.abs()
    if off_diag < 1.0e-15 {
      break
    }

    // Rotate (0, 1)
    if ata.m01.abs() > 1.0e-15 {
      let tau = (ata.m11 - ata.m00) / (2.0 * ata.m01)
      let t = if tau >= 0.0 {
        1.0 / (tau + (1.0 + tau * tau).sqrt())
      } else {
        -1.0 / (-tau + (1.0 + tau * tau).sqrt())
      }
      let c = 1.0 / (1.0 + t * t).sqrt()
      let s = t * c
      let j01 = Mat3x3::new(c, s, 0.0, -s, c, 0.0, 0.0, 0.0, 1.0)
      v = v.mul_mat3x3(j01)
      ata = j01.transpose().mul_mat3x3(ata).mul_mat3x3(j01)
    }
    // Rotate (0, 2)
    if ata.m02.abs() > 1.0e-15 {
      let tau = (ata.m22 - ata.m00) / (2.0 * ata.m02)
      let t = if tau >= 0.0 {
        1.0 / (tau + (1.0 + tau * tau).sqrt())
      } else {
        -1.0 / (-tau + (1.0 + tau * tau).sqrt())
      }
      let c = 1.0 / (1.0 + t * t).sqrt()
      let s = t * c
      let j02 = Mat3x3::new(c, 0.0, s, 0.0, 1.0, 0.0, -s, 0.0, c)
      v = v.mul_mat3x3(j02)
      ata = j02.transpose().mul_mat3x3(ata).mul_mat3x3(j02)
    }
    // Rotate (1, 2)
    if ata.m12.abs() > 1.0e-15 {
      let tau = (ata.m22 - ata.m11) / (2.0 * ata.m12)
      let t = if tau >= 0.0 {
        1.0 / (tau + (1.0 + tau * tau).sqrt())
      } else {
        -1.0 / (-tau + (1.0 + tau * tau).sqrt())
      }
      let c = 1.0 / (1.0 + t * t).sqrt()
      let s = t * c
      let j12 = Mat3x3::new(1.0, 0.0, 0.0, 0.0, c, s, 0.0, -s, c)
      v = v.mul_mat3x3(j12)
      ata = j12.transpose().mul_mat3x3(ata).mul_mat3x3(j12)
    }
  }

  let mut s0 = ata.m00.sqrt()
  let mut s1 = ata.m11.sqrt()
  let mut s2 = ata.m22.sqrt()

  let av = a.mul_mat3x3(v)
  let mut u0 = if s0 > 1.0e-12 {
    av.mul_vec3(Vec3::unit_x()).div_scalar(s0)
  } else {
    Vec3::unit_x()
  }
  let mut u1 = if s1 > 1.0e-12 {
    av.mul_vec3(Vec3::unit_y()).div_scalar(s1)
  } else {
    Vec3::unit_y()
  }
  let mut u2 = if s2 > 1.0e-12 {
    av.mul_vec3(Vec3::unit_z()).div_scalar(s2)
  } else {
    Vec3::unit_z()
  }

  let mut v_t = v.transpose()

  // Sort singular values descending
  if s0 < s1 {
    let tmp_s = s0
    s0 = s1
    s1 = tmp_s
    let tmp_u = u0
    u0 = u1
    u1 = tmp_u
    let row0 = Vec3::new(v_t.m00, v_t.m01, v_t.m02)
    let row1 = Vec3::new(v_t.m10, v_t.m11, v_t.m12)
    v_t = Mat3x3::new(
      row1.x,
      row1.y,
      row1.z,
      row0.x,
      row0.y,
      row0.z,
      v_t.m20,
      v_t.m21,
      v_t.m22,
    )
  }
  if s1 < s2 {
    let tmp_s = s1
    s1 = s2
    s2 = tmp_s
    let tmp_u = u1
    u1 = u2
    u2 = tmp_u
    let row1 = Vec3::new(v_t.m10, v_t.m11, v_t.m12)
    let row2 = Vec3::new(v_t.m20, v_t.m21, v_t.m22)
    v_t = Mat3x3::new(
      v_t.m00,
      v_t.m01,
      v_t.m02,
      row2.x,
      row2.y,
      row2.z,
      row1.x,
      row1.y,
      row1.z,
    )
  }
  if s0 < s1 {
    let tmp_s = s0
    s0 = s1
    s1 = tmp_s
    let tmp_u = u0
    u0 = u1
    u1 = tmp_u
    let row0 = Vec3::new(v_t.m00, v_t.m01, v_t.m02)
    let row1 = Vec3::new(v_t.m10, v_t.m11, v_t.m12)
    v_t = Mat3x3::new(
      row1.x,
      row1.y,
      row1.z,
      row0.x,
      row0.y,
      row0.z,
      v_t.m20,
      v_t.m21,
      v_t.m22,
    )
  }

  let s_vec = Vec3::new(s0, s1, s2)
  let u_mat = Mat3x3::new(u0.x, u1.x, u2.x, u0.y, u1.y, u2.y, u0.z, u1.z, u2.z)

  (u_mat, s_vec, v_t)
}
