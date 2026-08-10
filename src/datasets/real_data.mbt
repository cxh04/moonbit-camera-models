// Real-World Benchmark Datasets for Camera Calibration & SLAM

///| Real-World Dataset Preset Struct
pub(all) struct DatasetCamera {
  name : String
  sensor_type : String
  pinhole_camera : @camera.PinholeCamera?
  fisheye_camera : @camera.FisheyeCamera?
  double_sphere_camera : @camera.DoubleSphereCamera?
} derive(Debug, Eq)

///| Load KITTI Vision Benchmark Suite Stereo Pinhole Left Camera Parameters
pub fn load_kitti_left_camera() -> DatasetCamera {
  let dist = @distortion.BrownConrady::new(-0.369, 0.196, 0.0006, 0.0009, -0.067)
  let cam = @camera.PinholeCamera::with_distortion(
    721.5377, 721.5377, 609.5593, 172.854, 0.0, 1242.0, 375.0, dist
  )
  {
    name: "KITTI_Gray_Left_Cam0",
    sensor_type: "Pinhole_BrownConrady",
    pinhole_camera: Some(cam),
    fisheye_camera: None,
    double_sphere_camera: None,
  }
}

///| Load TUM VI SLAM Benchmark Double Sphere Camera Parameters (Cam 0)
pub fn load_tum_vi_ds_camera() -> DatasetCamera {
  let ds_cam = @camera.DoubleSphereCamera::new(
    384.444, 383.748, 255.433, 255.084, -0.1782, 0.5841, 512.0, 512.0
  )
  {
    name: "TUM_VI_Room1_Cam0",
    sensor_type: "DoubleSphere",
    pinhole_camera: None,
    fisheye_camera: None,
    double_sphere_camera: Some(ds_cam),
  }
}

///| Load GoPro Hero 10 4K Fisheye Wide Angle Camera Parameters
pub fn load_gopro_hero10_fisheye() -> DatasetCamera {
  let fisheye = @camera.FisheyeCamera::new(
    1450.2, 1448.8, 1920.0, 1080.0, 0.0125, -0.0028, 0.00041, -0.00003, 3840.0, 2160.0
  )
  {
    name: "GoPro_Hero10_4K_Wide",
    sensor_type: "KannalaBrandt_Fisheye",
    pinhole_camera: None,
    fisheye_camera: Some(fisheye),
    double_sphere_camera: None,
  }
}

///| Load iPhone 15 Pro Main Camera (24mm Equivalent) Real Intrinsics
pub fn load_iphone15_pro_main_camera() -> DatasetCamera {
  let dist = @distortion.BrownConrady::new(0.0182, -0.0041, 0.0001, -0.00015, 0.0)
  let cam = @camera.PinholeCamera::with_distortion(
    3040.5, 3040.5, 2016.0, 1512.0, 0.0, 4032.0, 3024.0, dist
  )
  {
    name: "iPhone15Pro_Main_24mm",
    sensor_type: "Pinhole_BrownConrady",
    pinhole_camera: Some(cam),
    fisheye_camera: None,
    double_sphere_camera: None,
  }
}

///| Ground-Truth 3D Target Point Feature Collection for Benchmark Accuracy Tests
pub fn get_benchmark_3d_features() -> Array[@math.Vec3] {
  [
    @math.Vec3::new(0.0, 0.0, 2.0),
    @math.Vec3::new(-1.5, 1.0, 3.5),
    @math.Vec3::new(2.0, -1.2, 4.0),
    @math.Vec3::new(-0.8, -1.8, 5.2),
    @math.Vec3::new(1.4, 1.5, 6.0),
    @math.Vec3::new(-2.2, 0.5, 7.5),
    @math.Vec3::new(0.0, 2.0, 8.0),
    @math.Vec3::new(3.0, -2.5, 10.0),
  ]
}
