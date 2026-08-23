// Extensive Boundary Test Suite for 3x3 and 4x4 Matrices and Decompositions

///|
/// Boundary Test: Mat3x3 Singular Matrix, Determinant Zero, and Inverse None
test "mat3x3 singular matrix and inverse failure handling" {
  let zero_mat = Mat3x3::zero()
  assert_eq(zero_mat.determinant(), 0.0)
  assert_true(zero_mat.inverse() is None)

  let rank1_mat = Mat3x3::new(1.0, 2.0, 3.0, 2.0, 4.0, 6.0, 3.0, 6.0, 9.0)
  assert_true(approx_eq(rank1_mat.determinant(), 0.0, 1.0e-9))
  assert_true(rank1_mat.inverse() is None)

  let eye = Mat3x3::identity()
  let inv_eye = eye.inverse().unwrap()
  assert_eq(inv_eye, eye)

  let a = Mat3x3::new(1.0, 0.0, 5.0, 2.0, 1.0, 6.0, 3.0, 4.0, 0.0)
  let inv_a = a.inverse().unwrap()
  let prod = a.mul_mat3x3(inv_a)
  assert_true(approx_eq(prod.m00, 1.0, 1.0e-6))
  assert_true(approx_eq(prod.m11, 1.0, 1.0e-6))
  assert_true(approx_eq(prod.m22, 1.0, 1.0e-6))
  assert_true(approx_eq(prod.m01, 0.0, 1.0e-6))
  assert_true(approx_eq(prod.m10, 0.0, 1.0e-6))
}

///|
/// Boundary Test: Mat4x4 Homogeneous Matrix Invariants
test "mat4x4 identity and homogeneous point transform boundaries" {
  let eye4 = Mat4x4::identity()
  let p = Vec3::new(-10.5, 42.0, 100.0)
  let p_trans = eye4.transform_point(p)
  assert_eq(p_trans, p)

  let rigid = RigidTransform::new(
    euler_to_mat3x3(0.1, -0.2, 0.3),
    Vec3::new(5.0, -2.0, 10.0),
  )
  let m4 = Mat4x4::from_rigid_transform(rigid)
  let p_rigid = rigid.transform_point(p)
  let p_m4 = m4.transform_point(p)

  assert_true(approx_eq(p_m4.x, p_rigid.x, 1.0e-6))
  assert_true(approx_eq(p_m4.y, p_rigid.y, 1.0e-6))
  assert_true(approx_eq(p_m4.z, p_rigid.z, 1.0e-6))
}

///|
/// Boundary Test: LU and QR Decompositions on Degenerate and Rectangular Matrices
test "lu and qr decomposition edge cases" {
  let empty_matrix : Array[Array[Double]] = []
  assert_true(lu_decompose(empty_matrix) is None)
  assert_true(qr_decompose(empty_matrix) is None)

  let sing_matrix = [[1.0, 2.0, 3.0], [2.0, 4.0, 6.0], [1.0, 1.0, 1.0]]
  assert_true(lu_decompose(sing_matrix) is None)

  let rect_matrix = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]]
  let qr = qr_decompose(rect_matrix).unwrap()
  assert_eq(qr.m, 3)
  assert_eq(qr.n, 2)
}

///|
/// Comprehensive Matrix Multiplication and Transpose Invariants (50 Matrices)
test "mat3x3 matrix algebra transpose multiplication invariants" {
  let mut i = 0
  while i < 50 {
    let a0 = (i % 5).to_double() + 1.0
    let a1 = (i * 3 % 7).to_double() - 3.0
    let a2 = (i * 2 % 4).to_double() + 0.5

    let a = Mat3x3::new(a0, a1, 0.0, 0.0, a2, a1, a1, 0.0, a0)
    let at = a.transpose()

    // (A^T)^T == A
    assert_eq(at.transpose(), a)

    // det(A^T) == det(A)
    assert_true(approx_eq(a.determinant(), at.determinant(), 1.0e-9))

    // det(A * B) == det(A) * det(B)
    let det_a = a.determinant()
    let det_at = at.determinant()
    let a_at = a.mul_mat3x3(at)
    assert_true(approx_eq(a_at.determinant(), det_a * det_at, 1.0e-5))

    i = i + 1
  }
}

///|
test "symmetric eigen solver rejects malformed matrices" {
  let malformed : Array[Array[Double]] = [[1.0, 0.0], [0.0]]
  assert_true(smallest_eigenvector_symmetric(malformed, 20) is None)
  assert_true(smallest_eigenvector_symmetric([], 20) is None)
  assert_true(
    smallest_eigenvector_symmetric([[1.0, 0.0], [0.0, 1.0]], 0) is None,
  )
}
