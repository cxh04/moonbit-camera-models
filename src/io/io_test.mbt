///|
test "export JSON and COLMAP" {
  let dist = @distortion.BrownConrady::new(0.01, -0.002, 0.0, 0.0, 0.0)
  let cam = @camera.PinholeCamera::with_distortion(
    1000.0, 1000.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, dist,
  )

  let json_str = pinhole_to_json(cam)
  assert_true(json_str.contains("PINHOLE"))
  assert_true(json_str.contains("1920"))

  let colmap_str = export_colmap_camera(cam, 1)
  assert_true(colmap_str.contains("1 OPENCV 1920"))

  let yaml_str = export_opencv_yaml(cam)
  assert_true(yaml_str.contains("%YAML:1.0"))
}
