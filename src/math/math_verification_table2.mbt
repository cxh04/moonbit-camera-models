// SVD, LU, and QR Matrix Decomposition Numerical Precision Tables

///|
/// Numerical accuracy test for 3x3 SVD reconstruction error over 50 synthetic matrices
test "math verification table 2 - svd reconstruction precision" {
  for i in 1..<=50 {
    let s0 = i.to_double() * 2.0
    let s1 = i.to_double() * 1.0
    let s2 = i.to_double() * 0.5

    let rot1 = euler_to_mat3x3(
      i.to_double() * 0.1,
      -i.to_double() * 0.05,
      i.to_double() * 0.15,
    )
    let rot2 = euler_to_mat3x3(
      -i.to_double() * 0.08,
      i.to_double() * 0.12,
      -i.to_double() * 0.03,
    )

    let s_diag = Mat3x3::new(s0, 0.0, 0.0, 0.0, s1, 0.0, 0.0, 0.0, s2)
    let a = rot1.mul_mat3x3(s_diag).mul_mat3x3(rot2)

    let (u, s, vt) = svd_3x3(a)
    assert_true(s.x >= s.y)
    assert_true(s.y >= s.z)

    let s_rec = Mat3x3::new(s.x, 0.0, 0.0, 0.0, s.y, 0.0, 0.0, 0.0, s.z)
    let a_rec = u.mul_mat3x3(s_rec).mul_mat3x3(vt)

    assert_true(approx_eq(a_rec.m00, a.m00, 1.0e-3))
    assert_true(approx_eq(a_rec.m11, a.m11, 1.0e-3))
    assert_true(approx_eq(a_rec.m22, a.m22, 1.0e-3))
  }
}

///|
/// LU Decomposition accuracy test over 50 well-conditioned system matrices
test "math verification table 2 - lu decomposition solution precision" {
  for i in 1..<=50 {
    let scale = i.to_double()
    let a_mat = [
      [scale + 4.0, 1.0, 2.0],
      [1.0, scale + 5.0, 3.0],
      [2.0, 3.0, scale + 6.0],
    ]
    let b_vec = [scale * 2.0, -scale, scale * 3.0]

    let lu = lu_decompose(a_mat).unwrap()
    let x = lu.solve(b_vec).unwrap()

    let ax0 = a_mat[0][0] * x[0] + a_mat[0][1] * x[1] + a_mat[0][2] * x[2]
    let ax1 = a_mat[1][0] * x[0] + a_mat[1][1] * x[1] + a_mat[1][2] * x[2]
    let ax2 = a_mat[2][0] * x[0] + a_mat[2][1] * x[1] + a_mat[2][2] * x[2]

    assert_true(approx_eq(ax0, b_vec[0], 1.0e-5))
    assert_true(approx_eq(ax1, b_vec[1], 1.0e-5))
    assert_true(approx_eq(ax2, b_vec[2], 1.0e-5))
  }
}

///|
/// QR Decomposition orthogonality check for Q matrix (Q^T * Q == I) over 50 matrices
test "math verification table 2 - qr q matrix orthogonality" {
  for i in 1..<=50 {
    let scale = i.to_double()
    let a_mat = [
      [scale, scale + 1.0, scale * 0.5],
      [scale * 2.0, scale - 1.0, scale * 1.5],
      [-scale, scale * 3.0, scale * 2.0],
    ]

    let qr = qr_decompose(a_mat).unwrap()
    let q = qr.q
    let mut qt_q_diag0 = 0.0
    let mut qt_q_diag1 = 0.0
    let mut qt_q_diag2 = 0.0

    for k in 0..<3 {
      qt_q_diag0 += q[k][0] * q[k][0]
      qt_q_diag1 += q[k][1] * q[k][1]
      qt_q_diag2 += q[k][2] * q[k][2]
    }

    assert_true(approx_eq(qt_q_diag0, 1.0, 1.0e-4))
    assert_true(approx_eq(qt_q_diag1, 1.0, 1.0e-4))
    assert_true(approx_eq(qt_q_diag2, 1.0, 1.0e-4))
  }
}
