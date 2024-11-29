namespace Mandelbrot;

using System.Diagnostics;
using System.Runtime.InteropServices;
using CommandLine;
using static Mandelbrot.MandelbrotLib;

class MandelbrotApp
{
	public class Options
	{
		[Option('w', "width", Required = false, Default = 1920, HelpText = "Width of the output image.")]
		public int Width { get; set; }

		[Option('h', "height", Required = false, Default = 1080, HelpText = "Height of the output image.")]
		public int Height { get; set; }

		[Option('i', "iterations", Required = false, Default = 1000, HelpText = "Maximum iterations for the escape-time algorithm.")]
		public int MaxIterations { get; set; }
	}

	static void Main(string[] args)
	{
		Parser.Default.ParseArguments<Options>(args)
			.WithParsed(options =>
			{
				// Parse CLI options
				int width = options.Width;
				int height = options.Height;
				int maxIterations = options.MaxIterations;
				string filePath = Path.Combine(Environment.CurrentDirectory, "mandelbrot.png");

				// Generate the Mandelbrot set
				Console.WriteLine("Generating Mandelbrot set...");
				GenerateMandelbrotSet(width, height, maxIterations, filePath);

				Console.WriteLine($"Mandelbrot set saved to {filePath}");
			})
			.WithNotParsed(errors =>
			{
				Console.WriteLine("Invalid options provided. Use --help to view usage.");
			});
	}
}
