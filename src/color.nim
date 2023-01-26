import std/strformat
import std/terminal

import vec3


proc writeColor*(stream: File, pixelColor: Color) =
  let
    r = (255.999 * pixelColor.r).int
    g = (255.999 * pixelColor.g).int
    b = (255.999 * pixelColor.b).int
  stream.styledWriteLine(fmt"{r} {g} {b}")
