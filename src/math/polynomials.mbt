// Polynomial solvers and root finders for camera model distortion inversion

///|
/// Evaluate polynomial P(x) = c0 + c1*x + c2*x^2 + ... + cn*x^n via Horner's scheme
pub fn poly_eval(coeffs : Array[Double], x : Double) -> Double {
  let n = coeffs.length()
  if n == 0 {
    return 0.0
  }
  let mut acc = coeffs[n - 1]
  let mut i = n - 2
  while i >= 0 {
    acc = acc * x + coeffs[i]
    i -= 1
  }
  acc
}

///|
/// Evaluate polynomial derivative P'(x)
pub fn poly_eval_derivative(coeffs : Array[Double], x : Double) -> Double {
  let n = coeffs.length()
  if n <= 1 {
    return 0.0
  }
  let mut acc = coeffs[n - 1] * (n - 1).to_double()
  let mut i = n - 2
  while i >= 1 {
    acc = acc * x + coeffs[i] * i.to_double()
    i -= 1
  }
  acc
}

///|
/// Solve quadratic equation a*x^2 + b*x + c = 0
pub fn solve_quadratic(a : Double, b : Double, c : Double) -> Array[Double] {
  if a.abs() < 1.0e-15 {
    if b.abs() < 1.0e-15 {
      []
    } else {
      [-c / b]
    }
  } else {
    let disc = b * b - 4.0 * a * c
    if disc < 0.0 {
      []
    } else if disc == 0.0 {
      [-b / (2.0 * a)]
    } else {
      let sqrt_disc = disc.sqrt()
      [(-b - sqrt_disc) / (2.0 * a), (-b + sqrt_disc) / (2.0 * a)]
    }
  }
}

///|
/// Solve cubic equation x^3 + a*x^2 + b*x + c = 0 using Cardano's formula
pub fn solve_cubic(a : Double, b : Double, c : Double) -> Array[Double] {
  let q = (3.0 * b - a * a) / 9.0
  let r = (9.0 * a * b - 27.0 * c - 2.0 * a * a * a) / 54.0
  let disc = q * q * q + r * r

  let term1 = a / 3.0
  if disc > 0.0 {
    let s_val = r + disc.sqrt()
    let s = if s_val >= 0.0 {
      @cmath.pow(s_val, 1.0 / 3.0)
    } else {
      -@cmath.pow(-s_val, 1.0 / 3.0)
    }
    let t_val = r - disc.sqrt()
    let t = if t_val >= 0.0 {
      @cmath.pow(t_val, 1.0 / 3.0)
    } else {
      -@cmath.pow(-t_val, 1.0 / 3.0)
    }
    [s + t - term1]
  } else if disc == 0.0 {
    let r13 = if r >= 0.0 {
      @cmath.pow(r, 1.0 / 3.0)
    } else {
      -@cmath.pow(-r, 1.0 / 3.0)
    }
    [2.0 * r13 - term1, -r13 - term1]
  } else {
    let theta = @cmath.acos(r / (-q * q * q).sqrt())
    let sqrt_q = (-q).sqrt()
    let pi = 3.14159265358979323846
    [
      2.0 * sqrt_q * @cmath.cos(theta / 3.0) - term1,
      2.0 * sqrt_q * @cmath.cos((theta + 2.0 * pi) / 3.0) - term1,
      2.0 * sqrt_q * @cmath.cos((theta + 4.0 * pi) / 3.0) - term1,
    ]
  }
}

///|
/// Root finding via Newton-Raphson method with initial guess x0
pub fn solve_newton_raphson(
  coeffs : Array[Double],
  x0 : Double,
  max_iters : Int,
  tol : Double,
) -> Double? {
  let mut x = x0
  for _iter in 0..<max_iters {
    let fx = poly_eval(coeffs, x)
    if fx.abs() < tol {
      return Some(x)
    }
    let fpx = poly_eval_derivative(coeffs, x)
    if fpx.abs() < 1.0e-15 {
      return None
    }
    let dx = fx / fpx
    x -= dx
    if dx.abs() < tol {
      return Some(x)
    }
  }
  Some(x)
}
