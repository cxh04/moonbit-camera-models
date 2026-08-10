// Non-Linear Optimization & Checkerboard Target Generation

///| Generate 3D grid target points for camera calibration (MxN grid with spacing)
pub fn generate_checkerboard_target(
  cols : Int,
  rows : Int,
  spacing : Double
) -> Array[@math.Vec3] {
  let points = []
  let mut r = 0
  while r < rows {
    let mut c = 0
    while c < cols {
      let x = c.to_double() * spacing
      let y = r.to_double() * spacing
      points.push(@math.Vec3::new(x, y, 0.0))
      c = c + 1
    }
    r = r + 1
  }
  points
}

///| Refine camera focal length using Levenberg-Marquardt step iteration
pub fn refine_pinhole_intrinsics_lm(
  cam : @camera.PinholeCamera,
  points_3d : Array[@math.Vec3],
  observed_pixels : Array[@math.Vec2],
  max_iter : Int
) -> @camera.PinholeCamera {
  let mut cur_fx = cam.fx
  let cur_fy = cam.fy
  let mut iter = 0
  let len = points_3d.length()

  if len == 0 || len != observed_pixels.length() {
    cam
  } else {
    while iter < max_iter {
      let mut num_x = 0.0
      let mut den_x = 0.0
      let mut i = 0
      while i < len {
        let p3 = points_3d[i]
        let obs = observed_pixels[i]
        let norm_x = p3.x / p3.z
        let proj_u = cur_fx * norm_x + cam.cx
        let residual = obs.x - proj_u

        num_x = num_x + norm_x * residual
        den_x = den_x + norm_x * norm_x
        i = i + 1
      }
      if den_x.abs() > 0.000001 {
        let delta_fx = num_x / den_x
        cur_fx = cur_fx + delta_fx * 0.1
      }
      iter = iter + 1
    }
    @camera.PinholeCamera::with_distortion(
      cur_fx, cur_fy, cam.cx, cam.cy, cam.skew, cam.width, cam.height, cam.distortion
    )
  }
}
