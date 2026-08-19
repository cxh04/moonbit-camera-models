// Boundary Test Suite for Linear Solvers and Numerical Root Finders

///|
/// Boundary Test: Gaussian Elimination & Cramer's Rule Failure Modes
test "linear solvers degenerate system error handling" {
  let sing_3x3 = Mat3x3::new(1.0, 2.0, 3.0, 2.0, 4.0, 6.0, 1.0, 1.0, 1.0)
  let b_vec = Vec3::new(1.0, 2.0, 3.0)
  assert_true(solve_3x3_cramer(sing_3x3, b_vec) is None)

  let sing_arr = [[1.0, 2.0, 3.0], [2.0, 4.0, 6.0], [1.0, 1.0, 1.0]]
  let b_arr = [1.0, 2.0, 3.0]
  assert_true(solve_gaussian(sing_arr, b_arr) is None)

  let invalid_dim_a = [[1.0, 2.0], [3.0, 4.0]]
  let invalid_dim_b = [1.0, 2.0, 3.0]
  assert_true(solve_gaussian(invalid_dim_a, invalid_dim_b) is None)
}

///|
/// Boundary Test: Conjugate Gradient Solver Convergence & Edge Cases
test "conjugate gradient solver boundary convergence" {
  let spd_a = [[4.0, 1.0], [1.0, 3.0]]
  let b_arr = [1.0, 2.0]
  let x = solve_conjugate_gradient(spd_a, b_arr, 100, 1.0e-6).unwrap()

  // Verify A * x == b
  let ax0 = spd_a[0][0] * x[0] + spd_a[0][1] * x[1]
  let ax1 = spd_a[1][0] * x[0] + spd_a[1][1] * x[1]
  assert_true(approx_eq(ax0, b_arr[0], 1.0e-5))
  assert_true(approx_eq(ax1, b_arr[1], 1.0e-5))
}

///|
/// Boundary Test: Newton-Raphson & Polynomial Root Solver Degeneracy
test "polynomial solver edge cases and root verification" {
  // Degenerate quadratic a=0 -> linear b*x + c = 0
  let lin_roots = solve_quadratic(0.0, 2.0, -4.0)
  assert_eq(lin_roots.length(), 1)
  assert_true(approx_eq(lin_roots[0], 2.0, 1.0e-6))

  // Fully degenerate a=0, b=0 -> empty
  let empty_roots = solve_quadratic(0.0, 0.0, 5.0)
  assert_eq(empty_roots.length(), 0)

  // Negative discriminant -> empty
  let no_real_roots = solve_quadratic(1.0, 0.0, 4.0)
  assert_eq(no_real_roots.length(), 0)

  // Newton-Raphson root of P(x) = x^2 - 9 = 0 starting at x0 = 5.0
  let coeffs = [-9.0, 0.0, 1.0]
  let root = solve_newton_raphson(coeffs, 5.0, 50, 1.0e-6).unwrap()
  assert_true(approx_eq(root, 3.0, 1.0e-5))
}
