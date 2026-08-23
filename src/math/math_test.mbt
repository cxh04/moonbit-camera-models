// Math test suite for vectors, matrices, decompositions, solvers, and Lie Algebra

///|
test "vec2 math ops" {
  let v1 = Vec2::new(3.0, 4.0)
  let v2 = Vec2::new(1.0, 2.0)
  assert_eq(v1.norm(), 5.0)
  assert_eq(v1.dot(v2), 11.0)
  assert_eq(v1.cross(v2), 2.0)
  let norm_v1 = v1.normalized()
  assert_true(approx_eq(norm_v1.norm(), 1.0, 1.0e-6))
  let rot = v1.rotate(1.57079632679)
  assert_true(approx_eq(rot.x, -4.0, 1.0e-4))
  assert_true(approx_eq(rot.y, 3.0, 1.0e-4))
}

///|
test "vec3 cross product, slerp, and distance" {
  let vx = Vec3::unit_x()
  let vy = Vec3::unit_y()
  let vz = vx.cross(vy)
  assert_eq(vz, Vec3::unit_z())
  let p1 = Vec3::new(1.0, 2.0, 3.0)
  let p2 = Vec3::new(4.0, 6.0, 3.0)
  assert_eq(p1.distance(p2), 5.0)

  let slerp_mid = vx.slerp(vy, 0.5)
  assert_true(approx_eq(slerp_mid.x, 0.70710678, 1.0e-4))
  assert_true(approx_eq(slerp_mid.y, 0.70710678, 1.0e-4))
}

///|
test "mat3x3 identity, determinant, and inverse" {
  let m = Mat3x3::identity()
  let v = Vec3::new(2.5, -3.0, 7.1)
  assert_eq(m.mul_vec3(v), v)
  assert_eq(m.determinant(), 1.0)
  let inv = m.inverse().unwrap()
  assert_eq(inv, m)

  let skew = Mat3x3::skew_symmetric(Vec3::new(1.0, 2.0, 3.0))
  assert_eq(skew.m01, -3.0)
  assert_eq(skew.m02, 2.0)
  assert_eq(skew.m12, -1.0)
}

///|
test "lu and qr matrix decomposition" {
  let a = [[4.0, 3.0, 2.0], [3.0, 2.0, 1.0], [2.0, 1.0, 3.0]]
  let b = [1.0, 2.0, 3.0]
  let lu = lu_decompose(a).unwrap()
  let x = lu.solve(b).unwrap()

  let ax0 = a[0][0] * x[0] + a[0][1] * x[1] + a[0][2] * x[2]
  assert_true(approx_eq(ax0, b[0], 1.0e-6))

  let qr = qr_decompose(a).unwrap()
  assert_eq(qr.m, 3)
  assert_eq(qr.n, 3)
}

///|
test "svd 3x3 decomposition" {
  let a = Mat3x3::new(1.0, 2.0, 3.0, 0.0, 1.0, 4.0, 5.0, 6.0, 0.0)
  let (_u, s, _vt) = svd_3x3(a)
  assert_true(s.x >= s.y)
  assert_true(s.y >= s.z)
  assert_true(s.z >= 0.0)
}

///|
test "smallest symmetric eigenvector" {
  let matrix = [[4.0, 1.0, 0.0], [1.0, 3.0, 0.0], [0.0, 0.0, 2.0]]
  let eigenvector = smallest_eigenvector_symmetric(matrix, 100).unwrap()
  let residual = matrix[0][0] * eigenvector[0] +
    matrix[0][1] * eigenvector[1] +
    matrix[0][2] * eigenvector[2]
  let residual_1 = matrix[1][0] * eigenvector[0] +
    matrix[1][1] * eigenvector[1] +
    matrix[1][2] * eigenvector[2]
  let residual_2 = matrix[2][0] * eigenvector[0] +
    matrix[2][1] * eigenvector[1] +
    matrix[2][2] * eigenvector[2]
  assert_true(eigenvector[2].abs() > 0.99)
  assert_true(residual.abs() < 1.0e-6)
  assert_true(residual_1.abs() < 1.0e-6)
  assert_true((residual_2 - 2.0 * eigenvector[2]).abs() < 1.0e-6)
}

///|
test "smallest symmetric eigenvector rotates dense two by two block" {
  let matrix = [[4.0, 1.0, 0.0], [1.0, 3.0, 0.0], [0.0, 0.0, 10.0]]
  let eigenvector = smallest_eigenvector_symmetric(matrix, 100).unwrap()
  let lambda = 2.381966011250105
  let residual_x = 4.0 * eigenvector[0] +
    eigenvector[1] -
    lambda * eigenvector[0]
  let residual_y = eigenvector[0] +
    3.0 * eigenvector[1] -
    lambda * eigenvector[1]
  assert_true(eigenvector[2].abs() < 1.0e-6)
  assert_true(residual_x.abs() < 1.0e-6)
  assert_true(residual_y.abs() < 1.0e-6)
}

///|
test "solvers cramer and gaussian" {
  let a = Mat3x3::new(2.0, 1.0, -1.0, -3.0, -1.0, 2.0, -2.0, 1.0, 2.0)
  let b = Vec3::new(8.0, -11.0, -3.0)
  let x = solve_3x3_cramer(a, b).unwrap()
  let ax = a.mul_vec3(x)
  assert_true(approx_eq(ax.x, b.x, 1.0e-5))
  assert_true(approx_eq(ax.y, b.y, 1.0e-5))
  assert_true(approx_eq(ax.z, b.z, 1.0e-5))

  let a_mat = [[2.0, 1.0, -1.0], [-3.0, -1.0, 2.0], [-2.0, 1.0, 2.0]]
  let b_arr = [8.0, -11.0, -3.0]
  let x_g = solve_gaussian(a_mat, b_arr).unwrap()
  assert_true(approx_eq(x_g[0], x.x, 1.0e-5))
}

///|
test "polynomial root finding" {
  let quad_roots = solve_quadratic(1.0, -5.0, 6.0)
  assert_eq(quad_roots.length(), 2)
  assert_true(approx_eq(quad_roots[0], 2.0, 1.0e-5))
  assert_true(approx_eq(quad_roots[1], 3.0, 1.0e-5))

  let cubic_roots = solve_cubic(0.0, -6.0, -20.0)
  assert_true(cubic_roots.length() >= 1)
}

///|
test "se3 exp and log Lie map" {
  let v = Vec3::new(1.0, -2.0, 3.0)
  let omega = Vec3::new(0.05, -0.1, 0.2)
  let pose = se3_exp((v, omega))
  let (v_rec, omega_rec) = se3_log(pose)

  assert_true(approx_eq(v_rec.x, v.x, 1.0e-4))
  assert_true(approx_eq(v_rec.y, v.y, 1.0e-4))
  assert_true(approx_eq(v_rec.z, v.z, 1.0e-4))
  assert_true(approx_eq(omega_rec.x, omega.x, 1.0e-4))
  assert_true(approx_eq(omega_rec.y, omega.y, 1.0e-4))
  assert_true(approx_eq(omega_rec.z, omega.z, 1.0e-4))
}
