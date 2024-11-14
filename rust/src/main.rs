use clap::{Arg, Command};
use mandelbrot_renderer::mandelbrot::get_image;
use image::RgbImage;

fn main() {
    // Set up Clap to handle command-line arguments
    let matches = Command::new("Mandelbrot Renderer")
        .version("1.0")
        .author("Thomas Jones <thomas.jones1@students.snow.edu>")
        .about("Generates a Mandelbrot set image")
        .arg(
            Arg::new("width")
                .short('w')
                .long("width")
                .value_name("WIDTH")
                .default_value("1920")
                .help("The width of the output image")
                .value_parser(clap::value_parser!(u32))
        )
        .arg(
            Arg::new("height")
                .short('y')
                .long("height")
                .value_name("HEIGHT")
                .default_value("1080")
                .help("The height of the output image")
                .value_parser(clap::value_parser!(u32))
        )
        .arg(
            Arg::new("zoom")
                .short('z')
                .long("zoom")
                .value_name("ZOOM")
                .default_value("1.0")
                .help("The zoom level for the image (affects the complex plane range)")
                .value_parser(clap::value_parser!(f64))
        )
        .arg(
            Arg::new("max_iterations")
                .short('i')
                .long("iterations")
                .value_name("MAX_ITERATIONS")
                .default_value("500")
                .help("The maximum number of iterations to calculate for each pixel")
                .value_parser(clap::value_parser!(u32))
        )
        .get_matches();

    // Parse the width, height, zoom, and max_iterations from the command-line arguments
    let width: u32 = matches.get_one::<u32>("width").copied().unwrap();
    let height: u32 = matches.get_one::<u32>("height").copied().unwrap();
    let zoom: f64 = matches.get_one::<f64>("zoom").copied().unwrap();
    let max_iterations: u32 = matches.get_one::<u32>("max_iterations").copied().unwrap();

    // Define the center of the set and adjust for zoom
    let center_real = -0.75;
    let center_imag = 0.0;

    // Adjust the range for real and imaginary axes based on zoom
    let real_range = 3.5 / zoom;  // The total real range (width)
    let imag_range = 2.25 / zoom;  // The total imaginary range (height)

    // Adjust the coordinates based on the zoom factor
    let min_real = center_real - real_range / 2.0;
    let max_real = center_real + real_range / 2.0;
    let min_imag = center_imag - imag_range / 2.0;
    let max_imag = center_imag + imag_range / 2.0;

    // Generate the image
    let img: RgbImage = get_image(
        width,
        height,
        max_iterations,
        min_real,
        max_real,
        min_imag,
        max_imag,
    );

    // Save the generated image
    img.save("mandelbrot.png").expect("Failed to save image");

    println!("Mandelbrot image generated: mandelbrot.png");
}
