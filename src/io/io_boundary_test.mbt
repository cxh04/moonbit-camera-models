// Extensive Boundary Test Suite for Serialization and Interop Parsers

///|
/// Boundary Test: COLMAP Line Parsing and Export Roundtrip
test "colmap line parser and exporter boundary tests" {
  let line_pinhole = "1 PINHOLE 1920 1080 960.0 960.0 960.0 540.0"
  let parsed_ph = parse_colmap_camera_line(line_pinhole).unwrap()
  assert_eq(parsed_ph.width, 1920.0)
  assert_eq(parsed_ph.height, 1080.0)
  assert_eq(parsed_ph.fx, 960.0)
  assert_eq(parsed_ph.fy, 960.0)
  assert_eq(parsed_ph.cx, 960.0)
  assert_eq(parsed_ph.cy, 540.0)

  let line_opencv = "2 OPENCV 1280 720 800.0 800.0 640.0 360.0 0.01 -0.002 0.0005 -0.0001"
  let parsed_cv = parse_colmap_camera_line(line_opencv).unwrap()
  assert_eq(parsed_cv.width, 1280.0)
  assert_eq(parsed_cv.distortion.k1, 0.01)

  let empty_colmap = parse_colmap_camera_line("")
  assert_true(empty_colmap is None)

  let invalid_colmap = parse_colmap_camera_line("INVALID MODEL FORMAT")
  assert_true(invalid_colmap is None)

  let exported = export_colmap_camera(parsed_ph, 1)
  assert_true(exported.length() > 0)

  let spaced = parse_colmap_camera_line(
    "  3   PINHOLE   640   480   320.0   320.0   320.0   240.0  ",
  ).unwrap()
  assert_eq(spaced.width, 640.0)
  assert_eq(spaced.cy, 240.0)
  let tabbed = parse_colmap_camera_line(
    "6\tPINHOLE\t640\t480\t320\t320\t320\t240",
  ).unwrap()
  assert_eq(tabbed.fx, 320.0)
  assert_true(
    parse_colmap_camera_line("4 OPENCV 640 480 320 320 320 240") is None,
  )
  assert_true(
    parse_colmap_camera_line("5 PINHOLE bad 480 320 320 320 240") is None,
  )
}

///|
/// Boundary Test: JSON and OpenCV YAML Serializers
test "json and opencv yaml export format integrity" {
  let dist = @distortion.BrownConrady::new(0.01, -0.002, 0.0001, -0.0001, 0.0)
  let cam = @camera.PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )

  let json_str = pinhole_to_json(cam)
  assert_true(json_str.contains("PINHOLE"))
  assert_true(json_str.contains("800"))

  let fisheye = @camera.FisheyeCamera::new(
    400.0, 400.0, 640.0, 360.0, 0.01, -0.002, 0.0005, -0.0001, 1280.0, 720.0,
  )
  let fish_json = fisheye_to_json(fisheye)
  assert_true(fish_json.contains("FISHEYE_KANNALA_BRANDT"))

  let yaml_str = export_opencv_yaml(cam)
  assert_true(yaml_str.contains("%YAML:1.0"))
  assert_true(yaml_str.contains("camera_matrix"))
}
