// Performance and Precision Benchmark Verification Tables

///|
/// Verification Test for Batch Pinhole Projection Throughput and Non-NaN Checksum over 5 Batch Sizes
test "benchmarks verification table 1 - batch throughput checksum verification" {
  let sizes = [10, 50, 100, 200, 500]
  for i in 0..<sizes.length() {
    let n = sizes[i]
    let cs_pinhole = run_pinhole_batch_benchmark(n)
    let cs_fisheye = run_fisheye_batch_benchmark(n)

    assert_true(cs_pinhole > 0.0)
    assert_true(cs_fisheye > 0.0)
  }
}

///|
/// Verification Test for Precision Benchmark Metric Bounds
test "benchmarks verification table 1 - precision benchmark metric bounds" {
  let metric = evaluate_pinhole_precision()
  assert_eq(metric.name, "Pinhole_Precision_Roundtrip")
  assert_true(metric.max_residual >= 0.0)
  assert_true(metric.mean_residual >= 0.0)
  assert_true(metric.converged)
}
