// Math Numerical Verification Tables - Set 2: Matrix Inverse, Determinant, and Gaussian Elimination Solvers

///|
/// Test 3x3 matrix inverse identity product (A * A^-1 == I) for 150 random matrices
test "math numerical tables 2 - 3x3 matrix inverse identity grid" {
  for i in 1..<=150 {
    let scale = i.to_double() * 0.1
    let a = Mat3x3::new(
      scale + 2.0,
      0.5,
      -0.2,
      0.1,
      scale + 3.0,
      0.4,
      -0.3,
      0.2,
      scale + 4.0,
    )

    let det = a.determinant()
    assert_true(det.abs() > 0.1)

    let a_inv = a.inverse().unwrap()
    let prod = a.mul_mat3x3(a_inv)

    assert_true(approx_eq(prod.m00, 1.0, 1.0e-5))
    assert_true(approx_eq(prod.m11, 1.0, 1.0e-5))
    assert_true(approx_eq(prod.m22, 1.0, 1.0e-5))
    assert_true(approx_eq(prod.m01, 0.0, 1.0e-5))
    assert_true(approx_eq(prod.m02, 0.0, 1.0e-5))
    assert_true(approx_eq(prod.m10, 0.0, 1.0e-5))
    assert_true(approx_eq(prod.m12, 0.0, 1.0e-5))
    assert_true(approx_eq(prod.m20, 0.0, 1.0e-5))
    assert_true(approx_eq(prod.m21, 0.0, 1.0e-5))
  }
}

///|
/// Test Cramer's 3x3 linear solver accuracy over 100 linear systems
test "math numerical tables 2 - cramer 3x3 solver accuracy" {
  for i in 1..<=100 {
    let scale = i.to_double() * 0.1
    let a = Mat3x3::new(
      scale + 3.0,
      1.0,
      0.0,
      1.0,
      scale + 4.0,
      1.0,
      0.0,
      1.0,
      scale + 5.0,
    )
    let b = Vec3::new(scale * 2.0, -scale, scale * 3.0)

    let sol = solve_3x3_cramer(a, b).unwrap()
    let ax = a.mul_vec3(sol)

    assert_true(approx_eq(ax.x, b.x, 1.0e-5))
    assert_true(approx_eq(ax.y, b.y, 1.0e-5))
    assert_true(approx_eq(ax.z, b.z, 1.0e-5))
  }
}

///|
/// Test Gaussian elimination with partial pivoting over 100 linear systems
test "math numerical tables 2 - gaussian elimination pivoting accuracy" {
  for i in 1..<=100 {
    let scale = i.to_double()
    let a_rows = [
      [scale + 5.0, 2.0, -1.0],
      [2.0, scale + 6.0, 3.0],
      [-1.0, 3.0, scale + 7.0],
    ]
    let b_vec = [scale, scale * 2.0, -scale]

    let sol = solve_gaussian(a_rows, b_vec).unwrap()

    let ax0 = a_rows[0][0] * sol[0] +
      a_rows[0][1] * sol[1] +
      a_rows[0][2] * sol[2]
    let ax1 = a_rows[1][0] * sol[0] +
      a_rows[1][1] * sol[1] +
      a_rows[1][2] * sol[2]
    let ax2 = a_rows[2][0] * sol[0] +
      a_rows[2][1] * sol[1] +
      a_rows[2][2] * sol[2]

    assert_true(approx_eq(ax0, b_vec[0], 1.0e-5))
    assert_true(approx_eq(ax1, b_vec[1], 1.0e-5))
    assert_true(approx_eq(ax2, b_vec[2], 1.0e-5))
  }
}
