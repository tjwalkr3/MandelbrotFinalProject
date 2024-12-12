namespace Mandelbrot;
using CommandLine;
using static Mandelbrot.MandelbrotLib;

class MandelbrotApp
{
	public class Options
	{
		[Option('x', "width", Required = false, Default = 9600, HelpText = "Width of the output image.")]
		public int Width { get; set; }

		[Option('y', "height", Required = false, Default = 5400, HelpText = "Height of the output image.")]
		public int Height { get; set; }

		[Option('i', "iterations", Required = false, Default = 35, HelpText = "Maximum iterations for the escape-time algorithm.")]
		public int MaxIterations { get; set; }

        [Option('z', "zoom", Required = false, Default = 1.0, HelpText = "Zoom factor (larger is more zoomed in).")]
        public double Zoom { get; set; }
    }

    static void Main(string[] args)
	{
		Parser.Default.ParseArguments<Options>(args)
			.WithParsed(options =>
			{
				string filePath = Path.Combine(Environment.CurrentDirectory, "mandelbrot.png");

				// Generate the Mandelbrot set
				Console.WriteLine("Generating Mandelbrot set...");
				GenerateMandelbrotSet(options.Width, options.Height, options.MaxIterations, options.Zoom, filePath);
				Console.WriteLine($"Mandelbrot set saved to {filePath}");
			})
			.WithNotParsed(errors =>
			{
				Console.WriteLine("Invalid options provided. Use --help to view usage.");
			});
	}
}
