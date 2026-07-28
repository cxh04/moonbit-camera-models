// Vector math routines for 2D, 3D, and 4D space

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
pub fn Vec2::dot(self : Vec2, other : Vec2) -> Double {
  self.x * other.x + self.y * other.y
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
pub fn Vec4::to_vec3_homogeneous(self : Vec4) -> Vec3 {
  if self.w == 0.0 {
    { x: self.x, y: self.y, z: self.z }
  } else {
    { x: self.x / self.w, y: self.y / self.w, z: self.z / self.w }
  }
}

///|
pub fn approx_eq(a : Double, b : Double, eps : Double) -> Bool {
  let diff = a - b
  (if diff < 0.0 { -diff } else { diff }) <= eps
}

///|
pub fn deg2rad(deg : Double) -> Double {
  deg * 3.141592653589793 / 180.0
}

///|
pub fn rad2deg(rad : Double) -> Double {
  rad * 180.0 / 3.141592653589793
}
