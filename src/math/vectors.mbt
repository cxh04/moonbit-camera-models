// Vector math routines for 2D, 3D, 4D, and ND space in MoonBit Camera Models

///|
pub(all) struct Vec2 {
  x : Double
  y : Double
} derive(Debug, Eq)

///|
pub fn Vec2::new(x : Double, y : Double) -> Vec2 {
  { x, y }
}

///|
pub fn Vec2::zero() -> Vec2 {
  { x: 0.0, y: 0.0 }
}

///|
pub fn Vec2::unit_x() -> Vec2 {
  { x: 1.0, y: 0.0 }
}

///|
pub fn Vec2::unit_y() -> Vec2 {
  { x: 0.0, y: 1.0 }
}

///|
pub fn Vec2::dot(self : Vec2, other : Vec2) -> Double {
  self.x * other.x + self.y * other.y
}

///|
pub fn Vec2::cross(self : Vec2, other : Vec2) -> Double {
  self.x * other.y - self.y * other.x
}

///|
pub fn Vec2::norm_sq(self : Vec2) -> Double {
  self.dot(self)
}

///|
pub fn Vec2::norm(self : Vec2) -> Double {
  self.norm_sq().sqrt()
}

///|
pub fn Vec2::normalized(self : Vec2) -> Vec2 {
  let n = self.norm()
  if n == 0.0 {
    Vec2::zero()
  } else {
    { x: self.x / n, y: self.y / n }
  }
}

///|
pub fn Vec2::add(self : Vec2, other : Vec2) -> Vec2 {
  { x: self.x + other.x, y: self.y + other.y }
}

///|
pub fn Vec2::sub(self : Vec2, other : Vec2) -> Vec2 {
  { x: self.x - other.x, y: self.y - other.y }
}

///|
pub fn Vec2::mul_scalar(self : Vec2, scalar : Double) -> Vec2 {
  { x: self.x * scalar, y: self.y * scalar }
}

///|
pub fn Vec2::div_scalar(self : Vec2, scalar : Double) -> Vec2 {
  { x: self.x / scalar, y: self.y / scalar }
}

///|
pub fn Vec2::distance(self : Vec2, other : Vec2) -> Double {
  self.sub(other).norm()
}

///|
pub fn Vec2::distance_sq(self : Vec2, other : Vec2) -> Double {
  self.sub(other).norm_sq()
}

///|
pub fn Vec2::lerp(self : Vec2, other : Vec2, t : Double) -> Vec2 {
  { x: self.x + (other.x - self.x) * t, y: self.y + (other.y - self.y) * t }
}

///|
pub fn Vec2::angle(self : Vec2, other : Vec2) -> Double {
  let n1 = self.norm()
  let n2 = other.norm()
  if n1 == 0.0 || n2 == 0.0 {
    0.0
  } else {
    let cos_theta = self.dot(other) / (n1 * n2)
    let clamped = if cos_theta > 1.0 {
      1.0
    } else if cos_theta < -1.0 {
      -1.0
    } else {
      cos_theta
    }
    @cmath.acos(clamped)
  }
}

///|
pub fn Vec2::rotate(self : Vec2, angle_rad : Double) -> Vec2 {
  let cos_a = @cmath.cos(angle_rad)
  let sin_a = @cmath.sin(angle_rad)
  { x: self.x * cos_a - self.y * sin_a, y: self.x * sin_a + self.y * cos_a }
}

///|
pub(all) struct Vec3 {
  x : Double
  y : Double
  z : Double
} derive(Debug, Eq)

///|
pub fn Vec3::new(x : Double, y : Double, z : Double) -> Vec3 {
  { x, y, z }
}

///|
pub fn Vec3::zero() -> Vec3 {
  { x: 0.0, y: 0.0, z: 0.0 }
}

///|
pub fn Vec3::unit_x() -> Vec3 {
  { x: 1.0, y: 0.0, z: 0.0 }
}

///|
pub fn Vec3::unit_y() -> Vec3 {
  { x: 0.0, y: 1.0, z: 0.0 }
}

///|
pub fn Vec3::unit_z() -> Vec3 {
  { x: 0.0, y: 0.0, z: 1.0 }
}

///|
pub fn Vec3::dot(self : Vec3, other : Vec3) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z
}

///|
pub fn Vec3::cross(self : Vec3, other : Vec3) -> Vec3 {
  {
    x: self.y * other.z - self.z * other.y,
    y: self.z * other.x - self.x * other.z,
    z: self.x * other.y - self.y * other.x,
  }
}

///|
pub fn Vec3::norm_sq(self : Vec3) -> Double {
  self.dot(self)
}

///|
pub fn Vec3::norm(self : Vec3) -> Double {
  self.norm_sq().sqrt()
}

///|
pub fn Vec3::normalized(self : Vec3) -> Vec3 {
  let n = self.norm()
  if n == 0.0 {
    Vec3::zero()
  } else {
    { x: self.x / n, y: self.y / n, z: self.z / n }
  }
}

///|
pub fn Vec3::add(self : Vec3, other : Vec3) -> Vec3 {
  { x: self.x + other.x, y: self.y + other.y, z: self.z + other.z }
}

///|
pub fn Vec3::sub(self : Vec3, other : Vec3) -> Vec3 {
  { x: self.x - other.x, y: self.y - other.y, z: self.z - other.z }
}

///|
pub fn Vec3::mul_scalar(self : Vec3, scalar : Double) -> Vec3 {
  { x: self.x * scalar, y: self.y * scalar, z: self.z * scalar }
}

