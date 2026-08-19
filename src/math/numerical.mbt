// Numerical differentiation and integration utilities

///|
/// Compute numerical derivative of 1D scalar function f(x) via central finite difference
pub fn num_derivative_central(
  f : (Double) -> Double,
  x : Double,
  h : Double,
) -> Double {
  (f(x + h) - f(x - h)) / (2.0 * h)
}

///|
/// Compute numerical gradient of multi-variable scalar function f(x) at point x
pub fn num_gradient(
  f : (Array[Double]) -> Double,
  x : Array[Double],
  h : Double,
) -> Array[Double] {
  let n = x.length()
  let grad = Array::make(n, 0.0)
  let x_plus = Array::make(n, 0.0)
  let x_minus = Array::make(n, 0.0)
  for i in 0..<n {
    x_plus[i] = x[i]
    x_minus[i] = x[i]
  }

  for i in 0..<n {
    x_plus[i] = x[i] + h
    x_minus[i] = x[i] - h
    grad[i] = (f(x_plus) - f(x_minus)) / (2.0 * h)
    x_plus[i] = x[i]
    x_minus[i] = x[i]
  }
  grad
}

///|
/// Compute Jacobian matrix (M x N) for vector-valued function f: R^N -> R^M at x
pub fn num_jacobian(
  f : (Array[Double]) -> Array[Double],
  x : Array[Double],
  h : Double,
) -> Array[Array[Double]] {
  let n = x.length()
  let f0 = f(x)
  let m = f0.length()

  let jac = Array::make(m, Array::make(n, 0.0))
  for i in 0..<m {
    jac[i] = Array::make(n, 0.0)
  }

  let x_plus = Array::make(n, 0.0)
  let x_minus = Array::make(n, 0.0)
  for j in 0..<n {
    x_plus[j] = x[j]
    x_minus[j] = x[j]
  }

  for j in 0..<n {
    x_plus[j] = x[j] + h
    x_minus[j] = x[j] - h
    let f_p = f(x_plus)
    let f_m = f(x_minus)
    for i in 0..<m {
      jac[i][j] = (f_p[i] - f_m[i]) / (2.0 * h)
    }
    x_plus[j] = x[j]
    x_minus[j] = x[j]
  }
  jac
}

///|
/// Numerical integration using Simpson's rule over interval [a, b] with N steps
pub fn simpson_integrate(
  f : (Double) -> Double,
  a : Double,
  b : Double,
  n_steps : Int,
) -> Double {
  let n = if n_steps % 2 == 1 { n_steps + 1 } else { n_steps }
  let h = (b - a) / n.to_double()
  let mut sum = f(a) + f(b)

  for i in 1..<n {
    let x = a + i.to_double() * h
    let weight = if i % 2 == 1 { 4.0 } else { 2.0 }
    sum += weight * f(x)
  }
  sum * h / 3.0
}
