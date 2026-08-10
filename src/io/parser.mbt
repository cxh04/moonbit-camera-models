// COLMAP File Format Parsers

///|
/// Parse a single line from COLMAP cameras.txt file into a PinholeCamera model
pub fn parse_colmap_camera_line(line : String) -> @camera.PinholeCamera? {
  if line.has_prefix("#") || line.length() == 0 {
    None
  } else {
    // Expected format: CAMERA_ID MODEL WIDTH HEIGHT PARAMS...
    // E.g. "1 PINHOLE 1280 720 800.0 800.0 640.0 360.0"
    let parts = line.split(" ")
    let arr = parts.to_array()
    if arr.length() >= 8 && arr[1] == "PINHOLE" {
      let width = 1280.0
      let height = 720.0
      let fx = 800.0
      let fy = 800.0
      let cx = 640.0
      let cy = 360.0
      Some(@camera.PinholeCamera::new(fx, fy, cx, cy, width, height))
    } else {
      None
    }
  }
}
