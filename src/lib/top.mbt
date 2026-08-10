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
/// Load KITTI Vision Benchmark Suite Stereo Pinhole Preset Camera
pub fn create_kitti_stereo_camera() -> @datasets.DatasetCamera {
  @datasets.load_kitti_left_camera()
}

///|
/// Load TUM VI SLAM Double Sphere Preset Camera
pub fn create_tum_vi_camera() -> @datasets.DatasetCamera {
  @datasets.load_tum_vi_ds_camera()
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

///|
/// Compute RMS error on preset benchmark features
pub fn evaluate_benchmark_accuracy(cam : @camera.PinholeCamera) -> Double {
  let features = @datasets.get_benchmark_3d_features()
  let pixels = []
  let mut i = 0
  while i < features.length() {
    let proj = cam.project(features[i])
    pixels.push(proj.pixel)
    i = i + 1
  }
  @calibration.compute_rms_reprojection_error(cam, features, pixels)
}

///|
/// Internal linkage helper for package facade
pub fn facade_link_all() -> Bool {
  let d = @distortion.BrownConrady::zero()
  let s = @geometry.skew_symmetric(@math.Vec3::zero())
  let p = @io.parse_colmap_camera_line("")
  d.k1 == 0.0 && s.m00 == 0.0 && p is None
}
