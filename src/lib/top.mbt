// MoonBit Camera Models - Library Facade and Preset Utilities

///|
/// Create standard Full HD (1920x1080) pinhole camera with 90-degree horizontal field of view
pub fn create_standard_fhd_camera() -> @camera.PinholeCamera {
  // fx = width / (2 * tan(45 deg)) = 1920 / 2 = 960
  @camera.PinholeCamera::new(960.0, 960.0, 960.0, 540.0, 1920.0, 1080.0)
}

///|
/// Create standard 4K 180-degree fisheye camera with Kannala-Brandt distortion parameters
pub fn create_standard_fisheye_camera() -> @camera.FisheyeCamera {
  @camera.FisheyeCamera::new(
    1200.0, 1200.0, 1920.0, 1080.0, 0.015, -0.003, 0.0005, -0.00008, 3840.0, 2160.0,
  )
}

///|
/// Demonstrate complete camera projection and unprojection workflow
pub fn demo_projection_pipeline(
  p : @math.Vec3,
) -> (Double, Double, Double, Double, Double) {
  let cam = create_standard_fhd_camera()
  let proj = cam.project(p)
  let p_rec = cam.unproject(proj.pixel, proj.depth)
  let err_x = (p_rec.x - p.x).abs()
  let err_y = (p_rec.y - p.y).abs()
  let err_z = (p_rec.z - p.z).abs()
  (proj.pixel.x, proj.pixel.y, err_x, err_y, err_z)
}
