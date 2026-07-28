test "top facade demo pipeline" {
  let p = @math.Vec3::new(3.0, -2.0, 8.0)
  let (u, v, err_x, err_y, err_z) = demo_projection_pipeline(p)
  assert_true(u > 0.0)
  assert_true(v > 0.0)
  assert_true(err_x < 0.0001)
  assert_true(err_y < 0.0001)
  assert_true(err_z < 0.0001)
}
