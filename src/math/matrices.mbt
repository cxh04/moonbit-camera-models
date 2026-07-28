// 3x3 Matrix, Quaternion, Ray, and RigidTransform (SE3) operations

///| 3x3 Matrix represented in row-major order:
///| m00 m01 m02
///| m10 m11 m12
///| m20 m21 m22
pub(all) struct Mat3x3 {
  m00 : Double
  m01 : Double
  m02 : Double
  m10 : Double
  m11 : Double
  m12 : Double
  m20 : Double
  m21 : Double
  m22 : Double
} derive(Debug, Eq)

///|
pub fn Mat3x3::identity() -> Mat3x3 {
  {
    m00: 1.0, m01: 0.0, m02: 0.0,
    m10: 0.0, m11: 1.0, m12: 0.0,
    m20: 0.0, m21: 0.0, m22: 1.0,
  }
}

///|
pub fn Mat3x3::zero() -> Mat3x3 {
  {
    m00: 0.0, m01: 0.0, m02: 0.0,
    m10: 0.0, m11: 0.0, m12: 0.0,
    m20: 0.0, m21: 0.0, m22: 0.0,
  }
}

///|
pub fn Mat3x3::new(
  m00 : Double, m01 : Double, m02 : Double,
  m10 : Double, m11 : Double, m12 : Double,
  m20 : Double, m21 : Double, m22 : Double
) -> Mat3x3 {
  { m00, m01, m02, m10, m11, m12, m20, m21, m22 }
}

///| Matrix-vector multiplication R * v
pub fn Mat3x3::mul_vec3(self : Mat3x3, v : Vec3) -> Vec3 {
  {
    x: self.m00 * v.x + self.m01 * v.y + self.m02 * v.z,
    y: self.m10 * v.x + self.m11 * v.y + self.m12 * v.z,
    z: self.m20 * v.x + self.m21 * v.y + self.m22 * v.z,
  }
}

///| Matrix multiplication A * B
pub fn Mat3x3::mul_mat3x3(self : Mat3x3, other : Mat3x3) -> Mat3x3 {
  {
    m00: self.m00 * other.m00 + self.m01 * other.m10 + self.m02 * other.m20,
    m01: self.m00 * other.m01 + self.m01 * other.m11 + self.m02 * other.m21,
    m02: self.m00 * other.m02 + self.m01 * other.m12 + self.m02 * other.m22,
    m10: self.m10 * other.m00 + self.m11 * other.m10 + self.m12 * other.m20,
    m11: self.m10 * other.m01 + self.m11 * other.m11 + self.m12 * other.m21,
    m12: self.m10 * other.m02 + self.m11 * other.m12 + self.m12 * other.m22,
    m20: self.m20 * other.m00 + self.m21 * other.m10 + self.m22 * other.m20,
    m21: self.m20 * other.m01 + self.m21 * other.m11 + self.m22 * other.m21,
    m22: self.m20 * other.m02 + self.m21 * other.m12 + self.m22 * other.m22,
  }
}

///| Matrix transpose A^T
pub fn Mat3x3::transpose(self : Mat3x3) -> Mat3x3 {
  {
    m00: self.m00, m01: self.m10, m02: self.m20,
    m10: self.m01, m11: self.m11, m12: self.m21,
    m20: self.m02, m21: self.m12, m22: self.m22,
  }
}

///| Determinant of 3x3 matrix
pub fn Mat3x3::determinant(self : Mat3x3) -> Double {
  self.m00 * (self.m11 * self.m22 - self.m12 * self.m21) -
  self.m01 * (self.m10 * self.m22 - self.m12 * self.m20) +
  self.m02 * (self.m10 * self.m21 - self.m11 * self.m20)
}

