# MoonBit Camera Models

[![CI](https://github.com/cxh04/moonbit-camera-models/actions/workflows/check.yml/badge.svg)](https://github.com/cxh04/moonbit-camera-models/actions/workflows/check.yml)
[![License](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-stable-purple.svg)](https://www.moonbitlang.com)

`moonbit-camera-models` is a typed, dependency-light computer-vision foundation for MoonBit. It provides camera projection, lens distortion, multi-view geometry, calibration utilities, dataset presets, and interoperability with common calibration formats.

## Project positioning

The library targets reusable geometry primitives for robotics, SLAM, panorama rendering, AR/VR, calibration tools, and multi-view reconstruction. The implementation is organized as independent MoonBit packages so applications can depend on only the parts they need.

## Core capabilities

- Camera models: pinhole, orthographic, Kannala–Brandt fisheye, equirectangular, cubemap, Scaramuzza, double-sphere, unified, division, and FOV models.
- Distortion: Brown–Conrady, thin-prism, equidistant fisheye, and remap-LUT interpolation.
- Math: vectors, 3x3/4x4 matrices, LU/QR/SVD, linear solvers, SO(3)/SE(3) transforms, Rodrigues maps, and symmetric eigenvectors for small homogeneous systems.
- Geometry: essential/fundamental matrices, normalized eight-point estimation, Sampson and symmetric epipolar errors, DLT PnP, stereo rectification, and triangulation.
- Calibration: checkerboard targets, reprojection metrics, robust losses, remap coordinates, and focal-length refinement.
- Interoperability: JSON, OpenCV YAML, and COLMAP `cameras.txt` parsing/export.
- Presets and evaluation: KITTI, TUM VI, GoPro, iPhone, synthetic point clouds, circular trajectories, precision checks, and measured batch benchmarks.

## Quick start

Add the packages used by an application to its `moon.pkg` file:

```moonbit
import {
  "cxh04/moonbit_camera_models/src/camera",
  "cxh04/moonbit_camera_models/src/math",
}
```

Then project and unproject points:

```moonbit
let camera = @camera.PinholeCamera::new(
  800.0, 800.0, 640.0, 360.0, 1280.0, 720.0,
)
let point = @math.Vec3::new(1.0, -0.5, 4.0)
let projection = camera.project(point)
let recovered = camera.unproject(projection.pixel, projection.depth)
```

The public package interfaces are generated with `moon info` and are checked into the repository as `pkg.generated.mbti` files.

## CLI

The example executable is available through MoonBit’s native runner:

```bash
moon run src/cmd/main -- help
moon run src/cmd/main -- info
moon run src/cmd/main -- project
moon run src/cmd/main -- unproject
moon run src/cmd/main -- bench 10000
```

The benchmark command emits CSV with operation, sample count, elapsed microseconds, operations per second, and a checksum that prevents the projection loop from being optimized away.

## Architecture

```text
moonbit-camera-models/
├── moon.mod
├── README.md -> README.mbt.md
├── src/
│   ├── math/          vector, matrix, decomposition, solver, and SE(3) math
│   ├── distortion/    lens models and remap LUTs
│   ├── camera/        projection/unprojection models and stereo rigs
│   ├── geometry/      epipolar geometry, PnP, rectification, triangulation
│   ├── calibration/   targets, metrics, losses, and optimization
│   ├── datasets/      real-camera presets and synthetic generators
│   ├── io/            COLMAP, JSON, and OpenCV serialization
│   ├── benchmarks/    measured performance and precision workloads
│   ├── lib/            small high-level facade helpers
│   └── cmd/main/      runnable CLI
└── .github/workflows/ check.yml and publish.yml
```

Production implementation is counted separately from tests and verification fixtures. The current repository is above 5,000 lines of non-test MoonBit implementation; the exact count can be reproduced with:

```powershell
Get-ChildItem src -Recurse -Filter *.mbt |
  Where-Object { $_.Name -notmatch '(_test|_wbtest|boundary_test|verification_table|grid_tables|feature_tables|batch_\d+_verification)\.mbt$' } |
  Get-Content | Measure-Object -Line
```

## Benchmarks

Run a local measurement with the toolchain installed on the machine:

```bash
moon run src/cmd/main -- bench 10000
```

Example output captured on Windows x64 with MoonBit `0.1.20260807`:

```text
operation,samples,elapsed_us,operations_per_second,checksum
pinhole_projection,10000,3300.2000000000003,3030119.386703836,9693982.740837783
fisheye_projection,10000,3735.1,2677304.4898396297,9929626.307089247
```

These are reproducible workload outputs, not hardware-independent guarantees. Compare runs only with the same point count, backend, compiler, operating-system conditions, and a warmed-up machine.

## Testing

The suite includes black-box behavior tests, white-box package tests, numerical verification tables, boundary tests, parser rejection tests, and synthetic geometric truth tests. The high-value tests cover round trips, degenerate input handling, malformed calibration records, PnP reprojection, and eight-point epipolar residuals.

```bash
moon fmt --check
moon check --deny-warn --target all
moon test --deny-warn --target all
```

## Continuous integration

`.github/workflows/check.yml` follows the MoonBit community workflow pattern. It installs the current stable toolchain on Ubuntu, macOS, and Windows, updates dependencies, checks all supported targets, runs all-target tests, formats the project, and verifies that `moon info` does not leave generated interface changes.

## Publishing

Package metadata is declared in `moon.mod` with the Apache-2.0 license and the GitHub repository URL. After local checks pass and the package version is available on Mooncakes:

```bash
moon login
moon publish
```

The repository also contains a manual GitHub Actions publish workflow. It expects a repository secret named `MOONCAKES_CREDENTIALS_JSON`; no credential is stored in source control.

## License

Apache License 2.0. See [LICENSE](LICENSE).
