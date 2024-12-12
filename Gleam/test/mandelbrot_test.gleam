import gleam/list
import gleeunit
import gleeunit/should
import mandelbrot

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`

pub fn escape_time_test() {
  // Test points that escape quickly
  mandelbrot.escape_time(0.0, 2.0, 50)
  |> should.equal(2)

  mandelbrot.escape_time(1.5, 0.5, 50)
  |> should.equal(2)
  // Test a point that is inside the Mandelbrot set
  mandelbrot.escape_time(0.0, 0.0, 50)
  |> should.equal(50)

  // Test boundary point
  mandelbrot.escape_time(-0.75, 0.1, 50)
  |> should.equal(33)
}

pub fn intensity_test() {
  mandelbrot.intensity(50, 50)
  |> should.equal(0.0)

  mandelbrot.intensity(25, 50)
  |> should.equal(0.5)

  mandelbrot.intensity(50, 100)
  |> should.equal(0.5)

  mandelbrot.intensity(25, 100)
  |> should.equal(0.25)
}

// Test intensity mapping to RGB
pub fn get_colors_test() {
  let low_intensity = mandelbrot.get_colors(0.0) // Black
  let mid_intensity = mandelbrot.get_colors(0.5) // Mid gradient
  let high_intensity = mandelbrot.get_colors(1.0) // Brightest

  low_intensity
  |> should.equal(<<0:8, 0:8, 0:8>>)

  low_intensity
  |> should.not_equal(mid_intensity)

  mid_intensity
  |> should.not_equal(high_intensity)
}

// Generate a very small Mandelbrot set
pub fn generate_mandelbrot_test() {
  let width = 10
  let height = 10
  let max_iter = 10
  let zoom = 1.0
  let data = mandelbrot.generate_mandelbrot(width, height, max_iter, zoom)

  // Ensure dimensions are correct
  list.length(data)
  |> should.equal(10)

  list.each(data, fn (y) {
    list.length(y)
    |> should.equal(10)
  })
}
