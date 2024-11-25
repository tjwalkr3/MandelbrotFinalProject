import gleam/io

pub fn main() {
  io.println("Hello from mandelbrot!")
  MandelbrotExample.generate()
}

defmodule MandelbrotExample do
  def generate do
    :mandelbrot
    |> :generate_mandelbrot_png.("mandelbrot.png", 800, 600, 1000, -2.5, 1.0, -1.0, 1.0)
    |> case do
      {:ok, _} -> IO.puts("Mandelbrot PNG generated successfully!")
      {:error, reason} -> IO.puts("Failed to generate PNG: #{reason}")
    end
  end
end
