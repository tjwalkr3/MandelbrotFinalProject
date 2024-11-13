// src/mandelbrot/mod.rs
pub mod mandelbrot; // Expose mandelbrot as a submodule

// Re-export functions to make them accessible from `mandelbrot::`
pub use mandelbrot::*;
