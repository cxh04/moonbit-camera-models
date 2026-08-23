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

///|
/// Boundary Test: Measured benchmark reports use a monotonic clock and remain
/// valid for empty batches.
test "measured benchmark report boundaries" {
  let empty = measure_pinhole_batch(0)
  assert_eq(empty.samples, 0)
  assert_eq(empty.operations_per_second, 0.0)
  assert_true(empty.elapsed_us >= 0.0)

  let pinhole = measure_pinhole_batch(200)
  let fisheye = measure_fisheye_batch(200)
  assert_eq(pinhole.samples, 200)
  assert_eq(fisheye.samples, 200)
  assert_true(pinhole.elapsed_us >= 0.0)
  assert_true(fisheye.elapsed_us >= 0.0)
  assert_true(pinhole.checksum != 0.0)
  assert_true(fisheye.checksum != 0.0)
  assert_true(
    format_batch_report(pinhole, fisheye).has_prefix("operation,samples"),
  )
}
