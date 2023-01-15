import std/algorithm
import std/math
import std/sequtils
import std/strformat
import std/terminal

import color
import ray
import vec3 


func hitSphere(center: Point3, radius: float, r: Ray): float =
  let
    oc = r.origin - center
    a = r.direction.lengthSquared
    halfB = oc.toVec.dot r.direction
    c = oc.toVec.lengthSquared - radius * radius
    discriminant = halfB * halfB - a * c

  if discriminant < 0: -1.0
  else: (-halfB - discriminant.sqrt) / a


func rayColor(r: Ray): Color =
  let t = hitSphere(newPoint3(0, 0, -1), 0.5, r)
  if t > 0.0:
    let n = r.at(t).toVec.unit - newVec3(0, 0, -1)
    0.5 * newColor(n.x + 1, n.y + 1, n.z + 1)
  else:
    let
      unitDirection = r.direction.unit
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

  let
    origin = newPoint3(0, 0, 0)
    horizontal = newVec3(viewportWidth, 0, 0)
    vertical = newVec3(0, viewportHeight, 0)
    lowerLeftCorner = origin.toVec - horizontal / 2 - vertical / 2 - newVec3(0, 0, focalLength)

  echo "P3"
  echo fmt"{imageWidth} {imageHeight}"
  echo "255"
  for j in (0..<imageHeight).toSeq.reversed:
    stderr.styledWriteLine(fgRed, "Scanlines remaining: ", resetStyle, fmt"{j}")
    for i in 0..<imageWidth:
      let
        u = (i / (imageWidth - 1)).float
        v = (j / (imageHeight - 1)).float
        r = newRay(origin, lowerLeftCorner + u * horizontal + v * vertical - origin.toVec)
        pixelColor = rayColor(r)

      writeColor(stdout, pixelColor)

    stderr.cursorUp(1)
    stderr.eraseLine
  
  stderr.styledWriteLine(fgRed, "Done")

  0


when isMainModule:
  quit(main())
