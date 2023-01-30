import std/math
import std/strformat
import std/terminal

import types
import vec3


func newRGBColor*(r, g, b: int = 0): RGBColor =
  RGBColor(r: r, g: g, b: b)

func `$`*(color: RGBColor): string =
  fmt"{color.r} {color.g} {color.b}"

func `+`*(self, color: RGBColor): RGBColor =
  newRGBColor(self.r + color.r, self.g + color.g, self.b + color.b)

func `/`*(self: RGBColor, n: int): RGBColor =
  newRGBColor(self.r div n, self.g div n, self.b div n)

func `+=`*(self: var RGBColor, color: RGBColor) =
  self = self + color

func getRGB*(pixelColor: Color, samplesPerPixel: int): RGBColor =
  let
    scale = 1.0 / samplesPerPixel.float
    r = (256 * clamp(sqrt(scale * pixelColor.r), 0.0, 0.999)).int
    g = (256 * clamp(sqrt(scale * pixelColor.g), 0.0, 0.999)).int
    b = (256 * clamp(sqrt(scale * pixelColor.b), 0.0, 0.999)).int
  newRGBColor(r, g, b)


proc writeColor*(stream: File, pixelColor: Color, samplesPerPixel: int) =
  let rgbColor = pixelColor.getRGB(samplesPerPixel)
  stream.styledWriteLine($rgbColor)