///| Inverse of 3x3 matrix
pub fn Mat3x3::inverse(self : Mat3x3) -> Option[Mat3x3] {
  let det = self.determinant()
  if det == 0.0 {
    None
  } else {
    let inv_det = 1.0 / det
    let m00 = (self.m11 * self.m22 - self.m12 * self.m21) * inv_det
    let m01 = (self.m02 * self.m21 - self.m01 * self.m22) * inv_det
    let m02 = (self.m01 * self.m12 - self.m02 * self.m11) * inv_det
    let m10 = (self.m12 * self.m20 - self.m10 * self.m22) * inv_det
    let m11 = (self.m00 * self.m22 - self.m02 * self.m20) * inv_det
    let m12 = (self.m02 * self.m10 - self.m00 * self.m12) * inv_det
    let m20 = (self.m10 * self.m21 - self.m11 * self.m20) * inv_det
    let m21 = (self.m01 * self.m20 - self.m00 * self.m21) * inv_det
    let m22 = (self.m00 * self.m11 - self.m01 * self.m10) * inv_det
    Some({ m00, m01, m02, m10, m11, m12, m20, m21, m22 })
  }
}

///| Unit Quaternion representing 3D rotation: q = w + x i + y j + z k
pub(all) struct Quaternion {
  w : Double
  x : Double
  y : Double
  z : Double
} derive(Debug, Eq)

///|
pub fn Quaternion::identity() -> Quaternion {
  { w: 1.0, x: 0.0, y: 0.0, z: 0.0 }
}

///|
pub fn Quaternion::new(w : Double, x : Double, y : Double, z : Double) -> Quaternion {
  { w, x, y, z }
}

///| Convert Quaternion to 3x3 Rotation Matrix
pub fn Quaternion::to_rotation_matrix(self : Quaternion) -> Mat3x3 {
  let w = self.w
  let x = self.x
  let y = self.y
  let z = self.z

  let xx = x * x
  let yy = y * y
  let zz = z * z
  let xy = x * y
  let xz = x * z
  let yz = y * z
  let wx = w * x
  let wy = w * y
  let wz = w * z

  {
    m00: 1.0 - 2.0 * (yy + zz),
    m01: 2.0 * (xy - wz),
    m02: 2.0 * (xz + wy),
    m10: 2.0 * (xy + wz),
    m11: 1.0 - 2.0 * (xx + zz),
    m12: 2.0 * (yz - wx),
    m20: 2.0 * (xz - wy),
    m21: 2.0 * (yz + wx),
    m22: 1.0 - 2.0 * (xx + yy),
  }
}

///| 3D Ray with origin and normalized direction
pub(all) struct Ray {
  origin : Vec3
  direction : Vec3
} derive(Debug, Eq)

///|
pub fn Ray::new(origin : Vec3, direction : Vec3) -> Ray {
  { origin, direction: direction.normalized() }
}

///| Evaluate point along ray at parameter t
pub fn Ray::point_at(self : Ray, t : Double) -> Vec3 {
  self.origin.add(self.direction.mul_scalar(t))
}

///| SE3 Rigid Transformation: P_camera = R * P_world + t
pub(all) struct RigidTransform {
  rotation : Mat3x3
  translation : Vec3
} derive(Debug, Eq)

///|
pub fn RigidTransform::identity() -> RigidTransform {
  { rotation: Mat3x3::identity(), translation: Vec3::zero() }
}

///|
pub fn RigidTransform::new(rotation : Mat3x3, translation : Vec3) -> RigidTransform {
  { rotation, translation }
}

///| Transform 3D point: P' = R * P + t
pub fn RigidTransform::transform_point(self : RigidTransform, p : Vec3) -> Vec3 {
  self.rotation.mul_vec3(p).add(self.translation)
}

///| Inverse transformation: P = R^T * (P' - t)
pub fn RigidTransform::inverse(self : RigidTransform) -> RigidTransform {
  let inv_r = self.rotation.transpose()
  let inv_t = inv_r.mul_vec3(self.translation).mul_scalar(-1.0)
  { rotation: inv_r, translation: inv_t }
}
