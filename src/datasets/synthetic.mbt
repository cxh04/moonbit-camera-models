// Synthetic dataset generators for benchmarking and simulation

///|
/// Generate synthetic 3D point cloud grid in camera coordinate space
pub fn generate_synthetic_point_cloud(
  num_points_x : Int,
  num_points_y : Int,
  depth : Double,
  grid_step : Double,
) -> Array[@math.Vec3] {
  let points = []
  let start_x = -num_points_x.to_double() * grid_step * 0.5
  let start_y = -num_points_y.to_double() * grid_step * 0.5

  for j in 0..<num_points_y {
    let y = start_y + j.to_double() * grid_step
    for i in 0..<num_points_x {
      let x = start_x + i.to_double() * grid_step
      points.push(@math.Vec3::new(x, y, depth))
    }
  }
  points
}

///|
/// Generate circular orbit camera trajectory with N frames at radius R
pub fn generate_circular_trajectory(
  num_frames : Int,
  radius : Double,
  center : @math.Vec3,
) -> Array[@math.RigidTransform] {
  let trajectory = []
  let pi = 3.14159265358979323846

  for i in 0..<num_frames {
    let theta = 2.0 * pi * i.to_double() / num_frames.to_double()
    let x = center.x + radius * @cmath.cos(theta)
    let y = center.y
    let z = center.z + radius * @cmath.sin(theta)
    let pos = @math.Vec3::new(x, y, z)

    // Look at center
    let look_dir = center.sub(pos).normalized()
    let up = @math.Vec3::unit_y()
    let right = look_dir.cross(up).normalized()
    let true_up = right.cross(look_dir)

    let rot = @math.Mat3x3::new(
      right.x,
      right.y,
      right.z,
      true_up.x,
      true_up.y,
      true_up.z,
      -look_dir.x,
      -look_dir.y,
      -look_dir.z,
    )
    trajectory.push(@math.RigidTransform::new(rot, pos))
  }
  trajectory
}
