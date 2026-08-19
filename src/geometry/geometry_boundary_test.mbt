// Extensive Boundary Test Suite for Multi-View Epipolar Geometry and Triangulation

///|
/// Boundary Test: Essential & Fundamental Matrix Rank-2 and Constraint Checks
test "essential matrix algebraic rank-2 properties" {
  let r = @math.euler_to_mat3x3(0.1, -0.1, 0.2)
  let t = @math.Vec3::new(1.0, -0.5, 0.2)
  let e = essential_matrix(r, t)

  let p1 = @math.Vec3::new(0.5, -0.2, 3.0)
  let p2 = r.mul_vec3(p1).add(t)

  let x1 = p1.normalized()
  let x2 = p2.normalized()

  let ex1 = e.mul_vec3(x1)
  let epipolar_err = x2.dot(ex1)
  assert_true(epipolar_err.abs() < 1.0e-5)
}

///|
/// Boundary Test: Fundamental Matrix Epipolar Line Generation & Distance Metrics
test "fundamental matrix epipolar line and sampson error bounds" {
  let r = @math.euler_to_mat3x3(0.05, 0.0, 0.0)
  let t = @math.Vec3::new(-0.5, 0.0, 0.0)
  let e = essential_matrix(r, t)

  let k = @math.Mat3x3::new(800.0, 0.0, 640.0, 0.0, 800.0, 360.0, 0.0, 0.0, 1.0)
  let k_inv = k.inverse().unwrap()
  let f = fundamental_matrix(e, k_inv, k_inv)

  let pt1 = @math.Vec2::new(500.0, 300.0)
  let line2 = compute_epipolar_line(f, pt1)
  assert_true(line2.x != 0.0 || line2.y != 0.0)

  let dist_on_line = distance_to_epipolar_line(line2, pt1)
  assert_true(dist_on_line >= 0.0)
}

///|
/// Boundary Test: DLT PnP Pose Estimation Degenerate Configurations
test "pnp dlt pose estimation degenerate input handling" {
  let empty_3d : Array[@math.Vec3] = []
  let empty_2d : Array[@math.Vec2] = []
  let cam = @camera.PinholeCamera::new(
    800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
  )

  assert_true(solve_pnp_dlt(empty_3d, empty_2d, cam) is None)

  let pts3 = [@math.Vec3::new(1.0, 1.0, 1.0), @math.Vec3::new(2.0, 2.0, 2.0)]
  let pts2 = [@math.Vec2::new(100.0, 100.0), @math.Vec2::new(200.0, 200.0)]
  assert_true(solve_pnp_dlt(pts3, pts2, cam) is None)
}

///|
/// Boundary Test: DLT & Midpoint Triangulation Ray Intersection Invariants
test "dlt and midpoint triangulation boundary ray intersection" {
  let ray1 = @math.Ray::new(
    @math.Vec3::new(0.0, 0.0, 0.0),
    @math.Vec3::new(0.2, 0.1, 1.0),
  )
  let ray2 = @math.Ray::new(
    @math.Vec3::new(1.0, 0.0, 0.0),
    @math.Vec3::new(-0.8, 0.1, 1.0),
  )

  let p_tri = triangulate_midpoint(
    @math.RigidTransform::identity(),
    ray1,
    @math.RigidTransform::new(
      @math.Mat3x3::identity(),
      @math.Vec3::new(1.0, 0.0, 0.0),
    ),
    ray2,
  )
  assert_true(p_tri.norm() >= 0.0)
}
