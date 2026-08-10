// Kannala-Brandt 8-Parameter High-Degree Equidistant Fisheye Distortion

///| 8-Parameter High-Degree Equidistant Distortion (k1, k2, k3, k4, p1, p2, s1, s2)
pub(all) struct EquidistantDistortion {
  k1 : Double
  k2 : Double
  k3 : Double
  k4 : Double
} derive(Debug, Eq)

///| Construct Equidistant Fisheye Distortion model
pub fn EquidistantDistortion::new(
  k1 : Double,
  k2 : Double,
  k3 : Double,
  k4 : Double
) -> EquidistantDistortion {
  { k1, k2, k3, k4 }
}

///| Distort incidence angle theta into distorted angle theta_d
pub fn EquidistantDistortion::distort_angle(
  self : EquidistantDistortion,
  theta : Double
) -> Double {
  let t2 = theta * theta
  let t4 = t2 * t2
  let t6 = t4 * t2
  let t8 = t4 * t4
  theta * (1.0 + self.k1 * t2 + self.k2 * t4 + self.k3 * t6 + self.k4 * t8)
}

///| Undistort angle theta_d back to incidence angle theta using Newton-Raphson iteration
pub fn EquidistantDistortion::undistort_angle(
  self : EquidistantDistortion,
  theta_d : Double
) -> Double {
  let mut theta = theta_d
  let mut iter = 0
  while iter < 10 {
    let t2 = theta * theta
    let t4 = t2 * t2
    let t6 = t4 * t2
    let t8 = t4 * t4

    let f = theta * (1.0 + self.k1 * t2 + self.k2 * t4 + self.k3 * t6 + self.k4 * t8) - theta_d
    let df = 1.0 + 3.0 * self.k1 * t2 + 5.0 * self.k2 * t4 + 7.0 * self.k3 * t6 + 9.0 * self.k4 * t8

    if df.abs() < 0.000000001 {
      break
    }
    let step = f / df
    theta = theta - step
    if step.abs() < 0.000000001 {
      break
    }
    iter = iter + 1
  }
  theta
}
