using SkiaSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Mandelbrot;

public static class MandelbrotLib
{

	public static void GenerateMandelbrotSet(int width, int height, int maxIterations, string filePath)
	{
		using var bitmap = new SKBitmap(width, height);

		// Define the complex plane range
		double minX = -2.5, maxX = 1;
		double minY = -1.125, maxY = 1.125;

		// Access the raw pixel buffer
		var pixels = bitmap.Pixels;

		// Parallelize computation across all pixels
		Parallel.For(0, height, py =>
		{
			int rowOffset = py * width;

			for (int px = 0; px < width; px++)
			{
				// Map pixel to complex plane
				double x0 = Map(px, 0, width, minX, maxX);
				double y0 = Map(py, 0, height, minY, maxY);

				// Compute the number of iterations
				int iterations = EscapeTime(x0, y0, maxIterations);

				// Calculate the color based on the number of iterations
				SKColor color = CalculateColor(iterations, maxIterations);

				// Write the color directly into the buffer
				pixels[rowOffset + px] = color;
			}
		});

		// Write the buffer back to the bitmap
		bitmap.Pixels = pixels;

		// Save the bitmap to the file
		using var data = SKImage.FromBitmap(bitmap).Encode(SKEncodedImageFormat.Png, 100);
		File.WriteAllBytes(filePath, data.ToArray());
	}

	// map pixel values (x or y) to complex plane coordinates (real or imaginary)
	public static double Map(int value, int minSrc, int maxSrc, double minDst, double maxDst)
	{
		return minDst + (value - minSrc) * (maxDst - minDst) / (maxSrc - minSrc);
	}

	// get the number of iterations it takes to escape the mandelbrot set
	public static int EscapeTime(double x0, double y0, int maxIterations)
	{
		double x = 0, y = 0;
		int iterations = 0;

		// loop until point escapes set or hits max iterations (whichever comes first)
		while (x * x + y * y <= 4 && iterations < maxIterations)
		{
			double tempX = x * x - y * y + x0;
			y = 2 * x * y + y0;
			x = tempX;
			iterations++;
		}

		return iterations;
	}

	// based on the number of iterations it took to escape the mandelbrot set, generate a pixel color
	public static SKColor CalculateColor(int iterations, int maxIterations)
	{
		if (iterations == maxIterations)
		{
			return SKColors.Black; // Inside the set
		}

		// Generate RGB values for a colorful gradient
		double t = (double)iterations / maxIterations;
		byte r = (byte)(9 * (1 - t) * t * t * t * 255);
		byte g = (byte)(15 * (1 - t) * (1 - t) * t * t * 255);
		byte b = (byte)(8.5 * (1 - t) * (1 - t) * (1 - t) * t * 255);

		return new SKColor(r, g, b);
	}
}