///|
pub fn Vec3::div_scalar(self : Vec3, scalar : Double) -> Vec3 {
  { x: self.x / scalar, y: self.y / scalar, z: self.z / scalar }
}

///|
pub fn Vec3::distance(self : Vec3, other : Vec3) -> Double {
  self.sub(other).norm()
}

///|
pub fn Vec3::distance_sq(self : Vec3, other : Vec3) -> Double {
  self.sub(other).norm_sq()
}

///|
pub fn Vec3::lerp(self : Vec3, other : Vec3, t : Double) -> Vec3 {
  {
    x: self.x + (other.x - self.x) * t,
    y: self.y + (other.y - self.y) * t,
    z: self.z + (other.z - self.z) * t,
  }
}

///|
pub fn Vec3::slerp(self : Vec3, other : Vec3, t : Double) -> Vec3 {
  let v0 = self.normalized()
  let v1 = other.normalized()
  let mut dot = v0.dot(v1)
  if dot > 1.0 {
    dot = 1.0
  } else if dot < -1.0 {
    dot = -1.0
  }
  let theta = @cmath.acos(dot)
  if theta.abs() < 1.0e-9 {
    v0.lerp(v1, t)
  } else {
    let sin_theta = @cmath.sin(theta)
    let a = @cmath.sin((1.0 - t) * theta) / sin_theta
    let b = @cmath.sin(t * theta) / sin_theta
    v0.mul_scalar(a).add(v1.mul_scalar(b))
  }
}

///|
pub fn Vec3::angle(self : Vec3, other : Vec3) -> Double {
  let n1 = self.norm()
  let n2 = other.norm()
  if n1 == 0.0 || n2 == 0.0 {
    0.0
  } else {
    let cos_theta = self.dot(other) / (n1 * n2)
    let clamped = if cos_theta > 1.0 {
      1.0
    } else if cos_theta < -1.0 {
      -1.0
    } else {
      cos_theta
    }
    @cmath.acos(clamped)
  }
}

///|
pub fn Vec3::project_onto(self : Vec3, onto : Vec3) -> Vec3 {
  let n_sq = onto.norm_sq()
  if n_sq == 0.0 {
    Vec3::zero()
  } else {
    onto.mul_scalar(self.dot(onto) / n_sq)
  }
}

///|
pub fn Vec3::reject_from(self : Vec3, from : Vec3) -> Vec3 {
  self.sub(self.project_onto(from))
}

///|
pub fn Vec3::reflect(self : Vec3, normal : Vec3) -> Vec3 {
  let n = normal.normalized()
  self.sub(n.mul_scalar(2.0 * self.dot(n)))
}

///|
pub(all) struct Vec4 {
  x : Double
  y : Double
  z : Double
  w : Double
} derive(Debug, Eq)

///|
pub fn Vec4::new(x : Double, y : Double, z : Double, w : Double) -> Vec4 {
  { x, y, z, w }
}

///|
pub fn Vec4::zero() -> Vec4 {
  { x: 0.0, y: 0.0, z: 0.0, w: 0.0 }
}

///|
pub fn Vec4::dot(self : Vec4, other : Vec4) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w
}

///|
pub fn Vec4::norm_sq(self : Vec4) -> Double {
  self.dot(self)
}

///|
pub fn Vec4::norm(self : Vec4) -> Double {
  self.norm_sq().sqrt()
}

///|
pub fn Vec4::normalized(self : Vec4) -> Vec4 {
  let n = self.norm()
  if n == 0.0 {
    Vec4::zero()
  } else {
    { x: self.x / n, y: self.y / n, z: self.z / n, w: self.w / n }
  }
}

///|
pub fn Vec4::add(self : Vec4, other : Vec4) -> Vec4 {
  {
    x: self.x + other.x,
    y: self.y + other.y,
    z: self.z + other.z,
    w: self.w + other.w,
  }
}

///|
pub fn Vec4::sub(self : Vec4, other : Vec4) -> Vec4 {
  {
    x: self.x - other.x,
    y: self.y - other.y,
    z: self.z - other.z,
    w: self.w - other.w,
  }
}

///|
pub fn Vec4::mul_scalar(self : Vec4, scalar : Double) -> Vec4 {
  {
    x: self.x * scalar,
    y: self.y * scalar,
    z: self.z * scalar,
    w: self.w * scalar,
  }
}

///|
pub fn Vec4::div_scalar(self : Vec4, scalar : Double) -> Vec4 {
  {
    x: self.x / scalar,
    y: self.y / scalar,
    z: self.z / scalar,
    w: self.w / scalar,
  }
}

///|
pub fn Vec4::to_vec3_homogeneous(self : Vec4) -> Vec3 {
  if self.w == 0.0 {
    { x: self.x, y: self.y, z: self.z }
  } else {
    { x: self.x / self.w, y: self.y / self.w, z: self.z / self.w }
  }
}

///|
pub fn Vec3::to_vec4_point(self : Vec3) -> Vec4 {
  { x: self.x, y: self.y, z: self.z, w: 1.0 }
}

///|
pub fn Vec3::to_vec4_vector(self : Vec3) -> Vec4 {
  { x: self.x, y: self.y, z: self.z, w: 0.0 }
}

///|
pub fn approx_eq(a : Double, b : Double, eps : Double) -> Bool {
  let diff = a - b
  (if diff < 0.0 { -diff } else { diff }) <= eps
}

///|
pub fn deg2rad(deg : Double) -> Double {
  deg * 3.14159265358979323846 / 180.0
}

///|
pub fn rad2deg(rad : Double) -> Double {
  rad * 180.0 / 3.14159265358979323846
}
