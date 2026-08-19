// Lookup Table (LUT) Grid Remap utilities for fast image undistortion

///|
/// 2D Undistortion Remap Map Grid storing distorted coordinates (u_d, v_d) for each output pixel (u, v)
pub(all) struct RemapLUT {
  width : Int
  height : Int
  map_x : Array[Array[Double]]
  map_y : Array[Array[Double]]
} derive(Debug)

///|
/// Generate bilinear undistortion remap map grid for given distortion model
pub fn generate_remap_lut(
  width : Int,
  height : Int,
  fx : Double,
  fy : Double,
  cx : Double,
  cy : Double,
  distort_fn : (@math.Vec2) -> @math.Vec2,
) -> RemapLUT {
  let map_x = Array::make(height, Array::make(width, 0.0))
  let map_y = Array::make(height, Array::make(width, 0.0))

  for j in 0..<height {
    let row_x = Array::make(width, 0.0)
    let row_y = Array::make(width, 0.0)
    let v = j.to_double()
    let y_u = (v - cy) / fy

    for i in 0..<width {
      let u = i.to_double()
      let x_u = (u - cx) / fx
      let pt_dist = distort_fn(@math.Vec2::new(x_u, y_u))

      row_x[i] = fx * pt_dist.x + cx
      row_y[i] = fy * pt_dist.y + cy
    }
    map_x[j] = row_x
    map_y[j] = row_y
  }

  { width, height, map_x, map_y }
}

///|
/// Sample distorted pixel coordinate (u_d, v_d) from RemapLUT given target pixel (u, v)
pub fn RemapLUT::sample(self : RemapLUT, u : Int, v : Int) -> @math.Vec2? {
  if u < 0 || u >= self.width || v < 0 || v >= self.height {
    None
  } else {
    Some(@math.Vec2::new(self.map_x[v][u], self.map_y[v][u]))
  }
}
