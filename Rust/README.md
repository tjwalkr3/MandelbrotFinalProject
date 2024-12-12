## Running The Code
Before starting, you will want to install Rust and Cargo.  Do so by running the following command:
```bash
curl https://sh.rustup.rs -sSf | sh
```

To run the code, enter the Rust project's directory and run the following command:
```bash
cargo run -- [parameters]
```
The optional parameters are passed in the following format:
```bash
Usage: mandelbrot_renderer [OPTIONS]

Options:
  -x, --width <WIDTH>                The width of the output image [default: 1920]
  -y, --height <HEIGHT>              The height of the output image [default: 1080]
  -z, --zoom <ZOOM>                  The zoom level for the image (affects the complex plane range) [default: 1.0]
  -i, --iterations <MAX_ITERATIONS>  The maximum number of iterations to calculate for each pixel [default: 500]
  -h, --help                         Print help
  -V, --version                      Print version
```

## Running the Tests

To run the tests, enter the Rust project's directory and run the following command:
```bash
cargo test
```

This will run all of the tests in the tests folder. 
