// Reproducible wall-clock measurements for the projection kernels

///|
/// Result of one batch benchmark measurement.
pub(all) struct BatchBenchmarkResult {
  operation : String
  samples : Int
  elapsed_us : Double
  operations_per_second : Double
  checksum : Double
} derive(Debug)

///|
/// Measure pinhole projection throughput using the monotonic benchmark clock.
pub fn measure_pinhole_batch(count : Int) -> BatchBenchmarkResult {
  let start = @clock.monotonic_clock_start()
  let checksum = run_pinhole_batch_benchmark(count)
  let elapsed_us = @clock.monotonic_clock_end(start)
  {
    operation: "pinhole_projection",
    samples: count,
    elapsed_us,
    operations_per_second: throughput(count, elapsed_us),
    checksum,
  }
}

///|
/// Measure fisheye projection throughput using the monotonic benchmark clock.
pub fn measure_fisheye_batch(count : Int) -> BatchBenchmarkResult {
  let start = @clock.monotonic_clock_start()
  let checksum = run_fisheye_batch_benchmark(count)
  let elapsed_us = @clock.monotonic_clock_end(start)
  {
    operation: "fisheye_projection",
    samples: count,
    elapsed_us,
    operations_per_second: throughput(count, elapsed_us),
    checksum,
  }
}

///|
/// Format two measurements as a stable, copy-pasteable CLI report.
pub fn format_batch_report(
  pinhole : BatchBenchmarkResult,
  fisheye : BatchBenchmarkResult,
) -> String {
  "operation,samples,elapsed_us,operations_per_second,checksum\n" +
  benchmark_row(pinhole) +
  "\n" +
  benchmark_row(fisheye)
}

///|
fn benchmark_row(result : BatchBenchmarkResult) -> String {
  result.operation +
  "," +
  result.samples.to_string() +
  "," +
  result.elapsed_us.to_string() +
  "," +
  result.operations_per_second.to_string() +
  "," +
  result.checksum.to_string()
}

///|
fn throughput(count : Int, elapsed_us : Double) -> Double {
  if count <= 0 || elapsed_us <= 0.0 {
    0.0
  } else {
    count.to_double() * 1.0e6 / elapsed_us
  }
}
