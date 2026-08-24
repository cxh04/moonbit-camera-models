// Command-Line Interface for MoonBit Camera Models

///|
fn print_usage() -> Unit {
  println("MoonBit Camera Models CLI v0.2.1")
  println("Usage: moon run src/cmd/main -- <command> [argument]")
  println("")
  println("Commands:")
  println("  info                 Show the built-in KITTI camera preset")
  println("  project              Project a documented sample 3D point")
  println("  unproject            Unproject the sample pixel at its depth")
  println("  bench [count]        Measure projection throughput; default 10000")
  println("  version              Show the CLI version")
  println("  help                 Show this help")
}

///|
fn print_camera_info() -> Unit {
  let dataset = @datasets.load_kitti_left_camera()
  let camera = dataset.pinhole_camera.unwrap()
  let fov = camera.field_of_view().to_degrees()
  println("dataset=" + dataset.name)
  println("sensor=" + dataset.sensor_type)
  println(
    "intrinsics=" +
    camera.fx.to_string() +
    "," +
    camera.fy.to_string() +
    "," +
    camera.cx.to_string() +
    "," +
    camera.cy.to_string(),
  )
  println(
    "fov_degrees=" +
    fov.0.to_string() +
    "," +
    fov.1.to_string() +
    "," +
    fov.2.to_string(),
  )
}

///|
fn run_projection_demo() -> Unit {
  let camera = @lib.create_standard_fhd_camera()
  let point = @math.Vec3::new(1.0, -0.5, 4.0)
  let projection = camera.project(point)
  println(
    "point=" +
    point.x.to_string() +
    "," +
    point.y.to_string() +
    "," +
    point.z.to_string(),
  )
  println(
    "pixel=" +
    projection.pixel.x.to_string() +
    "," +
    projection.pixel.y.to_string() +
    " depth=" +
    projection.depth.to_string() +
    " in_fov=" +
    projection.in_fov.to_string(),
  )
}

///|
fn run_unprojection_demo() -> Unit {
  let camera = @lib.create_standard_fhd_camera()
  let point = @math.Vec3::new(1.0, -0.5, 4.0)
  let projection = camera.project(point)
  let reconstructed = camera.unproject(projection.pixel, projection.depth)
  println(
    "reconstructed=" +
    reconstructed.x.to_string() +
    "," +
    reconstructed.y.to_string() +
    "," +
    reconstructed.z.to_string(),
  )
  println("roundtrip_error=" + point.distance(reconstructed).to_string())
}

///|
fn parse_count(args : Array[String]) -> Int {
  if args.length() < 3 {
    10000
  } else {
    @string.parse_int(args[2]) catch {
      _ => 10000
    }
  }
}

///|
fn run_benchmark(args : Array[String]) -> Unit {
  let count = parse_count(args)
  let pinhole = @benchmarks.measure_pinhole_batch(count)
  let fisheye = @benchmarks.measure_fisheye_batch(count)
  println(@benchmarks.format_batch_report(pinhole, fisheye))
}

///|
fn main {
  let args = @env.args()
  let command = if args.length() < 2 { "help" } else { args[1] }
  match command {
    "info" => print_camera_info()
    "project" => run_projection_demo()
    "unproject" => run_unprojection_demo()
    "bench" => run_benchmark(args)
    "version" => println("moonbit-camera-models-cli 0.2.1")
    "help" | "--help" | "-h" => print_usage()
    _ => {
      println("Unknown command: " + command)
      print_usage()
    }
  }
}
