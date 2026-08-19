// FOV (Field-Of-View) Camera Model (Zheng et al.)

///|
/// Field-Of-View (FOV) Camera Model using w arc distortion mapping
pub(all) struct FOVCamera {
  fx : Double
  fy : Double
  cx : Double
  cy : Double
  width : Double
  height : Double
  w : Double
} derive(Debug, Eq)

///|
/// Construct new FOV Camera Model
pub fn FOVCamera::new(
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  width : Double,
  height : Double,
  w : Double,
) -> FOVCamera {
  { fx, fy, cx, cy, width, height, w }
}

///|
/// Project 3D camera point to 2D pixel space under FOV model
pub fn FOVCamera::project(self : FOVCamera, p : @math.Vec3) -> ProjectionResult {
  if p.z <= 0.0 {
    { pixel: @math.Vec2::zero(), depth: p.z, in_fov: false }
  } else {
    let ru = (p.x * p.x + p.y * p.y).sqrt() / p.z
    if ru == 0.0 {
      let u = self.cx
      let v = self.cy
      let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
      { pixel: @math.Vec2::new(u, v), depth: p.z, in_fov }
    } else {
      let rd = if self.w.abs() < 1.0e-6 {
        ru
      } else {
        let tan_half_w = @cmath.tan(self.w * 0.5)
        @cmath.atan2(2.0 * ru * tan_half_w, 1.0) / (self.w * ru)
      }
      let x_d = p.x / p.z * rd
      let y_d = p.y / p.z * rd

      let u = self.fx * x_d + self.cx
      let v = self.fy * y_d + self.cy

      let in_fov = u >= 0.0 && u < self.width && v >= 0.0 && v < self.height
      { pixel: @math.Vec2::new(u, v), depth: p.z, in_fov }
    }
  }
}

///|
/// Unproject 2D pixel to 3D ray point under FOV model
pub fn FOVCamera::unproject(
  self : FOVCamera,
  pixel : @math.Vec2,
  depth : Double,
) -> @math.Vec3 {
  let x_d = (pixel.x - self.cx) / self.fx
  let y_d = (pixel.y - self.cy) / self.fy
  let rd = (x_d * x_d + y_d * y_d).sqrt()

  if rd == 0.0 {
    @math.Vec3::new(0.0, 0.0, depth)
  } else {
    let ru = if self.w.abs() < 1.0e-6 {
      rd
    } else {
      let tan_rd_w = @cmath.tan(rd * self.w)
      let tan_half_w = @cmath.tan(self.w * 0.5)
      tan_rd_w / (2.0 * tan_half_w)
    }

    let scale = ru / rd
    let x_u = x_d * scale
    let y_u = y_d * scale

    let ray_dir = @math.Vec3::new(x_u, y_u, 1.0).normalized()
    ray_dir.mul_scalar(depth)
  }
}
