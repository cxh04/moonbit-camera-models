// Serialization, Interop Format, and COLMAP Export/Parse Verification Tables

///|
/// Verification Test for COLMAP Format Export and Parse Roundtrip over 50 Camera Parameter Configurations
test "io verification table 1 - colmap export parse roundtrip grid" {
  for i in 1..<=50 {
    let width = 1000.0 + i.to_double() * 20.0
    let height = 500.0 + i.to_double() * 10.0
    let fx = 800.0 + i.to_double() * 5.0
    let fy = 800.0 + i.to_double() * 5.0
    let cx = width * 0.5
    let cy = height * 0.5

    let dist = @distortion.BrownConrady::new(
      0.01 * i.to_double(),
      -0.001 * i.to_double(),
      0.0001,
      -0.0001,
      0.0,
    )
    let cam = @camera.PinholeCamera::with_distortion(
      fx, fy, cx, cy, 0.0, width, height, dist,
    )

    let line_str = export_colmap_camera(cam, i)
    let parsed_cam = parse_colmap_camera_line(line_str).unwrap()

    assert_true(@math.approx_eq(parsed_cam.width, width, 1.0e-3))
    assert_true(@math.approx_eq(parsed_cam.height, height, 1.0e-3))
    assert_true(@math.approx_eq(parsed_cam.fx, fx, 1.0e-3))
    assert_true(@math.approx_eq(parsed_cam.fy, fy, 1.0e-3))
    assert_true(@math.approx_eq(parsed_cam.cx, cx, 1.0e-3))
    assert_true(@math.approx_eq(parsed_cam.cy, cy, 1.0e-3))
  }
}

///|
/// Verification Test for JSON Serialization String Structure over 50 Configurations
test "io verification table 1 - json string structure verification" {
  for i in 1..<=50 {
    let fx = 500.0 + i.to_double() * 10.0
    let cam = @camera.PinholeCamera::new(fx, fx, 640.0, 360.0, 1280.0, 720.0)

    let json_str = pinhole_to_json(cam)
    assert_true(json_str.length() > 50)
    assert_true(json_str.contains("PINHOLE"))
  }
}
