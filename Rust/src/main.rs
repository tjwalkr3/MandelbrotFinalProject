use clap::{Arg, Command};
use mandelbrot_renderer::mandelbrot::get_image;
use image::RgbImage;

fn main() {
    let matches = Command::new("Mandelbrot Renderer")
        .version("1.0")
        .author("Thomas Jones <thomas.jones1@students.snow.edu>")
        .about("Generates a Mandelbrot set image")
        .arg(
            Arg::new("width")
                .short('x')
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
                .default_value("35")
                .help("The maximum number of iterations to calculate for each pixel")
                .value_parser(clap::value_parser!(u32))
        )
        .get_matches();

    // Parse the width, height, zoom, and max_iterations from the command-line arguments
    let width: u32 = matches.get_one::<u32>("width").copied().unwrap();
    let height: u32 = matches.get_one::<u32>("height").copied().unwrap();
    let zoom: f64 = matches.get_one::<f64>("zoom").copied().unwrap();
    let max_iterations: u32 = matches.get_one::<u32>("max_iterations").copied().unwrap();

    // Generate the image
    let img: RgbImage = get_image(width, height, max_iterations, zoom);

    // Save the generated image
    img.save("mandelbrot.png").expect("Failed to save image");

    println!("Mandelbrot image generated: mandelbrot.png");
}
