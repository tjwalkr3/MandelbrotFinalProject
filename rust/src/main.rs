use image::{ImageBuffer, Rgb};
use num_complex::Complex;

fn main() {
    let width = 1920;
    let height = 1080;
    let max_iterations = 255;

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

// Iterate through every pixel, getting its RGB color
fn get_image(
    width: u32,
    height: u32,
    max_iterations: u32,
    min_real: f64,
    max_real: f64,
    min_imag: f64,
    max_imag: f64,
) -> ImageBuffer<Rgb<u8>, Vec<u8>> {
    let mut img = ImageBuffer::new(width, height);

    for y in 0..height {
        for x in 0..width {
            let c = pixel_to_complex(x, y, width, height, min_real, max_real, min_imag, max_imag);
            let iterations = escape_time(c, max_iterations);
            let color = get_color(iterations, max_iterations);
            img.put_pixel(x, y, color);
        }
    }

    img
}

// Map a pixel coordinate to a point on the complex plane (within the desired range)
fn pixel_to_complex(
    x: u32,
    y: u32,
    width: u32,
    height: u32,
    min_real: f64,
    max_real: f64,
    min_imag: f64,
    max_imag: f64,
) -> Complex<f64> {
    let real = min_real + (x as f64 / width as f64) * (max_real - min_real);
    let imag = min_imag + (y as f64 / height as f64) * (max_imag - min_imag);
    Complex::new(real, imag)
}

// Calculate the number of iterations it takes to escape the mandelbrot set (max_iterations means it didn't escape)
fn escape_time(c: Complex<f64>, max_iterations: u32) -> u32 {
    let mut z = Complex::new(0.0, 0.0);
    let mut iterations = 0;

    while iterations < max_iterations && z.norm_sqr() <= 4.0 {
        z = z * z + c;
        iterations += 1;
    }
    iterations
}

// Get the color of the pixel based on the iterations it took to escape the mandelbrot set
fn get_color(iterations: u32, max_iterations: u32) -> Rgb<u8> {
    let intensity = (iterations as f32 / max_iterations as f32).sqrt();

    if iterations < max_iterations {
        let r = (9.0 * (1.0 - intensity) * intensity.powf(3.0) * 255.0) as u8;
        let g = (15.0 * (1.0 - intensity).powf(2.0) * intensity.powf(2.0) * 255.0) as u8;
        let b = (8.5 * (1.0 - intensity).powf(3.0) * intensity * 255.0) as u8;
        Rgb([r, g, b])
    } else {
        Rgb([0, 0, 0])
    }
}
