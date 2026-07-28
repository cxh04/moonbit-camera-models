// Performance Benchmark Suite for Batch Projection Operations

///|
/// Benchmark pinhole projection over a batch of 3D points
pub fn run_pinhole_batch_benchmark(count : Int) -> Double {
  let dist = @distortion.BrownConrady::new(0.01, -0.002, 0.0001, -0.0001, 0.0)
  let cam = @camera.PinholeCamera::with_distortion(
    800.0, 800.0, 640.0, 360.0, 0.0, 1280.0, 720.0, dist,
  )
  let mut checksum = 0.0
  let mut i = 0
  while i < count {
    let x = (i % 100).to_double() * 0.1 - 5.0
    let y = (i % 50).to_double() * 0.1 - 2.5
    let z = 5.0 + (i % 20).to_double() * 0.5
    let p_3d = @math.Vec3::new(x, y, z)
    let proj = cam.project(p_3d)
    checksum = checksum + proj.pixel.x + proj.pixel.y
    i = i + 1
  }
  checksum
}

///|
/// Benchmark fisheye projection over a batch of 3D points
pub fn run_fisheye_batch_benchmark(count : Int) -> Double {
  let cam = @camera.FisheyeCamera::new(
    400.0, 400.0, 640.0, 360.0, 0.01, -0.002, 0.0005, -0.0001, 1280.0, 720.0,
  )
  let mut checksum = 0.0
  let mut i = 0
  while i < count {
    let x = (i % 100).to_double() * 0.1 - 5.0
    let y = (i % 50).to_double() * 0.1 - 2.5
    let z = 3.0 + (i % 15).to_double() * 0.5
    let p_3d = @math.Vec3::new(x, y, z)
    let proj = cam.project(p_3d)
    checksum = checksum + proj.pixel.x + proj.pixel.y
    i = i + 1
  }
  checksum
}
