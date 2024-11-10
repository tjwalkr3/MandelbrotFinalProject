package main

import (
	"image"
	"image/color"
	"image/png"
	"math/cmplx"
	"os"
)

// Parameters for rendering
const (
	width       = 10000     // Image width
	height      = 10000    // Image height
	xMin, xMax  = -2.5, 1 // Real axis range
	yMin, yMax  = -1.25, 1.25 // Imaginary axis range
	maxIter     = 1000    // Maximum number of iterations
	escapeRadius = 2.0    // Escape radius
)

func main() {
	// Create a new blank image
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	// Iterate over each pixel in the image
	for px := 0; px < width; px++ {
		for py := 0; py < height; py++ {
			// Map pixel coordinates to the complex plane
			x := xMin + (xMax-xMin)*float64(px)/float64(width)
			y := yMin + (yMax-yMin)*float64(py)/float64(height)
			c := complex(x, y)

			// Calculate escape time for point c
			color := mandelbrot(c)

			// Set pixel color in the image
			img.Set(px, py, color)
		}
	}

	// Save the image to file
	f, err := os.Create("mandelbrot.png")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	// Encode the image as PNG
	if err := png.Encode(f, img); err != nil {
		panic(err)
	}

	println("Mandelbrot image saved as mandelbrot.png")
}

// mandelbrot computes the escape time and returns a color based on iterations
func mandelbrot(c complex128) color.Color {
	var z complex128
	for n := 0; n < maxIter; n++ {
		distance := cmplx.Abs(z)
		if distance > escapeRadius {
			c := uint8(255 * (distance / escapeRadius))
			return color.RGBA{255, 0, 0, c}
		}
		z = z*z + c
	}
	// Return black if point is in the Mandelbrot set
	return color.Black
}

