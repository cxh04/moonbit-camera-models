// Homogenous 4x4 Matrices, Rodrigues Axis-Angle, and Euler Transformations

///| 4x4 Homogenous Matrix in row-major order
pub(all) struct Mat4x4 {
  m00 : Double
  m01 : Double
  m02 : Double
  m03 : Double
  m10 : Double
  m11 : Double
  m12 : Double
  m13 : Double
  m20 : Double
  m21 : Double
  m22 : Double
  m23 : Double
  m30 : Double
  m31 : Double
  m32 : Double
  m33 : Double
} derive(Debug, Eq)

///| Identity 4x4 Matrix
pub fn Mat4x4::identity() -> Mat4x4 {
  {
    m00: 1.0, m01: 0.0, m02: 0.0, m03: 0.0,
    m10: 0.0, m11: 1.0, m12: 0.0, m13: 0.0,
    m20: 0.0, m21: 0.0, m22: 1.0, m23: 0.0,
    m30: 0.0, m31: 0.0, m32: 0.0, m33: 1.0,
  }
}

///| Construct 4x4 Matrix from RigidTransform SE(3)
pub fn Mat4x4::from_rigid_transform(pose : RigidTransform) -> Mat4x4 {
  let r = pose.rotation
  let t = pose.translation
  {
    m00: r.m00, m01: r.m01, m02: r.m02, m03: t.x,
    m10: r.m10, m11: r.m11, m12: r.m12, m13: t.y,
    m20: r.m20, m21: r.m21, m22: r.m22, m23: t.z,
    m30: 0.0,   m31: 0.0,   m32: 0.0,   m33: 1.0,
  }
}

///| Transform 3D point using 4x4 matrix (perspective division)
pub fn Mat4x4::transform_point(self : Mat4x4, p : Vec3) -> Vec3 {
  let x = self.m00 * p.x + self.m01 * p.y + self.m02 * p.z + self.m03
  let y = self.m10 * p.x + self.m11 * p.y + self.m12 * p.z + self.m13
  let z = self.m20 * p.x + self.m21 * p.y + self.m22 * p.z + self.m23
  let w = self.m30 * p.x + self.m31 * p.y + self.m32 * p.z + self.m33
  if w == 0.0 {
    Vec3::new(x, y, z)
  } else {
    Vec3::new(x / w, y / w, z / w)
  }
}

///| Create skew-symmetric matrix [v]_x from 3D vector v
pub fn Mat3x3::skew_symmetric(v : Vec3) -> Mat3x3 {
  {
    m00: 0.0,   m01: -v.z,  m02: v.y,
    m10: v.z,   m11: 0.0,   m12: -v.x,
    m20: -v.y,  m21: v.x,   m22: 0.0,
  }
}

///| Rodrigues exponential map: Axis-Angle rotation vector omega -> Rotation Matrix R
pub fn rodrigues_exp(omega : Vec3) -> Mat3x3 {
  let theta = omega.norm()
  if theta < 0.000000001 {
    Mat3x3::identity()
  } else {
    let k = omega.mul_scalar(1.0 / theta)
    let k_mat = Mat3x3::skew_symmetric(k)
    let sin_t = @cmath.sin(theta)
    let cos_t = @cmath.cos(theta)

    let eye = Mat3x3::identity()
    let k2_mat = k_mat.mul_mat3x3(k_mat)

    // R = eye + sin(theta) * k_mat + (1 - cos(theta)) * k2_mat
    let term1 = {
      m00: eye.m00 + sin_t * k_mat.m00 + (1.0 - cos_t) * k2_mat.m00,
      m01: eye.m01 + sin_t * k_mat.m01 + (1.0 - cos_t) * k2_mat.m01,
      m02: eye.m02 + sin_t * k_mat.m02 + (1.0 - cos_t) * k2_mat.m02,
      m10: eye.m10 + sin_t * k_mat.m10 + (1.0 - cos_t) * k2_mat.m10,
      m11: eye.m11 + sin_t * k_mat.m11 + (1.0 - cos_t) * k2_mat.m11,
      m12: eye.m12 + sin_t * k_mat.m12 + (1.0 - cos_t) * k2_mat.m12,
      m20: eye.m20 + sin_t * k_mat.m20 + (1.0 - cos_t) * k2_mat.m20,
      m21: eye.m21 + sin_t * k_mat.m21 + (1.0 - cos_t) * k2_mat.m21,
      m22: eye.m22 + sin_t * k_mat.m22 + (1.0 - cos_t) * k2_mat.m22,
    }
    term1
  }
}

///| Rodrigues logarithm map: Rotation Matrix R -> Axis-Angle rotation vector omega
pub fn rodrigues_log(r : Mat3x3) -> Vec3 {
  let trace = r.m00 + r.m11 + r.m22
  let cos_theta = (trace - 1.0) * 0.5
  let clamped_cos = if cos_theta > 1.0 { 1.0 } else if cos_theta < -1.0 { -1.0 } else { cos_theta }
  let theta = @cmath.acos(clamped_cos)

  if theta < 0.000000001 {
    Vec3::zero()
  } else if (theta - 3.141592653589793).abs() < 0.0001 {
    let x = ((r.m00 + 1.0) * 0.5).sqrt()
    let y = ((r.m11 + 1.0) * 0.5).sqrt()
    let z = ((r.m22 + 1.0) * 0.5).sqrt()
    Vec3::new(x, y, z).mul_scalar(theta)
  } else {
    let sin_t = @cmath.sin(theta)
    let v_x = (r.m21 - r.m12) / (2.0 * sin_t)
    let v_y = (r.m02 - r.m20) / (2.0 * sin_t)
    let v_z = (r.m10 - r.m01) / (2.0 * sin_t)
    Vec3::new(v_x, v_y, v_z).mul_scalar(theta)
  }
}

///| Euler angles (roll, pitch, yaw in radians) to Rotation Matrix Mat3x3
pub fn euler_to_mat3x3(roll : Double, pitch : Double, yaw : Double) -> Mat3x3 {
  let cr = @cmath.cos(roll)
  let sr = @cmath.sin(roll)
  let cp = @cmath.cos(pitch)
  let sp = @cmath.sin(pitch)
  let cy = @cmath.cos(yaw)
  let sy = @cmath.sin(yaw)

  let r_x = Mat3x3::new(1.0, 0.0, 0.0, 0.0, cr, -sr, 0.0, sr, cr)
  let r_y = Mat3x3::new(cp, 0.0, sp, 0.0, 1.0, 0.0, -sp, 0.0, cp)
  let r_z = Mat3x3::new(cy, -sy, 0.0, sy, cy, 0.0, 0.0, 0.0, 1.0)

  r_z.mul_mat3x3(r_y).mul_mat3x3(r_x)
}
