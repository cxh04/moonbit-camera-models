// Common Camera Projection Types and Structures

///|
/// Projection result containing 2D pixel coordinates, depth, and field-of-view visibility flag
pub(all) struct ProjectionResult {
  pixel : @math.Vec2
  depth : Double
  in_fov : Bool
} derive(Debug, Eq)

///|
/// Field of View angles in radians (horizontal, vertical, diagonal)
pub(all) struct FOV {
  horizontal_rad : Double
  vertical_rad : Double
  diagonal_rad : Double
} derive(Debug, Eq)

///|
/// Convert FOV angles from radians to degrees
pub fn FOV::to_degrees(self : FOV) -> (Double, Double, Double) {
  (
    @math.rad2deg(self.horizontal_rad),
    @math.rad2deg(self.vertical_rad),
    @math.rad2deg(self.diagonal_rad),
  )
}
