use image::{ImageBuffer, Rgb};
use num_complex::Complex;

mod mandelbrot;

use mandelbrot::mandelbrot::{get_image, pixel_to_complex, escape_time, get_color};

fn main() {
    let width = 16000;
    let height = 9000;
    let max_iterations = 500;

    // Define the range of the complex plane
    let min_real = -2.5;
    let max_real = 1.0;
    let min_imag = -1.125;
    let max_imag = 1.125;

    let img = get_image(
        width,
        height,
        max_iterations,
        min_real,
        max_real,
        min_imag,
        max_imag,
    );
    img.save("mandelbrot.png").expect("Failed to save image");
}

