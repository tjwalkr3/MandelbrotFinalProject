import argv
import clip
import clip/help
import clip/opt
import gleam/bit_array
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import pngleam
import simplifile

type Args {
  Args(width: Int, height: Int, iterations: Int, zoom: Float)
}

fn command() {
  clip.command({
    use width <- clip.parameter
    use height <- clip.parameter
    use iterations <- clip.parameter
    use zoom <- clip.parameter

    Args(width, height, iterations, zoom)
  })
  |> clip.opt(
    opt.new("width")
    |> opt.short("x")
    |> opt.int
    |> opt.help("Width of the image.")
    |> opt.default(1920),
  )
  |> clip.opt(
    opt.new("height")
    |> opt.short("y")
    |> opt.int
    |> opt.help("Height of the image.")
    |> opt.default(1080),
  )
  |> clip.opt(
    opt.new("iterations")
    |> opt.short("i")
    |> opt.int
    |> opt.help("Number of iterations.")
    |> opt.default(35),
  )
  |> clip.opt(
    opt.new("zoom")
    |> opt.short("z")
    |> opt.float
    |> opt.help("Zoom factor (larger is more zoomed in).")
    |> opt.default(1.0),
  )
}

pub fn main() {
  let result =
    command()
    |> clip.help(help.simple(
      "mandelbrot",
      "Render the Mandelbrot set as a PNG.",
    ))
    |> clip.run(argv.load().arguments)

  case result {
    Error(e) -> io.println_error(e)
    Ok(args) -> {
      let image_data =
        generate_mandelbrot(args.width, args.height, args.iterations, args.zoom)
      let _ =
        write_png_file("mandelbrot.png", args.width, args.height, image_data)
      io.println("Mandelbrot set saved to mandelbrot.png")
    }
  }
}

// Generate Mandelbrot set data
pub fn generate_mandelbrot(
  width: Int,
  height: Int,
  max_iter: Int,
  zoom: Float,
) -> List(List(Float)) {
  let center_real = -0.75
  let center_imaginary = 0.0
  let real_range = 3.5 /. zoom
  let imaginary_range = 2.25 /. zoom
  let x_min = center_real -. real_range /. 2.0
  let x_max = center_real +. real_range /. 2.0
  let y_min = center_imaginary -. imaginary_range /. 2.0
  let y_max = center_imaginary +. imaginary_range /. 2.0

  let scale_x = { x_max -. x_min } /. int_to_float(width)
  let scale_y = { y_max -. y_min } /. int_to_float(height)

  list.range(0, height - 1)
  |> list.map(fn(y) {
    list.range(0, width - 1)
    |> list.map(fn(x) {
      let cx = x_min +. int_to_float(x) *. scale_x
      let cy = y_min +. int_to_float(y) *. scale_y
      let iterations = escape_time(cx, cy, max_iter)
      intensity(iterations, max_iter)
    })
  })
}

// Calculate Mandelbrot iterations for a point using tail recursion
pub fn escape_time(cx: Float, cy: Float, max_iter: Int) -> Int {
  escape_time_tail(cx, cy, max_iter, 0, 0.0, 0.0)
}

// Tail-recursive helper function
fn escape_time_tail(
  cx: Float,
  cy: Float,
  max_iter: Int,
  count: Int,
  zx: Float,
  zy: Float,
) -> Int {
  case count >= max_iter || zx *. zx +. zy *. zy >. 4.0 {
    True -> count
    False -> {
      let temp = zx *. zx -. zy *. zy +. cx
      let new_zy = 2.0 *. zx *. zy +. cy
      let new_zx = temp
      escape_time_tail(cx, cy, max_iter, count + 1, new_zx, new_zy)
    }
  }
}

// Map iterations to grayscale value (0-255)
pub fn intensity(iterations: Int, max_iter: Int) -> Float {
  case iterations == max_iter {
    True -> 0.0
    False -> int_to_float(iterations) /. int_to_float(max_iter)
  }
}

// Helper function to convert Int to Float
fn int_to_float(i: Int) -> Float {
  int.to_float(i)
}

// Helper function to round a Float to an Int
fn round_float_to_int(f: Float) -> Int {
  let truncated = float.truncate(f)
  let fractional_part = f -. int.to_float(truncated)

  case fractional_part >=. 0.5 {
    True -> truncated + 1
    False -> truncated
  }
}

// Math to make the rendering have vivid colors and smooth gradients
pub fn get_colors(intensity) -> BitArray {
  let r =
    round_float_to_int(
      9.0
      *. { 1.0 -. intensity }
      *. result.unwrap(float.power(intensity, 3.0), 1.0)
      *. 255.0,
    )
  let g =
    round_float_to_int(
      15.0
      *. result.unwrap(float.power({ 1.0 -. intensity }, 2.0), 1.0)
      *. result.unwrap(float.power(intensity, 2.0), 1.0)
      *. 255.0,
    )
  let b =
    round_float_to_int(
      8.5
      *. result.unwrap(float.power({ 1.0 -. intensity }, 3.0), 1.0)
      *. intensity
      *. 255.0,
    )

  <<r:8, g:8, b:8>>
}

// Write PNG file
fn write_png_file(
  filename: String,
  width: Int,
  height: Int,
  image_data: List(List(Float)),
) {
  // Convert each row into a packed BitArray
  let packed_data =
    image_data
    |> list.map(fn(row) {
      row
      |> list.fold(<<>>, fn(acc, intensity) {
        // Add RGB values for the grayscale pixel to the current row's BitArray
        bit_array.append(acc, get_colors(intensity))
      })
    })

  // Write the packed data to a PNG file using pngleam
  let _ =
    pngleam.from_packed(
      width: width,
      height: height,
      color_info: pngleam.rgb_8bit,
      compression_level: pngleam.default_compression,
      row_data: packed_data,
    )
    |> simplifile.write_bits(filename, _)
}
