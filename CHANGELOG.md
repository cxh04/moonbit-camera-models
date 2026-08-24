# Changelog

## 0.2.1

- Consolidated verification around behavior, boundary conditions, numerical truth, and reproducible workloads.
- Updated the CI minimum to Moonc `v0.10.9` or newer.

## 0.2.0

- Added camera projection, unprojection, distortion, calibration, dataset, and multi-view geometry packages for MoonBit.
- Added normalized eight-point fundamental-matrix estimation and DLT PnP pose estimation.
- Added JSON, OpenCV YAML, and COLMAP camera interchange helpers.
- Added boundary, malformed-input, numerical-truth, and round-trip tests.
- Added a runnable CLI with reproducible projection benchmarks.
- Added multi-platform CI checks and a manual Mooncakes publishing workflow.
