# Mandelbrot Set Rendering Tool
## Languages
I will be implementing the Mandelbrot set rendering tool in Python with KlongPy, GoLang, and C#.

## Method:
I will do this using the escape-time algorithm.  This algorithm is as follows:
Iterate through a grid of coordinates in the complex plane.  Each coordinate will represent a pixel in the rendered image.  For each coordinate, the distance to the center of the graph is calculated.  The point is then transformed using the equation Z = Z² + C, where C is the initial point being tested, and Z is an iterative variable that changes with each iteration.  These two steps are to be repeated until the distance is greater than some threshold (example: 2).  If the distance to the center of the graph never reaches the threshold within a set number of iterations (example: 1000), the point is in the Mandelbrot set, and is colored accordingly.  If the distance to the center of the graph exceeds the threshold, it has "escaped" the Mandelbrot set, and is colored accordingly.  This is done for every coordinate (pixel) within the viewing area.  The Mandelbrot set can be rendered in a single pass in two colors, or it can be computed in multiple passes with multiple threshold values to create a gradient.  

## Intended User:
Anyone who is interested in fractals or the mathematics behind them.  No knowledge of programming or the escape time algorithm will be required to use these applications.  

## Functional Requirements:
The code should implement the escape-time algorithm.
For the purposes of this project, I will render the Mandelbrot set in (at least) a single pass and return it in the form of an image. 
The range rendered can be changed (either through command line arguments or input from the user). 

## Non-Functional Requirements:
The image should also generate within a reasonable amount of time after the user requests it. 
Where user input is required (e.g., specifying range or resolution), the input process should be intuitive and documented, with meaningful feedback for invalid inputs. 
The threshold value(s) used should be optimized to visually enhance the structure of the Mandelbrot set, and show the most detail.  

## Motivation:
I have always been fascinated with fractals.  In high school, I had a Mandelbrot viewer on my laptop, and I would use it to generate cool desktop backgrounds.  Now that I understand the math behind the Mandelbrot set, I want to render it myself.  
