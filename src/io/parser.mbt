// COLMAP File Format Parsers

///|
/// Helper function to parse double from StringView token
pub fn parse_double_token(sv : StringView) -> Double {
  @string.parse_double(sv) catch {
    _ => 0.0
  }
}

///|
/// Parse a single line from COLMAP cameras.txt file into a PinholeCamera model
pub fn parse_colmap_camera_line(line : String) -> @camera.PinholeCamera? {
  if line.has_prefix("#") || line.length() == 0 {
    None
  } else {
    // Expected format: CAMERA_ID MODEL WIDTH HEIGHT PARAMS...
    // E.g. "1 PINHOLE 1920 1080 960.0 960.0 960.0 540.0"
    let parts = line.split(" ")
    let arr = parts.to_array()
    if arr.length() >= 8 && (arr[1] == "PINHOLE" || arr[1] == "OPENCV") {
      let width = parse_double_token(arr[2])
      let height = parse_double_token(arr[3])
      let fx = parse_double_token(arr[4])
      let fy = parse_double_token(arr[5])
      let cx = parse_double_token(arr[6])
      let cy = parse_double_token(arr[7])

      if arr[1] == "OPENCV" && arr.length() >= 12 {
        let k1 = parse_double_token(arr[8])
        let k2 = parse_double_token(arr[9])
        let p1 = parse_double_token(arr[10])
        let p2 = parse_double_token(arr[11])
        let dist = @distortion.BrownConrady::new(k1, k2, p1, p2, 0.0)
        Some(
          @camera.PinholeCamera::with_distortion(
            fx, fy, cx, cy, 0.0, width, height, dist,
          ),
        )
      } else {
        Some(@camera.PinholeCamera::new(fx, fy, cx, cy, width, height))
      }
    } else {
      None
    }
  }
}
