// Command-Line Interface (CLI) Utility for MoonBit Camera Models

///|
fn print_usage() -> Unit {
  println("MoonBit Camera Models CLI v0.1.0")
  println("Usage: moonbit-camera-models-cli <command> [options]")
  println("")
  println("Commands:")
  println(
    "  info       Display intrinsics, FOV, and parameters for preset camera models",
  )
  println(
    "  project    Project 3D point cloud coordinates to 2D image pixel plane",
  )
  println(
    "  unproject  Unproject 2D pixel coordinates and depth to 3D camera ray",
  )
  println(
    "  convert    Convert camera calibration parameters between JSON, COLMAP, and OpenCV YAML formats",
  )
  println(
    "  rectify    Compute stereo rectification transformation matrices for stereo image pairs",
  )
  println(
    "  bench      Run real-world performance benchmark suite across camera models",
  )
  println(
    "  calibrate  Execute target calibration and non-linear Levenberg-Marquardt optimizer",
  )
  println(
    "  pnp        Solve 3D-2D Perspective-n-Point pose estimation problem",
  )
  println("  version    Display CLI version and toolchain info")
}

///|
fn main {
  println("=========================================================")
  println("  MoonBit Camera Models CLI Tool")
  println("=========================================================")

  let kitti = @datasets.load_kitti_left_camera()
  println("[CLI] Loaded Preset Dataset: " + kitti.name)

  let pinhole = kitti.pinhole_camera.unwrap()
  println(
    "[CLI] Pinhole Intrinsics: fx=" +
    pinhole.fx.to_string() +
    ", fy=" +
    pinhole.fy.to_string() +
    ", cx=" +
    pinhole.cx.to_string() +
    ", cy=" +
    pinhole.cy.to_string(),
  )

  let p3d = @math.Vec3::new(1.0, -0.5, 4.0)
  let proj = pinhole.project(p3d)
  println(
    "[CLI] Project 3D (1.0, -0.5, 4.0) -> Pixel (" +
    proj.pixel.x.to_string() +
    ", " +
    proj.pixel.y.to_string() +
    ") in_fov=" +
    proj.in_fov.to_string(),
  )

  let dist = @distortion.BrownConrady::identity()
  let dist_pt = dist.distort(proj.pixel)
  println(
    "[CLI] Distortion check: (" +
    dist_pt.x.to_string() +
    ", " +
    dist_pt.y.to_string() +
    ")",
  )

  let ray = pinhole.unproject(proj.pixel, proj.depth)
  println("[CLI] Unprojected ray length: " + ray.norm().to_string())

  let target_3d = @calibration.generate_checkerboard_target(5, 5, 0.03)
  println(
    "[CLI] Generated checkerboard 3D target points count: " +
    target_3d.length().to_string(),
  )

  let pnp_sol = @geometry.solve_pnp_dlt(target_3d, [proj.pixel], pinhole)
  let pnp_status = match pnp_sol {
    Some(_) => true
    None => false
  }
  println("[CLI] DLT PnP status: " + pnp_status.to_string())

  let json_str = @io.pinhole_to_json(pinhole)
  println("[CLI] Serialized JSON parameters:")
  println(json_str)

  let bench_checksum = @benchmarks.run_pinhole_batch_benchmark(100)
  println(
    "[CLI] Benchmarked batch projection checksum: " + bench_checksum.to_string(),
  )

  let fhd_cam = @lib.create_standard_fhd_camera()
  println("[CLI] Standard FHD Camera FX: " + fhd_cam.fx.to_string())

  println("")
  print_usage()
}
