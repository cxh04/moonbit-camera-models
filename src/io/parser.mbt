// COLMAP File Format Parsers

///|
/// Helper function to parse double from StringView token
pub fn parse_double_token(sv : StringView) -> Double {
  @string.parse_double(sv) catch {
    _ => 0.0
  }
}

///|
fn parse_double_checked(sv : StringView) -> Double? {
  Some(@string.parse_double(sv)) catch {
    _ => None
  }
}

///|
/// Parse a single line from COLMAP cameras.txt file into a PinholeCamera model
pub fn parse_colmap_camera_line(line : String) -> @camera.PinholeCamera? {
  let trimmed = line.trim().replace_all(old="\t", new=" ")
  if trimmed.has_prefix("#") || trimmed.length() == 0 {
    None
  } else {
    // Expected format: CAMERA_ID MODEL WIDTH HEIGHT PARAMS...
    // E.g. "1 PINHOLE 1920 1080 960.0 960.0 960.0 540.0"
    let parts = trimmed.split(" ").filter(part => part.length() > 0)
    let arr = parts.to_array()
    if arr.length() < 8 || (arr[1] != "PINHOLE" && arr[1] != "OPENCV") {
      None
    } else {
      match
        (
          parse_double_checked(arr[2]),
          parse_double_checked(arr[3]),
          parse_double_checked(arr[4]),
          parse_double_checked(arr[5]),
          parse_double_checked(arr[6]),
          parse_double_checked(arr[7]),
        ) {
        (Some(width), Some(height), Some(fx), Some(fy), Some(cx), Some(cy)) if valid_intrinsics(
            width, height, fx, fy,
          ) =>
          if arr[1] == "OPENCV" {
            if arr.length() < 12 {
              None
            } else {
              match
                (
                  parse_double_checked(arr[8]),
                  parse_double_checked(arr[9]),
                  parse_double_checked(arr[10]),
                  parse_double_checked(arr[11]),
                ) {
                (Some(k1), Some(k2), Some(p1), Some(p2)) => {
                  let dist = @distortion.BrownConrady::new(k1, k2, p1, p2, 0.0)
                  Some(
                    @camera.PinholeCamera::with_distortion(
                      fx, fy, cx, cy, 0.0, width, height, dist,
                    ),
                  )
                }
                _ => None
              }
            }
          } else {
            Some(@camera.PinholeCamera::new(fx, fy, cx, cy, width, height))
          }
        _ => None
      }
    }
  }
}

///|
fn valid_intrinsics(
  width : Double,
  height : Double,
  fx : Double,
  fy : Double,
) -> Bool {
  width > 0.0 && height > 0.0 && fx > 0.0 && fy > 0.0
}
