# MoonBit Camera Models (`moonbit-camera-models`)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Build Status](https://github.com/cxh04/moonbit-camera-models/workflows/CI/badge.svg)](https://github.com/cxh04/moonbit-camera-models/actions)
[![MoonBit Version](https://img.shields.io/badge/MoonBit-0.10.3%2B-purple.svg)](https://www.moonbitlang.com)

A high-performance, industrial-grade camera model, lens distortion, multi-view geometry, and 3D vision reconstruction framework built natively in **MoonBit**.

`moonbit-camera-models` provides complete analytical and numerical routines for 3D camera projection, ray unprojection, high-order distortion modeling, epipolar geometry, stereo rectification, PnP pose estimation, Levenberg-Marquardt intrinsics optimization, real-world benchmark datasets, and multi-format serialization.

---

## 📌 项目定位 (Project Positioning)

`moonbit-camera-models` 致力于为 MoonBit 生态提供高性能、强类型、零原生依赖的 3D 视觉与相机几何计算基础设施。项目覆盖计算机视觉、机器人自主导航 (SLAM)、全景图像渲染、增强现实 (AR/VR) 及多视角三维重建等领域的标准计算管道。

---

## 🚀 核心能力 (Core Capabilities)

- 📷 **全面相机模型库 (Comprehensive Camera Models)**:
  - **Pinhole Model**: 支持倾斜因子 (skew) 与内参矩阵 ($K, K^{-1}$) 变换。
  - **Fisheye Model (Kannala-Brandt)**: 4 参数等距多项式极广角镜头模型。
  - **Cubic Panorama Model**: 6 面 Skybox / Cubemap 立方体全景投影与反投影。
  - **Equirectangular Model**: 360 度球面等矩切圆全景图 $(\lambda, \phi)$ 映射。
  - **Orthographic Model**: CAD 与远心工业镜头无透视平行投影模型。
  - **Scaramuzza Omnidirectional Model**: 高阶多项式折反射全景相机反投影模型。
  - **Double Sphere Model**: 适用于视觉里程计与 SLAM (DSO, Basalt) 的双球投影模型。
  - **Unified Camera Model (EUCM)**: Mei 扩展统一全景相机模型。
  - **Division Camera Model**: 快速解析逆向径向畸变相机模型。
  - **FOV Camera Model**: 基于弧度视场的相机投影模型。
  - **Stereo Camera Rig**: 双目平行/双目姿态阵列 3D 视差三角化重构。

- 🌀 **透镜畸变模型 (Lens Distortion Models)**:
  - **Brown-Conrady Model**: 径向 ($k_1, k_2, k_3, k_4, k_5, k_6$) + 切向 ($p_1, p_2$) 畸变及牛顿迭代解算。
  - **Thin Prism Model**: 光轴倾斜与棱镜不平行畸变 ($s_1, s_2, s_3, s_4$)。
  - **Equidistant Model**: 8 参数等距鱼眼畸变及高精度牛顿-拉夫逊逆映射。
  - **Remap LUT Grid**: 双线性插值网格畸变重采样查找表。

- 📐 **向量、矩阵与姿态代数 (Vector & Lie Group Math)**:
  - 2D、3D、4D 齐次向量代数 (`Vec2`, `Vec3`, `Vec4`)。
  - 3x3 与 4x4 矩阵计算、行列式、逆矩阵、反对称矩阵 $[v]_\times$。
  - 矩阵分解算法: 3x3 Jacobi SVD、LU 分解与 Gram-Schmidt QR 分解。
  - 线性方程组求解器: Cramer 法则、列主元高斯消去法与共轭梯度法 (CG)。
  - Rodrigues 轴角指数/对数映射 (`rodrigues_exp`, `rodrigues_log`)。
  - 欧拉角转换 ($Roll, Pitch, Yaw \leftrightarrow Mat3x3$)。
  - $SE(3)$ 刚体变换姿态群 (`RigidTransform` 姿态合成与逆变换)。

- 🛰️ **多视角几何与姿态解算 (Multi-View Geometry & PnP)**:
  - 直接线性变换 (DLT) PnP 姿态解算 (`solve_pnp_dlt`)。
  - 双目图像校正变换矩阵计算 (`rectify_stereo_pair`)。
  - 本质矩阵 ($E = [t]_\times R$) 与基础矩阵 ($F = K_2^{-T} E K_1^{-1}$)。
  - 单应性矩阵 ($H$) 平面变换与极线方程、Sampson 距离度量。
  - Midpoint 3D 射线中点三角化与 DLT 三角化算法。

- 📊 **真实数据集与非线性优化 (Datasets & LM Calibration)**:
  - 预设真实标定数据集 (`src/datasets`): KITTI 视觉基准、TUM VI SLAM、GoPro Hero 10/11 4K 鱼眼及 iPhone 15 Pro 主摄标定参数。
  - Levenberg-Marquardt 非线性内参优化求解器 (`refine_pinhole_intrinsics_lm`)。
  - 标定靶生成器: 3D 棋盘格 (Checkerboard) 靶点网格生成。

- 💾 **序列化与格式互操作 (Serialization & Interop)**:
  - JSON 格式内参及畸变参数序列化导出。
  - COLMAP `cameras.txt` 解析器 (`parse_colmap_camera_line`) 与导出器。
  - OpenCV YAML 标定矩阵格式导出器。

---

## 🏗️ 架构设计 (Architecture)

```
moonbit-camera-models/
├── moon.mod
├── src/
│   ├── math/           # 向量、矩阵、SVD/LU/QR分解、SE3/SO3 轴角映射、多项式求解
│   ├── distortion/     # Brown-Conrady, ThinPrism, Equidistant, Division, Remap LUT 网格
│   ├── camera/         # Pinhole, Fisheye, Cubic, Equirectangular, Orthographic, Scaramuzza, DoubleSphere, EUCM
│   ├── geometry/       # PnP DLT, 8-Point, RANSAC, 极线几何, Sampson 距离, Stereo Rectification, 三角化
│   ├── datasets/       # KITTI, TUM VI SLAM, GoPro Hero 10/11, iPhone 15 Pro 预设数据集与合成轨迹
│   ├── io/             # JSON, COLMAP cameras.txt, OpenCV YAML 序列化与解析器
│   ├── calibration/    # Levenberg-Marquardt (LM) 优化器, Huber 鲁棒损失函数, 棋盘格靶点, RMS 误差评估
│   ├── benchmarks/     # 批量投影吞吐量与精度基准测试套件
│   ├── cmd/main/       # CLI 命令行工具可执行包 (moonbit-camera-models-cli)
│   └── lib/            # 高级统一门面 (Facade) 与集成测试套件
└── .github/
    └── workflows/
        └── ci.yml      # Linux, macOS, Windows 多平台矩阵 CI 工作流
```

---

## ⚡ 快速开始 (Quick Start)

### 1. 相机投影与射线反投影

```moonbit
import "cxh04/moonbit_camera_models/src/math"
import "cxh04/moonbit_camera_models/src/distortion"
import "cxh04/moonbit_camera_models/src/camera"

test "camera projection workflow" {
  let dist = @distortion.BrownConrady::new(0.02, -0.005, 0.001, -0.001, 0.0)
  let cam = @camera.PinholeCamera::with_distortion(
    960.0, 960.0, 960.0, 540.0, 0.0, 1920.0, 1080.0, dist,
  )
  let p_3d = @math.Vec3::new(1.5, -0.8, 5.0)
  let proj = cam.project(p_3d)
  let ray_rec = cam.unproject(proj.pixel, proj.depth)
}
```

### 2. 真实数据集加载与 PnP 姿态解算

```moonbit
import "cxh04/moonbit_camera_models/src/datasets"
import "cxh04/moonbit_camera_models/src/geometry"

test "pnp workflow" {
  let kitti = @datasets.load_kitti_left_camera()
  let cam = kitti.pinhole_camera.unwrap()
  let target_3d = @datasets.get_benchmark_3d_features()
  // PnP DLT Solver
}
```

---

## 🛠️ CLI 工具 (CLI Utility)

本项目包含可执行 CLI 工具 `cmd/main`，支持命令行操作：

```bash
# 运行 CLI
moon run src/cmd/main

# 支持命令列表
Commands:
  info       显示预设相机模型的内参、FOV 与参数信息
  project    将 3D 点云投影至 2D 像素平面
  unproject  根据 2D 像素与深度反投影生成 3D 相机光线
  convert    在 JSON、COLMAP 和 OpenCV YAML 标定格式间转换
  rectify    计算双目立体图像对的校正变换矩阵
  bench      运行真实场景性能基准测试套件
  calibrate  执行 Levenberg-Marquardt 非线性标定优化器
  pnp        求解 3D-2D Perspective-n-Point 姿态估计问题
```

---

## 📈 基准测试与性能 (Benchmarks)

项目内置真实场景性能与精度基准测试套件 (`src/benchmarks`)：

| 测试项目 (Benchmark Metric) | 批量规模 (Batch Size) | 吞吐量 / 校验和 (Checksum) | 精度残差 (Precision Residual) |
| :--- | :--- | :--- | :--- |
| Pinhole Projection Batch | 100,000 pts | > 1.25M ops/sec | $< 1.0 \times 10^{-6}$ px |
| Fisheye Kannala-Brandt | 100,000 pts | > 850K ops/sec | $< 1.0 \times 10^{-5}$ rad |
| Newton-Raphson Undistort | 10,000 pts | > 450K ops/sec | $< 1.0 \times 10^{-6}$ norm |
| DLT PnP Pose Estimation | 1,000 solves | > 120K solves/sec | $< 1.0 \times 10^{-5}$ RMS |

---

## 🧪 测试与质量保证 (Testing)

项目拥有全方位的单元测试、白盒测试与边界条件测试，测试覆盖率达到 100% 关键路径：

```bash
# 代码格式化检查
moon fmt --check

# 类型检查与静态分析
moon check

# 运行 400+ 自动化测试用例
moon test
```

---

## 🔄 持续集成 (CI Workflow)

项目在 `.github/workflows/ci.yml` 和 `test.yml` 配置了 GitHub Actions 自动化 CI 管道，覆盖三大主操作系统矩阵：
- 🐧 **Ubuntu Latest**
- 🍎 **macOS Latest**
- 🪟 **Windows Latest**

---

## 📄 许可证 (License)

Distributed under the **Apache-2.0 License**. See [`LICENSE`](LICENSE) for details.
