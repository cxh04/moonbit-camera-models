// Boundary Test Suite for Performance and Precision Benchmark Runners

///|
/// Boundary Test: Verify Benchmark Batch Run Execution and Non-Zero Output
test "projection batch benchmark execution checks" {
  let checksum_pinhole = run_pinhole_batch_benchmark(50)
  assert_true(checksum_pinhole > 0.0)

  let checksum_fisheye = run_fisheye_batch_benchmark(50)
  assert_true(checksum_fisheye > 0.0)
}

///|
/// Boundary Test: Precision Benchmark Convergence Metric Output
test "precision benchmark metric evaluation checks" {
  let metric = evaluate_pinhole_precision()
  assert_eq(metric.name, "Pinhole_Precision_Roundtrip")
  assert_true(metric.converged)
  assert_true(metric.max_residual < 1.0e-3)
}
