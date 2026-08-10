# MoonBit Camera Models (`moonbit-camera-models`)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Build Status](https://github.com/cxh04/moonbit-camera-models/workflows/CI/badge.svg)](https://github.com/cxh04/moonbit-camera-models/actions)
[![MoonBit Version](https://img.shields.io/badge/MoonBit-0.10.3%2B-purple.svg)](https://www.moonbitlang.com)

A high-performance, modular camera model, pose estimation, and 3D coordinate transformation library for **MoonBit**.

`moonbit-camera-models` provides complete projection, unprojection (ray generation), lens distortion modeling, multi-view epipolar geometry, 3D triangulation, PnP pose estimation, stereo rectification, real-world benchmark datasets, and parameter serialization for computer vision, robotics, panorama rendering, camera calibration, AR/VR, and 3D reconstruction pipelines.

---

## Key Features

- 📷 **Comprehensive Camera Models**:
  - **Pinhole Camera**: Ideal perspective projection with skew parameter & intrinsic matrix ($K, K^{-1}$) support.
  - **Fisheye Camera**: Kannala-Brandt (Equidistant) 4-parameter polynomial model for wide-angle lenses.
  - **Cubic Panorama Camera**: 6-face skybox / cubemap perspective projection mapping.
  - **Equirectangular Camera**: 360-degree spherical panorama mapping $(\lambda, \phi)$.
  - **Orthographic Camera**: Parallel perspective-free projection for CAD / telecentric vision.
  - **Scaramuzza Omnidirectional Model**: High-degree polynomial unprojection for catadioptric robotics vision.
  - **Double Sphere Model**: Dual-sphere projection model for visual odometry & SLAM (DSO, Basalt).
  - **Unified Camera Model (EUCM)**: Mei extended unified omnidirectional model.

- 🌀 **Lens Distortion Models**:
  - **Thin Prism Model**: Optical tilt and prism misalignment distortion ($s_1, s_2, s_3, s_4$).
  - **Equidistant Model**: 8-parameter high-degree fisheye distortion model with Newton-Raphson inversion.
  - **Brown-Conrady**: Radial ($k_1, k_2, k_3$) + Tangential ($p_1, p_2$) distortion with iterative undistortion.
  - **Division Model**: Fast analytical inverse radial distortion model.
  - **FOV Model**: Field-of-view arc distortion model.

- 📐 **Vector & Pose Math**:
  - 2D, 3D, and 4D vector algebra (`Vec2`, `Vec3`, `Vec4`).
  - 3x3 & 4x4 Matrix operations (`Mat3x3`, `Mat4x4`, skew-symmetric $[v]_\times$).
  - Rodrigues Axis-Angle exponential & logarithm maps (`rodrigues_exp`, `rodrigues_log`).
  - Euler Angles conversion ($Roll, Pitch, Yaw \leftrightarrow Mat3x3$).
  - Quaternion rotation representations (`Quaternion`).
  - $SE(3)$ Rigid Transformations (`RigidTransform` pose composition and inverse).

- 🛰️ **Stereo & Multi-View Geometry**:
  - Direct Linear Transformation (DLT) PnP Pose Estimation (`solve_pnp_dlt`).
  - Stereo Rectification Transformation Matrix calculation (`rectify_stereo_pair`).
  - Essential Matrix ($E = [t]_\times R$) and Fundamental Matrix ($F = K_2^{-T} E K_1^{-1}$).
  - Epipolar line equation generation, Sampson distance, and point-to-line distance metrics.
  - Midpoint 3D Ray Triangulation.

- 📊 **Real Benchmark Datasets & Optimization**:
  - **Real Datasets (`src/datasets`)**: Integrated KITTI Vision Benchmark, TUM VI SLAM, GoPro Hero 10/11 4K Fisheye, and iPhone 15 Pro Wide intrinsics datasets.
  - **Levenberg-Marquardt Optimization**: Focal length non-linear refinement solver (`refine_pinhole_intrinsics_lm`).
  - **Calibration Targets**: 3D Checkerboard grid target generator.

- 💾 **Serialization & Ecosystem Interop**:
  - JSON parameter export and import.
  - COLMAP `cameras.txt` parser (`parse_colmap_camera_line`) and exporter.
  - OpenCV YAML calibration matrix format exporter.

---

## Package Architecture

```
moonbit-camera-models/
├── moon.mod
├── src/
│   ├── math/           # Vec2, Vec3, Vec4, Mat3x3, Mat4x4, Rodrigues, Euler, SE3
│   ├── distortion/     # Brown-Conrady, ThinPrism, Equidistant8Param, DivisionModel, FOVModel
│   ├── camera/         # Pinhole, Fisheye, CubicPanorama, Equirectangular, Orthographic, Scaramuzza, DoubleSphere, EUCM
│   ├── geometry/       # PnP DLT, Stereo Rectification, EssentialMatrix, FundamentalMatrix, SampsonDistance, Triangulation
│   ├── datasets/       # KITTI, TUM VI SLAM, GoPro Hero 10/11, iPhone 15 Pro real calibration presets
│   ├── io/             # JSON, OpenCV YAML, COLMAP cameras.txt parser & exporter
│   ├── calibration/    # Levenberg-Marquardt LM refinement, Checkerboard Target, RMS Error, Undistort Remap Grid
│   ├── benchmarks/     # Batch projection performance suite
│   └── lib/            # High-level library facade, boundary test suite, and presets
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
  let distortion = @distortion.BrownConrady::new(0.02, -0.005, 0.001, -0.001, 0.0)
  let camera = @camera.PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, distortion
  )
  let point_3d = @math.Vec3::new(1.5, -0.8, 5.0)
  let result = camera.project(point_3d)
  let reconstructed_3d = camera.unproject(result.pixel, result.depth)
}
```

### 2. Real-World Datasets & Benchmark Evaluation

```moonbit
import "cxh04/moonbit_camera_models/src/datasets"

test "load dataset preset" {
  let kitti = @datasets.load_kitti_left_camera()
  let iphone = @datasets.load_iphone15_pro_main_camera()
}
```

---

## Verification & Testing

```bash
# Check formatting
moon fmt

# Run compiler checks
moon check

# Execute full 36-unit test suite
moon test
```

---

## License

Distributed under the **Apache-2.0 License**. See [`LICENSE`](LICENSE) for details.
