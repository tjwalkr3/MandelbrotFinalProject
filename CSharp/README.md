## Running the Program
To run the program, you will need the dotnet sdk installed on your computer. This can be found at [Microsoft's Website](https://dotnet.microsoft.com/en-us/download).   
From the folder with the Mandelbrot.sln file in it, run the following command to run the project:
```bash
dotnet run --project Mandelbrot -- [parameters]
```
The optional parameters can be passed into the command line as follows:
(this is the help dialog that can be accessed by passing in --help)
```bash
Mandelbrot 1.0.0+50a7cbaa479e23d6f7b52622bcb3fc95d31dd5b2
Copyright (C) 2024 Mandelbrot

  -x, --width         (Default: 9600) Width of the output image.

  -y, --height        (Default: 5400) Height of the output image.

  -i, --iterations    (Default: 35) Maximum iterations for the escape-time algorithm.

  -z, --zoom          (Default: 1) Zoom factor (larger is more zoomed in).

  --help              Display this help screen.

  --version           Display version information.
```

## Test the Project
From the folder with the Mandelbrot.sln file in it, run the following command to test the project:
```bash
dotnet test
```
