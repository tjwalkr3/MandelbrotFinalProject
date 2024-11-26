// mandelbrot_tests.rs
use image:: Rgb;
use num_complex::Complex;
use mandelbrot_renderer::mandelbrot::{pixel_to_complex, escape_time, get_color};

#[test]
fn test_pixel_to_complex() {
    let width = 16000;
    let height = 9000;
    let min_real = -2.5;
    let max_real = 1.0;
    let min_imag = -1.125;
    let max_imag = 1.125;

    let complex_point = pixel_to_complex(8000, 4500, width, height, min_real, max_real, min_imag, max_imag);
    assert!((complex_point.re - (-0.75)).abs() < 1e-5);
    assert!((complex_point.im - 0.0).abs() < 1e-5);
}

#[test]
fn test_escape_time() {
    let c_in_set = Complex::new(0.0, 0.0);
    let c_out_of_set = Complex::new(2.0, 2.0);
    let max_iterations = 500;

    assert_eq!(escape_time(c_in_set, max_iterations), max_iterations);
    assert!(escape_time(c_out_of_set, max_iterations) < max_iterations);
}

#[test]
fn test_get_color() {
    let max_iterations = 500;

    let color = get_color(max_iterations, max_iterations);
    assert_eq!(color, Rgb([0, 0, 0]));

    let color = get_color(250, max_iterations);
    assert!(color[0] > 0 || color[1] > 0 || color[2] > 0);
}