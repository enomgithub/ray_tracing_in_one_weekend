import std/algorithm
import std/sequtils
import std/strformat
import std/terminal

import color
import ray
import vec3 


func rayColor(r: Ray): Color =
  let
    unitDirection = r.direction().unit()
    t = 0.5 * (unitDirection.y + 1.0)

  (1.0 - t) * newColor(1.0, 1.0, 1.0) + t * newColor(0.5, 0.7, 1.0)


proc main(): cint =
  const
    aspectRatio = 16.0 / 9.0
    imageWidth = 400
    imageHeight = (imageWidth / aspectRatio).int

    viewportHeight = 2.0
    viewportWidth = aspectRatio * viewportHeight
    focalLength = 1.0

    origin = newPoint3(0, 0, 0)
    horizontal = newVec3(viewportWidth, 0, 0)
    vertical = newVec3(0, viewportHeight, 0)
    lowerLeftCorner = origin - horizontal / 2 - vertical / 2 - newVec3(0, 0, focalLength)

  echo "P3"
  echo fmt"{imageWidth} {imageHeight}"
  echo "255"
  for j in (0..<imageHeight).toSeq().reversed():
    stderr.styledWriteLine(fgRed, "Scanlines remaining: ", resetStyle, fmt"{j}")
    for i in 0..<imageWidth:
      let
        u = (i / (imageWidth - 1)).float
        v = (j / (imageHeight - 1)).float
        r = newRay(origin, lowerLeftCorner + u * horizontal + v * vertical - origin)
        pixelColor = rayColor(r)

      writeColor(stdout, pixelColor)

    stderr.cursorUp(1)
    stderr.eraseLine()
  
  stderr.styledWriteLine(fgRed, "Done")

  0


when isMainModule:
  quit(main())
