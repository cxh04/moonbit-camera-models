# MoonBit Camera Models (`moonbit-camera-models`)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Build Status](https://github.com/cxh04/moonbit-camera-models/workflows/CI/badge.svg)](https://github.com/cxh04/moonbit-camera-models/actions)
[![MoonBit Version](https://img.shields.io/badge/MoonBit-0.10.3%2B-purple.svg)](https://www.moonbitlang.com)

A high-performance, modular camera model and 3D coordinate transformation library for **MoonBit**.

`moonbit-camera-models` provides complete projection, unprojection (ray generation), lens distortion modeling, multi-view epipolar geometry, 3D triangulation, and parameter serialization for computer vision, robotics, panorama rendering, camera calibration, AR/VR, and 3D reconstruction pipelines.

---

## Key Features

- 📷 **Comprehensive Camera Models**:
  - **Pinhole Camera**: Ideal perspective projection with skew parameter support.
  - **Fisheye Camera**: Kannala-Brandt (Equidistant) 4-parameter polynomial model for wide-angle lenses.
  - **Equirectangular Camera**: 360-degree spherical panorama mapping $(\lambda, \phi)$.
  - **Orthographic Camera**: Parallel perspective-free projection for CAD / telecentric vision.
  - **Scaramuzza Omnidirectional Model**: High-degree polynomial unprojection for catadioptric robotics vision.
  - **Double Sphere Model**: Dual-sphere projection model for visual odometry & SLAM (DSO, Basalt).
  - **Unified Camera Model (EUCM)**: Mei extended unified omnidirectional model.

- 🌀 **Lens Distortion Models**:
  - **Brown-Conrady**: Radial ($k_1, k_2, k_3$) + Tangential ($p_1, p_2$) distortion with iterative Newton-Raphson undistortion.
  - **Division Model**: Fast analytical inverse radial distortion model.
  - **FOV Model**: Field-of-view arc distortion model.

- 📐 **Vector & Pose Math**:
  - 2D, 3D, and 4D vector algebra (`Vec2`, `Vec3`, `Vec4`).
  - 3x3 Matrix operations (`Mat3x3` determinant, inverse, transpose, vector multiplication).
  - Quaternion rotation representations (`Quaternion`).
  - $SE(3)$ Rigid Transformations (`RigidTransform` pose composition and inverse).

- 🛰️ **Stereo & Multi-View Geometry**:
  - Essential Matrix ($E = [t]_\times R$) and Fundamental Matrix ($F = K_2^{-T} E K_1^{-1}$).
  - Epipolar line equation generation and point-to-line distance metrics.
  - Midpoint 3D Ray Triangulation.

- 💾 **Serialization & Ecosystem Interop**:
  - JSON parameter export and import.
  - OpenCV YAML calibration matrix format exporter.
  - COLMAP `cameras.txt` file format exporter.

- 📊 **Calibration & Benchmarking**:
  - Root Mean Square (RMS) reprojection error evaluation metrics.
  - Image undistortion remap grid coordinate calculation.
  - Batch performance benchmark suite.

---

## Ecosystem Uniqueness & Scalability

Before developing `moonbit-camera-models`, a search on **mooncakes.io** confirmed that no dedicated geometric camera optics, projection transformation, or lens distortion package exists in the MoonBit package ecosystem.

`moonbit-camera-models` is built from the ground up to serve as a foundation for:
1. **Camera Calibration Tooling**: Estimating intrinsic/extrinsic parameters from checkerboard or AprilTag targets.
2. **Panorama & Image Rectification**: Warping wide-angle/fisheye images to perspective rectilinear views.
3. **Robotics & Visual SLAM**: Processing camera observations in VIO/SLAM backends.
4. **Game Engines & WebGPU Rendering**: Ray casting, depth unprojection, and virtual camera controllers.

---

## Package Architecture

```
moonbit-camera-models/
├── moon.mod
├── src/
│   ├── math/           # Vec2, Vec3, Vec4, Mat3x3, Quaternion, Ray, RigidTransform
│   ├── distortion/     # Brown-Conrady, DivisionModel, FOVModel
│   ├── camera/         # Pinhole, Fisheye, Equirectangular, Orthographic, Scaramuzza, DoubleSphere, Unified
│   ├── geometry/       # EssentialMatrix, FundamentalMatrix, EpipolarLines, Triangulation
│   ├── io/             # JSON, OpenCV YAML, COLMAP camera exporters
│   ├── calibration/    # RMS Reprojection Error, Undistort Remap Grid
│   ├── benchmarks/     # Batch projection performance suite
│   └── lib/            # High-level library facade and presets
└── .github/
    └── workflows/
        └── ci.yml      # Multi-platform CI workflow (Linux, macOS, Windows)
```

---

## Quick Start & Usage Examples

### 1. Pinhole Projection and Ray Unprojection

```moonbit
import "cxh04/moonbit_camera_models/src/math"
import "cxh04/moonbit_camera_models/src/distortion"
import "cxh04/moonbit_camera_models/src/camera"

test "camera workflow example" {
  // Define Brown-Conrady distortion
  let distortion = @distortion.BrownConrady::new(0.02, -0.005, 0.001, -0.001, 0.0)

  // Construct 1080p Pinhole Camera
  let camera = @camera.PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, distortion
  )

  // 3D point in camera coordinate frame
  let point_3d = @math.Vec3::new(1.5, -0.8, 5.0)

  // Project to 2D pixel
  let result = camera.project(point_3d)

  // Unproject back to 3D point using known depth
  let reconstructed_3d = camera.unproject(result.pixel, result.depth)
}
```

### 2. Fisheye Camera Projection

```moonbit
import "cxh04/moonbit_camera_models/src/camera"

test "fisheye projection example" {
  let fisheye = @camera.FisheyeCamera::new(
    400.0, 400.0, 640.0, 360.0,
    0.01, -0.002, 0.0005, -0.0001,
    1280.0, 720.0
  )

  let point_3d = @math.Vec3::new(2.0, 1.0, 3.0)
  let proj = fisheye.project(point_3d)
}
```

### 3. Stereo 3D Triangulation

```moonbit
import "cxh04/moonbit_camera_models/src/math"
import "cxh04/moonbit_camera_models/src/geometry"

test "stereo triangulation example" {
  let pose1 = @math.RigidTransform::identity()
  let pose2 = @math.RigidTransform::new(
    @math.Mat3x3::identity(),
    @math.Vec3::new(0.5, 0.0, 0.0) // 0.5m baseline
  )

  let ray1 = @math.Ray::new(@math.Vec3::zero(), @math.Vec3::new(0.1, 0.05, 1.0))
  let ray2 = @math.Ray::new(@math.Vec3::zero(), @math.Vec3::new(-0.025, 0.05, 1.0))

  let point_3d = @geometry.triangulate_midpoint(pose1, ray1, pose2, ray2)
}
```

### 4. Exporting Calibration Files

```moonbit
import "cxh04/moonbit_camera_models/src/io"
import "cxh04/moonbit_camera_models/src/lib"

test "export calibration example" {
  let cam = @lib.create_standard_fhd_camera()
  
  // Export OpenCV YAML
  let yaml_config = @io.export_opencv_yaml(cam)

  // Export COLMAP camera format
  let colmap_line = @io.export_colmap_camera(cam, 1)
}
```

---

## Verification & Testing

Run all unit tests and benchmarks locally:

```bash
# Check formatting
moon fmt

# Run compiler checks
moon check

# Execute test suite
moon test
```

---

## Source Attribution & Originality Statement (来源说明)

This project (`moonbit-camera-models`) is independently designed and written specifically for the **Open Source Contest 2026 (OSC 2026)** MoonBit track.

- **Author & Single Contributor**: `cxh04` (GitHub) / `cxh0404` (GitLink).
- **Origin**: All source code (`.mbt` files), mathematical formulations, vector algebra, camera projection logic, unit test suites, and documentation are original implementations created for this competition.
- **Dependencies**: Uses standard MoonBit core library (`moonbitlang/core`).

---

## License

Distributed under the **Apache-2.0 License**. See [`LICENSE`](LICENSE) for details.
