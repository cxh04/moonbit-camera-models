// Camera Parameter Serialization and OpenCV / COLMAP Format Exporters

///|
/// Export Pinhole camera intrinsics and distortion to JSON format string
pub fn pinhole_to_json(cam : @camera.PinholeCamera) -> String {
  let dist = cam.distortion
  "{\n" +
  "  \"model\": \"PINHOLE\",\n" +
  "  \"width\": " +
  cam.width.to_string() +
  ",\n" +
  "  \"height\": " +
  cam.height.to_string() +
  ",\n" +
  "  \"fx\": " +
  cam.fx.to_string() +
  ",\n" +
  "  \"fy\": " +
  cam.fy.to_string() +
  ",\n" +
  "  \"cx\": " +
  cam.cx.to_string() +
  ",\n" +
  "  \"cy\": " +
  cam.cy.to_string() +
  ",\n" +
  "  \"skew\": " +
  cam.skew.to_string() +
  ",\n" +
  "  \"distortion\": {\n" +
  "    \"k1\": " +
  dist.k1.to_string() +
  ",\n" +
  "    \"k2\": " +
  dist.k2.to_string() +
  ",\n" +
  "    \"p1\": " +
  dist.p1.to_string() +
  ",\n" +
  "    \"p2\": " +
  dist.p2.to_string() +
  ",\n" +
  "    \"k3\": " +
  dist.k3.to_string() +
  "\n" +
  "  }\n" +
  "}"
}

///|
/// Export Fisheye camera model parameters to JSON format string
pub fn fisheye_to_json(cam : @camera.FisheyeCamera) -> String {
  "{\n" +
  "  \"model\": \"FISHEYE_KANNALA_BRANDT\",\n" +
  "  \"width\": " +
  cam.width.to_string() +
  ",\n" +
  "  \"height\": " +
  cam.height.to_string() +
  ",\n" +
  "  \"fx\": " +
  cam.fx.to_string() +
  ",\n" +
  "  \"fy\": " +
  cam.fy.to_string() +
  ",\n" +
  "  \"cx\": " +
  cam.cx.to_string() +
  ",\n" +
  "  \"cy\": " +
  cam.cy.to_string() +
  ",\n" +
  "  \"k1\": " +
  cam.k1.to_string() +
  ",\n" +
  "  \"k2\": " +
  cam.k2.to_string() +
  ",\n" +
  "  \"k3\": " +
  cam.k3.to_string() +
  ",\n" +
  "  \"k4\": " +
  cam.k4.to_string() +
  "\n" +
  "}"
}

///|
/// Export camera calibration parameters to OpenCV YAML config string
pub fn export_opencv_yaml(cam : @camera.PinholeCamera) -> String {
  let dist = cam.distortion
  "%YAML:1.0\n" +
  "image_width: " +
  cam.width.to_string() +
  "\n" +
  "image_height: " +
  cam.height.to_string() +
  "\n" +
  "camera_matrix: !!opencv-matrix\n" +
  "   rows: 3\n" +
  "   cols: 3\n" +
  "   dt: d\n" +
  "   data: [ " +
  cam.fx.to_string() +
  ", 0., " +
  cam.cx.to_string() +
  ", 0., " +
  cam.fy.to_string() +
  ", " +
  cam.cy.to_string() +
  ", 0., 0., 1. ]\n" +
  "distortion_coefficients: !!opencv-matrix\n" +
  "   rows: 1\n" +
  "   cols: 5\n" +
  "   dt: d\n" +
  "   data: [ " +
  dist.k1.to_string() +
  ", " +
  dist.k2.to_string() +
  ", " +
  dist.p1.to_string() +
  ", " +
  dist.p2.to_string() +
  ", " +
  dist.k3.to_string() +
  " ]\n"
}

///|
/// Export camera definition to COLMAP cameras.txt format line
pub fn export_colmap_camera(
  cam : @camera.PinholeCamera,
  camera_id : Int,
) -> String {
  let dist = cam.distortion
  if dist.k1 == 0.0 && dist.k2 == 0.0 && dist.p1 == 0.0 && dist.p2 == 0.0 {
    // PINHOLE model: CAMERA_ID PINHOLE WIDTH HEIGHT FX FY CX CY
    camera_id.to_string() +
    " PINHOLE " +
    cam.width.to_string() +
    " " +
    cam.height.to_string() +
    " " +
    cam.fx.to_string() +
    " " +
    cam.fy.to_string() +
    " " +
    cam.cx.to_string() +
    " " +
    cam.cy.to_string()
  } else {
    // OPENCV model: CAMERA_ID OPENCV WIDTH HEIGHT FX FY CX CY K1 K2 P1 P2
    camera_id.to_string() +
    " OPENCV " +
    cam.width.to_string() +
    " " +
    cam.height.to_string() +
    " " +
    cam.fx.to_string() +
    " " +
    cam.fy.to_string() +
    " " +
    cam.cx.to_string() +
    " " +
    cam.cy.to_string() +
    " " +
    dist.k1.to_string() +
    " " +
    dist.k2.to_string() +
    " " +
    dist.p1.to_string() +
    " " +
    dist.p2.to_string()
  }
}
