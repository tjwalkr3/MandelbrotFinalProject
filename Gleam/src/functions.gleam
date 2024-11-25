import gleam/int
import gleam/list
import gleam/float
import gleam/erlang

pub type Rgb {
  Rgb(r: Int, g: Int, b: Int)
}

// Generate the Mandelbrot set and save as PNG
pub fn generate_mandelbrot_png(
    file_path: String,
    width: Int,
    height: Int,
    max_iterations: Int,
    min_real: Float,
    max_real: Float,
    min_imag: Float,
    max_imag: Float,
) -> Result(Nil, String) {
    let image_data = get_image(width, height, max_iterations, min_real, max_real, min_imag, max_imag)
    let canvas = erlang.apply(:egd, :create, [width, height])

    // Draw pixels on the canvas
    list.range(0, height - 1)
    |> list.each(fn y ->
        list.range(0, width - 1)
        |> list.each(fn x ->
            let Rgb(r, g, b) = image_data[y][x]
            let color = erlang.apply(:egd, :color, [{r, g, b}])
            erlang.apply(:egd, :point, [canvas, {x, y}, color])
        end)
    end)

    // Save the canvas as a PNG
    let binary = erlang.apply(:egd, :render, [canvas])
    let result = erlang.apply(:file, :write_file, [file_path, binary])
    case result {
      Ok(_) -> Ok(Nil)
      Error(reason) -> Error("Failed to save file: \(reason)")
    }
}

// Generate Mandelbrot set pixel data
fn get_image(
    width: Int,
    height: Int,
    max_iterations: Int,
    min_real: Float,
    max_real: Float,
    min_imag: Float,
    max_imag: Float,
) -> List(List(Rgb)) {
    list.range(0, height - 1)
    |> list.map(fn y ->
        list.range(0, width - 1)
        |> list.map(fn x ->
            let c = pixel_to_complex(x, y, width, height, min_real, max_real, min_imag, max_imag)
            let iterations = escape_time(c, max_iterations)
            get_color(iterations, max_iterations)
        end)
    end)
}

// Map a pixel coordinate to a point on the complex plane
fn pixel_to_complex(
    x: Int,
    y: Int,
    width: Int,
    height: Int,
    min_real: Float,
    max_real: Float,
    min_imag: Float,
    max_imag: Float,
) -> { real: Float, imag: Float } {
    let real = min_real + (float.from_int(x) / float.from_int(width)) * (max_real - min_real)
    let imag = min_imag + (float.from_int(y) / float.from_int(height)) * (max_imag - min_imag)
    { real, imag }
}

// Calculate the number of iterations it takes to escape the Mandelbrot set
fn escape_time(c: { real: Float, imag: Float }, max_iterations: Int) -> Int {
    let z = { real: 0.0, imag: 0.0 }
    let rec loop(z, iterations) {
        if iterations >= max_iterations || z.real * z.real + z.imag * z.imag > 4.0 {
            iterations
        } else {
            let next_z = {
                real: z.real * z.real - z.imag * z.imag + c.real,
                imag: 2.0 * z.real * z.imag + c.imag
            }
            loop(next_z, iterations + 1)
        }
    }
    loop(z, 0)
}

// Get the color based on the number of iterations
fn get_color(iterations: Int, max_iterations: Int) -> Rgb {
    let intensity = float.sqrt(float.from_int(iterations) / float.from_int(max_iterations))
    if iterations < max_iterations {
        let r = int.floor(9.0 * (1.0 - intensity) * intensity ** 3.0 * 255.0) |> int.clamp(0, 255)
        let g = int.floor(15.0 * (1.0 - intensity) ** 2.0 * intensity ** 2.0 * 255.0) |> int.clamp(0, 255)
        let b = int.floor(8.5 * (1.0 - intensity) ** 3.0 * intensity * 255.0) |> int.clamp(0, 255)
        Rgb(r, g, b)
    } else {
        Rgb(0, 0, 0)
    }
}
