// Calibration Metrics and Image Rectification Lookup Grids

///| Compute Root Mean Square (RMS) Reprojection Error across observed feature points
pub fn compute_rms_reprojection_error(
  cam : @camera.PinholeCamera,
  points_3d : Array[@math.Vec3],
  observed_pixels : Array[@math.Vec2]
) -> Double {
  let len = points_3d.length()
  if len == 0 || len != observed_pixels.length() {
    0.0
  } else {
    let mut sum_sq_err = 0.0
    let mut i = 0
    while i < len {
      let p_3d = points_3d[i]
      let obs_2d = observed_pixels[i]
      let proj = cam.project(p_3d)
      let dist = proj.pixel.distance(obs_2d)
      sum_sq_err = sum_sq_err + dist * dist
      i = i + 1
    }
    (sum_sq_err / len.to_double()).sqrt()
  }
}

///| Convert 3D point in camera frame to normalized image coordinate
pub fn to_vec2_normalized(p : @math.Vec3, cam : @camera.PinholeCamera) -> @math.Vec2 {
  let x_d = p.x / p.z
  let y_d = p.y / p.z
  let u = cam.fx * x_d + cam.cx
  let v = cam.fy * y_d + cam.cy
  @math.Vec2::new(u, v)
}

///| Undistort map coordinate point for image remap
pub fn map_undistort_point(cam : @camera.PinholeCamera, target_u : Double, target_v : Double) -> @math.Vec2 {
  let p_distorted = @math.Vec2::new(target_u, target_v)
  let p_3d = cam.unproject(p_distorted, 1.0)
  to_vec2_normalized(p_3d, cam)
}
