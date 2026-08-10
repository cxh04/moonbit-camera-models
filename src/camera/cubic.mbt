// Cubic Panorama Camera Model (6-Face Skybox Projection)

///|
/// Cubemap face enum representation
pub(all) enum CubeFace {
  Front
  Back
  Left
  Right
  Top
  Bottom
} derive(Debug, Eq)

///|
/// Cubic Panorama Camera Model for 360 Environment Mapping
pub(all) struct CubicPanoramaCamera {
  face_size : Double
} derive(Debug, Eq)

///|
/// Construct Cubic Panorama Camera with given face pixel resolution
pub fn CubicPanoramaCamera::new(face_size : Double) -> CubicPanoramaCamera {
  { face_size, }
}

///|
/// Project 3D vector to specific CubeFace pixel coordinate (u, v)
pub fn CubicPanoramaCamera::project_to_face(
  self : CubicPanoramaCamera,
  p : @math.Vec3,
) -> (CubeFace, @math.Vec2) {
  let abs_x = p.x.abs()
  let abs_y = p.y.abs()
  let abs_z = p.z.abs()

  let face = if abs_x >= abs_y && abs_x >= abs_z {
    if p.x > 0.0 {
      CubeFace::Right
    } else {
      CubeFace::Left
    }
  } else if abs_y >= abs_x && abs_y >= abs_z {
    if p.y > 0.0 {
      CubeFace::Top
    } else {
      CubeFace::Bottom
    }
  } else if p.z > 0.0 {
    CubeFace::Front
  } else {
    CubeFace::Back
  }

  let half = self.face_size * 0.5

  let (u_norm, v_norm) = match face {
    CubeFace::Right => (-p.z / abs_x, -p.y / abs_x)
    CubeFace::Left => (p.z / abs_x, -p.y / abs_x)
    CubeFace::Top => (p.x / abs_y, p.z / abs_y)
    CubeFace::Bottom => (p.x / abs_y, -p.z / abs_y)
    CubeFace::Front => (p.x / abs_z, -p.y / abs_z)
    CubeFace::Back => (-p.x / abs_z, -p.y / abs_z)
  }

  let u = (u_norm + 1.0) * half
  let v = (v_norm + 1.0) * half
  (face, @math.Vec2::new(u, v))
}

///|
/// Unproject CubeFace pixel coordinate (u, v) back to 3D ray direction
pub fn CubicPanoramaCamera::unproject_from_face(
  self : CubicPanoramaCamera,
  face : CubeFace,
  pixel : @math.Vec2,
) -> @math.Vec3 {
  let half = self.face_size * 0.5
  let u_norm = pixel.x / half - 1.0
  let v_norm = pixel.y / half - 1.0

  let dir = match face {
    CubeFace::Right => @math.Vec3::new(1.0, -v_norm, -u_norm)
    CubeFace::Left => @math.Vec3::new(-1.0, -v_norm, u_norm)
    CubeFace::Top => @math.Vec3::new(u_norm, 1.0, v_norm)
    CubeFace::Bottom => @math.Vec3::new(u_norm, -1.0, -v_norm)
    CubeFace::Front => @math.Vec3::new(u_norm, -v_norm, 1.0)
    CubeFace::Back => @math.Vec3::new(-u_norm, -v_norm, -1.0)
  }
  dir.normalized()
}
