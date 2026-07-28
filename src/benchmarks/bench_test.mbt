test "benchmark execution integrity" {
  let c1 = run_pinhole_batch_benchmark(1000)
  assert_true(c1 != 0.0)

  let c2 = run_fisheye_batch_benchmark(1000)
  assert_true(c2 != 0.0)
}
