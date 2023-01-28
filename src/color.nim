import std/math
import std/strformat
import std/terminal

import types
import vec3


proc writeColor*(stream: File, pixelColor: Color, samplesPerPixel: int) =
  let
    scale = 1.0 / samplesPerPixel.float
    r = (256 * clamp(sqrt(scale * pixelColor.r), 0.0, 0.999)).int
    g = (256 * clamp(sqrt(scale * pixelColor.g), 0.0, 0.999)).int
    b = (256 * clamp(sqrt(scale * pixelColor.b), 0.0, 0.999)).int

  stream.styledWriteLine(fmt"{r} {g} {b}")
