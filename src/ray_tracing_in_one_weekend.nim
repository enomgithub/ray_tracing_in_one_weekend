import std/algorithm
import std/sequtils
import std/strformat
import std/terminal

import camera
import color
import hittable
import hittable_list
import ray
import rtweekend
import sphere
import vec3 


func getColor(r: Ray, world: HittableList): Color =
  var rec: HitRecord
  if hit(world, r, 0, Inf, rec):
    return 0.5 * (rec.normal.toColor + newColor(1, 1, 1))

  let
    unitDirection = r.direction.unit
    t = 0.5 * (unitDirection.y + 1.0)

  (1.0 - t) * newColor(1.0, 1.0, 1.0) + t * newColor(0.5, 0.7, 1.0)


proc main(): cint =
  const
    aspectRatio = 16.0 / 9.0
    imageWidth = 400
    imageHeight = (imageWidth / aspectRatio).int
    samplesPerPixel = 100

  let world = newHittableList[Sphere]()
  world.add(newSphere(newPoint3(0, 0, -1), 0.5))
  world.add(newSphere(newPoint3(0, -100.5, -1), 100))

  let camera = newCamera()

  echo "P3"
  echo fmt"{imageWidth} {imageHeight}"
  echo "255"
  for j in (0..<imageHeight).toSeq.reversed:
    stderr.styledWriteLine(fgRed, "Scanlines remaining: ", resetStyle, fmt"{j}")
    for i in 0..<imageWidth:
      var pixelColor = newColor(0, 0, 0)
      for s in 0..<samplesPerPixel:
        let
          u = (i.float + randomFloat()) / (imageWidth - 1)
          v = (j.float + randomFloat()) / (imageHeight - 1)
          ray = camera.getRay(u, v)
        pixelColor += ray.getColor(world)

      stdout.writeColor(pixelColor, samplesPerPixel)

    stderr.cursorUp(1)
    stderr.eraseLine
  
  stderr.styledWriteLine(fgRed, "Done")

  0


when isMainModule:
  quit(main())
