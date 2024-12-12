## Running the Program

Before you can run the code, install gleam.  I found it easiest to install Gleam from the Homebrew package manager (all other methods did not work in the latest version of Ubuntu).  So, first install brew using the following command:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Then install build-essential with the commands:
```bash
sudo apt update
sudo apt install build-essential
```
Then install gleam with the following commands:
```bash
brew update
brew install gleam
```
Now you can run the program:
```bash
gleam run -- [args]
```
The arguments are formatted like the following:
(get this menu by running `gleam run -- -h`)
```bash
mandelbrot

  Render the Mandelbrot set as a PNG.

Usage:

  mandelbrot [OPTIONS]

Options:

  [--width,-x WIDTH]            Width of the image. (default: 1920)
  [--height,-y HEIGHT]          Height of the image. (default: 1080)
  [--iterations,-i ITERATIONS]  Number of iterations. (default: 35)
  [--zoom,-z ZOOM]              Zoom factor (larger is more zoomed in). (default: 1.0)
  [--help,-h]                   Print this help
```

## Testing the Program
To run all of the tests in the project, run the command:
```bash
gleam test
```
This will run all of the tests in the test folder. 
